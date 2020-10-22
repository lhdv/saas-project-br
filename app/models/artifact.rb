class Artifact < ApplicationRecord
  MAX_FILESIZE = 10.megabytes
  
  attr_accessor :upload

  belongs_to :project

  before_save :upload_to_s3
  validates :name, presence: true
  validates :name, uniqueness: true

  validates :upload, presence: true

  validate :uploaded_file_size

  private

  def upload_to_s3
    s3 = Aws::S3::Resource.new(region: Rails.application.credentials.aws[:aws_region])
    tenant_name = Tenant.find(Thread.current[:tenant_id]).name
    obj = s3.bucket(Rails.application.credentials.aws[:s3_bucket]).object("#{tenant_name}/#{upload.original_filename}")  
    obj.upload_file(upload.path, acl:'public-read')
    self.key = obj.public_url
  end

  def uploaded_file_size
    if upload
      errors.add(:upload, "File too large. Must be less than #{self.class::MAX_FILESIZE}") unless upload.size <= self.class::MAX_FILESIZE
    end
  end
end

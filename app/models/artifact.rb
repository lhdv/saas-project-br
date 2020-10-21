class Artifact < ApplicationRecord
  MAX_FILESIZE = 10.megabytes
  
  attr_accessor :upload

  belongs_to :project

  validates :name, presence: true
  validates :name, uniqueness: true

  validates :upload, presence: true

  validate :uploaded_file_size

  private

  def uploaded_file_size
    if upload
      errors.add(:upload, "File too large. Must be less than #{self.class::MAX_FILESIZE}") unless upload.size <= self.class::MAX_FILESIZE
    end
  end
end

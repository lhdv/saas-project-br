class Plan
  PLANS = [:free, :premium]

  def self.options
    PLANS.map { |p| [p.capitalize, p] }
  end
end
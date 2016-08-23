class CostGarland
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :text, default: '<div></div>'
  field :setting, type: Boolean, default: true

  validates_uniqueness_of :setting


  def self.banner
    create if all.count <= 0
    all.first
  end
end
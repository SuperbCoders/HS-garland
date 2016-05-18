class Setting
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :setting, type: Boolean, default: true
  field :delivery_moscow, type: Integer, default: 500
  field :delivery_free_limit, type: Integer, default: 6000
  field :guaranty_amount, type: Integer, default: 12000

  validates_uniqueness_of :setting


  def self.general
    create if all.count <= 0
    all.first
  end
end

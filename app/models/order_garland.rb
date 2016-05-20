class OrderGarland
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  belongs_to :order
  belongs_to :garland_price
  belongs_to :lamp_price
end

class Admin::OrderGarlandSerializer < Admin::BaseSerializer
  attributes :garland_price, :lamp_price

  has_one :garland_price, serializer: Admin::GarlandPriceSerializer
  has_one :lamp_price, serializer: Admin::LampPriceSerializer
end

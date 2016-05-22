class Admin::OrderGarlandSerializer < Admin::BaseSerializer
  attributes :garland_price, :lamp_price

  def lamp_price
    serialize_resource(object.lamp_price, Admin::LampPriceSerializer)
  end

  def garland_price
    serialize_resource(object.garland_price, Admin::GarlandPriceSerializer)
  end
end

class Admin::OrderGarlandSerializer < Admin::BaseSerializer
  attributes :garland_price, :lamp_price

  def lamp_price
    serialize_resource(LampPrice.unscoped.find(object.lamp_price_id), Admin::LampPriceSerializer)
  end

  def garland_price
    serialize_resource(GarlandPrice.unscoped.find(object.garland_price_id), Admin::GarlandPriceSerializer)
  end
end

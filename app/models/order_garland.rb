class OrderGarland
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  belongs_to :order
  belongs_to :garland_price
  belongs_to :lamp_price

  field :count, type: Integer, default: 1

  def price
    if order.rent
      garland_price.rent_price + ( garland_price.lamps * lamp_price.rent_price ) * order.days
    else
      garland_price.buy_price + ( garland_price.lamps * lamp_price.buy_price )
    end
  end
end

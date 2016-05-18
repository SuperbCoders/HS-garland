class Admin::GarlandPriceSerializer < Admin::BaseSerializer
  attributes :length, :lamps, :buy_price, :rent_price, :waterproof, :name

  def name
    "#{object.length} метра"
  end

end

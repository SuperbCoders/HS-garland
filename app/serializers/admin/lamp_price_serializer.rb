class Admin::LampPriceSerializer < Admin::BaseSerializer
  attributes :power, :buy_price, :rent_price, :name

  def name
    "#{object.power} ВТ"
  end
end

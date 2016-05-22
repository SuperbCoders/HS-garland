class Admin::OrderSerializer < Admin::BaseSerializer
  attributes :total_price, :status, :rent, :customer, :order_garlands,
      :need_installation, :rain_protection, :start_date, :end_date, :days,
      :c_at

  has_many :order_garlands, serializer: Admin::OrderGarlandSerializer

  def c_at
    object.c_at.strftime("%d.%m.%Y")
  end
end

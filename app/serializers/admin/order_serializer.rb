class Admin::OrderSerializer < Admin::BaseSerializer
  attributes :total_price, :status, :rent, :customer, :order_garlands,
      :need_installation, :rain_protection, :start_date, :end_date, :days

  has_many :order_garlands, serializer: Admin::OrderGarlandSerializer

end

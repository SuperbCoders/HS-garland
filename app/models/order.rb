class Order
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include SimpleEnum::Mongoid

  field :total_price, type: Integer, default: 0
  field :start_date, type: DateTime
  field :end_date, type: DateTime
  field :days, type: Integer
  field :need_installation, type: Boolean, default: false
  field :rain_protection, type: Boolean, default: false
  field :rent, type: Boolean
  field :name
  field :email
  field :phone
  field :order_id, type: Integer

  belongs_to :customer

  has_many :order_garlands, dependent: :destroy

  as_enum :delivery, [:moscow, :moscow_out, :pickup], map: :string, source: :delivery
  as_enum :status, [:new, :confirmed, :declined], map: :string, source: :status

  before_create :set_defaults
  after_save :set_order_id

  def self.new_order(params)
    order_params = params.permit(:total_price, :start_date, :end_date, :days,
        :need_installation, :rain_protection, :rent, :phone,
        :garlands, :delivery, :name, :phone, :email)

    customer_params = params.permit(:name, :phone, :email)

    logger.info params.to_json

    order = new(order_params)
    customer = Customer.create(customer_params)
    if customer
      order.customer = customer
      order.phone = customer.phone
      order.status = :new
      if order.save
        params[:garlands].each do |garland_param|
          logger.info "Count #{garland_param[:count]}"
          logger.info "GarlandPrice #{garland_param[:length][:id]}"
          logger.info "LampPrice #{garland_param[:power][:id]}"
          og = order.order_garlands.create(count: garland_param[:count], garland_price_id: garland_param[:length][:id], lamp_price_id: garland_param[:power][:id])
          logger.info "Order Garland #{og.to_json}"
        end

        order.calc_price
        # order.order_garlands.create(garland_price_id: )
      end
    end

    order
  end

  def calc_price
    order = self
    order.total_price = 0

    # Перечисляем все заказанные гирлянды в заказе
    order_garlands.each do |order_garland|
      garland_total_price = 0

      if order.rent
        # Если заказ на аренду, то ЦЕНА_АРЕНДЫ_ГИРЛЯНДЫ + (ЦЕНА_АРЕНДЫ_ЗА_ЛАМПУ * КОЛИЧЕСТВО_ЛАМП)
        # и результат умножаем на количество дней
        garland_total_price += (order_garland.garland_price.rent_price + (order_garland.garland_price.lamps * order_garland.lamp_price.rent_price)) * order.days
        logger.info "Rent total price #{garland_total_price}"
      else
        # Если заказ на продажу, то ЦЕНА_ПОКУПКИ_ГИРЛЯНДЫ + (ЦЕНА_ПОКУПКИ_ЛАМПЫ * КОЛИЧЕСТВО_ЛАМП)
        garland_total_price += order_garland.garland_price.buy_price + (order_garland.garland_price.lamps * order_garland.lamp_price.buy_price)
        logger.info "Buy total price #{garland_total_price}"
      end

      order.total_price += garland_total_price * order_garland.count
      logger.info "Total price #{order.total_price}"
      logger.info "#{garland_total_price} | #{order_garland.count}"
    end

    if not self.rent and self.delivery == :moscow and self.total_price < Setting.general.delivery_free_limit
      logger.info "Without delivery price"
      self.total_price += Setting.general.delivery_moscow
    else
      logger.info "With delivery price"
    end

    logger.info "Total price #{total_price}"
    self.save
  end

  private

  def set_order_id
    unless self.order_id
      new_order_id = last_order_id ? last_order_id + 1 : 1
      self.update_attributes(order_id: new_order_id)
    end
  end

  def last_order_id
    Order.all.order(order_id: :desc).first.order_id
  end

  def self.order_price(order_params)
    total_price = 0

    deal_type = order_params[:rent] ? :rent_price : :buy_price

    logger.info "\n"*3
    logger.info "Calc for #{deal_type}"
    order_params[:garlands].each do |garland_param|
      garland_total_price = 0
      garland_total_price += garland_param[:length][deal_type] + (garland_param[:length][:lamps] * garland_param[:power][deal_type])


      logger.info "Garland length #{garland_param[:length][:name]} - #{garland_param[:length][deal_type]} Р + #{garland_param[:length][:lamps]} lamps * #{garland_param[:power][deal_type]} = #{garland_total_price} * #{garland_param[:count]}"
      total_price += garland_total_price * garland_param[:count]
    end


    if order_params[:delivery] == 'moscow' and total_price < Setting.general.delivery_free_limit
      total_price += Setting.general.delivery_moscow
    end

    logger.info "Total price #{total_price}"
    total_price
  end

  def set_defaults
    self.status = :new unless self.status
    self.delivery = :moscow unless self.delivery
  end
end

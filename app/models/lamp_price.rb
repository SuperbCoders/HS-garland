class LampPrice
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include SimpleEnum::Mongoid

  default_scope { where(deleted: false).order(created_at: :asc) }

  field :deleted, type: Boolean, default: false
  field :power, type: Integer
  field :buy_price, type: Integer
  field :rent_price, type: Integer

  def self.default_prices
    [
        {deleted: false, power: 25  , buy_price: 400,  rent_price: 100},
        {deleted: false, power: 50  , buy_price: 700,  rent_price: 400},
        {deleted: false, power: 75 , buy_price: 1000,  rent_price: 800},
        {deleted: false, power: 100 , buy_price: 1200,  rent_price: 1000}
    ].map { |dp| find_or_create_by(dp) }
  end
end

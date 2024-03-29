class GarlandPrice
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include SimpleEnum::Mongoid


  default_scope { where(deleted: false).order(created_at: :asc) }

  field :deleted, type: Boolean, default: false
  field :length, type: Integer
  field :lamps, type: Integer
  field :buy_price, type: Integer
  field :rent_price, type: Integer
  field :waterproof, type: Boolean, default: false

  def self.default_prices
    [
        {deleted: false, length: 3  , lamps: 3  , buy_price: 400,  rent_price: 100},
        {deleted: false, length: 5  , lamps: 7  , buy_price: 700,  rent_price: 400},
        {deleted: false, length: 15 , lamps: 9  , buy_price: 1000,  rent_price: 800},
        {deleted: false, length: 25 , lamps: 17 , buy_price: 1200,  rent_price: 1000, waterproof: true},
        {deleted: false, length: 50 , lamps: 39 , buy_price: 2100,  rent_price: 1500, waterproof: true}
    ].map { |dp| find_or_create_by(dp) }
  end
end

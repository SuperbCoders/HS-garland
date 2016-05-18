class LampPrice
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include SimpleEnum::Mongoid

  field :power, type: Integer
  field :buy_price, type: Integer
  field :rent_price, type: Integer
end

class GarlandPrice
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include SimpleEnum::Mongoid


  field :length, type: Integer
  field :lamps, type: Integer
  field :buy_price, type: Integer
  field :rent_price, type: Integer

end

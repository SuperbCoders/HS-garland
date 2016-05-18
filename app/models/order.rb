class Order
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  include SimpleEnum::Mongoid

  field :amount, type: Integer
  has_one :customer

  as_enum :status, [:new, :confirmed], map: :string, source: :status
end

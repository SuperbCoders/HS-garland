class Customer
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  field :name
  field :phone
  field :email
end

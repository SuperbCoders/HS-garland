class Admin::LampPricesController < Admin::BaseController
  include Concerns::Resource

  before_action :find_resources, only: %w(index)
  before_action :new_resource, only: %w(create new)
  before_action :find_resource, only: %w(show update destroy edit)

  def resource_scope
    LampPrice
  end

  def resource_serializer
    Admin::LampPriceSerializer
  end

  def resource_symbol
    :lamp_price
  end

  def search_by
    [:id]
  end

  def permitted_params
    [
        :power,
        :buy_price,
        :rent_price
    ]
  end
end

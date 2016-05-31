class Admin::GarlandPricesController < Admin::BaseController
  include Concerns::Resource

  before_action :find_resources, only: %w(index)
  before_action :new_resource, only: %w(create new)
  before_action :find_resource, only: %w(show update destroy edit)

  def destroy
    send_json @resource, (@resource && @resource.update_attributes(deleted: true))
  end

  def resource_scope
    GarlandPrice.where(deleted: false)
  end

  def resource_serializer
    Admin::GarlandPriceSerializer
  end

  def resource_symbol
    :garland_price
  end

  def search_by
    [:id]
  end

  def permitted_params
    [
        :length,
        :lamps,
        :buy_price,
        :rent_price
    ]
  end
end

class Admin::OrdersController < Admin::BaseController
  include Concerns::Resource

  before_action :find_resources, only: %w(index)
  before_action :new_resource, only: %w(create new)
  before_action :find_resource, only: %w(show update destroy edit)

  def statuses
    render json: Order.statuses.hash.keys
  end

  def resource_scope
    Order
  end

  def resource_serializer
    Admin::OrderSerializer
  end

  def resource_symbol
    :order
  end

  def search_by
    [:id]
  end

  def permitted_params
    [
        :status
    ]
  end
end

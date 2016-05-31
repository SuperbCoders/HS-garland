class Admin::OrdersController < Admin::BaseController
  include Concerns::Resource

  before_action :find_resources, only: %w(index)
  before_action :new_resource, only: %w(create new)
  before_action :find_resource, only: %w(show update destroy edit)

  def index
    @resources = Order.unscoped
    @resources = @resources.where(:c_at.gte => params[:date_from].to_datetime) if params[:date_from]
    @resources = @resources.where(:c_at.lte => params[:date_to]) if params[:date_to]

    render json: serialize_resources(@resources, Admin::OrderSerializer)
  end

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
    [:id, :date_from, :date_to]
  end

  def permitted_params
    [
        :status,
        :date_from,
        :date_to
    ]
  end
end

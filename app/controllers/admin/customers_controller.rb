class Admin::CustomersController < Admin::BaseController
  include Concerns::Resource

  before_action :find_resources, only: %w(index)
  before_action :new_resource, only: %w(create new)
  before_action :find_resource, only: %w(show update destroy edit)

  def resource_scope
    Customer.order(created_at: :desc)
  end

  def resource_serializer
    Admin::CustomerSerializer
  end

  def resource_symbol
    :customer
  end

  def search_by
    [:phone, :email]
  end

  def permitted_params
    [
        :_id,
        :id,
        :name,
        :phone,
        :email
    ]
  end
end

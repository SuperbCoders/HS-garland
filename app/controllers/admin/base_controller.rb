class Admin::BaseController < ApplicationController

  def serialize_resources(resources, serializer)
    return [{}] if not resources
    current_user = {}
    ActiveModel::SerializableResource.new(
        resources,
        each_serializer: serializer,
        scope: current_user,
        root: false
    ).serializable_hash
  end

  def serialize_resource(resource, serializer)
    return {} if not resource
    current_user = {}
    ActiveModel::SerializableResource.new(
        resource,
        serializer: serializer,
        scope: current_user,
        root: false
    ).serializable_hash
  end
end

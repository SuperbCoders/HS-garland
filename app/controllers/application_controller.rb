class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def serialize_resources(resources, serializer)
    return [{}] if not resources
    ActiveModel::SerializableResource.new(
        resources,
        each_serializer: serializer,
        root: false
    ).serializable_hash
  end

  def serialize_resource(resource, serializer)
    return {} if not resource
    ActiveModel::SerializableResource.new(
        resource,
        serializer: serializer,
        root: false
    ).serializable_hash
  end

  def templates
    if Rails.env == 'development'
      render '/templates/' + params[:url], layout: false
    else
      begin
        render '/templates/' + params[:url], layout: false
      rescue Exception => e
        render nothing: true, layout: false
      end
    end
  end


end

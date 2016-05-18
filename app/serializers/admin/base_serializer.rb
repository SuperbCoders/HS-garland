module Admin
  class BaseSerializer < ActiveModel::Serializer
    attributes :id, :errors, :valid, :messages

    def messages
      object.try(:messages)
    end

    def valid
      object.valid?
    end

    def errors
      object.try(:errors).try(:full_messages)
    end

    def id
      object.id.to_s
    end


  end

end

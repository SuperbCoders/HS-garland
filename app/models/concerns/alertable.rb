module Alertable
  extend ActiveSupport::Concern
  include Mongoid::Document

  included do
    attr_accessor :messages

    after_save {
      if self.valid?
        self.messages ||= []
        message = "#{self.class.name} - #{I18n.t('admin.concerns.alertable.succefull_updated')}"
        self.messages << message
      end

    }
  end


end

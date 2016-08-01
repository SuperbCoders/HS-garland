class Setting
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  include Attachable

  field :open_setting, type: Boolean, default: true
  field :open_delivery_moscow, type: Integer, default: 500
  field :open_delivery_free_limit, type: Integer, default: 6000
  field :open_guaranty_amount, type: Integer, default: 12000

  field :email_address
  field :email_port
  field :email_domain
  field :email_user_name
  field :email_password
  field :email_authentication
  field :email_enable_starttls_auto, type: Boolean
  field :email_tls, type: Boolean
  field :contract

  validates_uniqueness_of :open_setting

  after_save :set_email_settings

  def delivery_moscow
    open_delivery_moscow
  end

  def delivery_free_limit
    open_delivery_free_limit
  end

  def guaranty_amount
    open_guaranty_amount
  end


  def email
    settings = {}
    attribute_names.each do |attr|
      settings[attr] = Setting.general[attr] if attr.include? 'email_'
    end
    settings
  end

  def open
    settings = {}
    attribute_names.each do |attr|
      settings[attr] = Setting.general[attr] if attr.include? 'open_'
    end
    settings
  end

  def self.general
    create if all.count <= 0
    all.first
  end

  def set_email_settings
    ActionMailer::Base.smtp_settings = {
        user_name: Setting.general.email_user_name,
        password: Setting.general.email_password
    }
  end
end

class Setting
  include Mongoid::Document
  include Mongoid::Timestamps::Short

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

  validates_uniqueness_of :open_setting


  def email
    settings = {}
    attribute_names.each do |attr|
      settings[attr] = attr if attr.include? 'email_'
    end
    settings
  end

  def open
    settings = {}
    attribute_names.each do |attr|
      settings[attr] = attr if attr.include? 'open_'
    end
    settings
  end

  def self.general
    create if all.count <= 0
    all.first
  end
end

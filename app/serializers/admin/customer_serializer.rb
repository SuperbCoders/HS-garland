class Admin::CustomerSerializer < Admin::BaseSerializer
  attributes :name, :email, :phone, :created_at
end

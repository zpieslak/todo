class Item < ActiveRecord::Base
  attr_accessible  :id, :active, :position, :title, :created_at, :updated_at
end

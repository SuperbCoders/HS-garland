class SliderImage
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  include Attachable

  field :file
end

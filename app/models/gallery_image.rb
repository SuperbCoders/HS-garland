class GalleryImage
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  include Attachable

  field :file
  field :tags, type: Hash

end

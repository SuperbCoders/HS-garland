class Admin::GalleryImageSerializer < Admin::BaseSerializer
  attributes :path, :tags, :all, :holidays, :iterior, :cinema, :wedding, :tags, :url, :date, :description

  def url
    "/uploads/#{object.file}"
  end

  def path
    "/uploads/#{object.file}"
  end

  def all
    true
  end

  def holidays
    object.tags[:holidays]
  end

  def iterior
    object.tags[:iterior]
  end

  def cinema
    object.tags[:cinema]
  end

  def wedding
    object.tags[:wedding]
  end

end

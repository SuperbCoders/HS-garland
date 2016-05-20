class Admin::SliderImageSerializer < Admin::BaseSerializer
  attributes :path

  def path
    "/uploads/#{object.file}"
  end

end

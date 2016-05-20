class LandingController < ApplicationController
  layout 'landing'

  def index
    @settings = {
        garland_prices: serialize_resources(GarlandPrice.all, Admin::GarlandPriceSerializer),
        lamp_prices: serialize_resources(LampPrice.all, Admin::LampPriceSerializer),
        general: Setting.general,
        share_banner: ShareBanner.banner.text.html_safe
    }
  end

  def gallery
    render json: serialize_resources(GalleryImage.all, Admin::GalleryImageSerializer)
  end

end

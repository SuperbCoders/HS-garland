class LandingController < ApplicationController
  layout 'landing'

  def index
    @settings = {
        garland_prices: serialize_resources(GarlandPrice.all, Admin::GarlandPriceSerializer),
        lamp_prices: serialize_resources(LampPrice.all, Admin::LampPriceSerializer),
        general: Setting.general.open,
        share_banner: ShareBanner.banner.text.html_safe
    }
  end

  def gallery
    render json: serialize_resources(GalleryImage.order(created_at: :desc).all, Admin::GalleryImageSerializer)
  end

  def order
    result = {
        order: Order.new_order(params)
    }

    render json: result
  end


end

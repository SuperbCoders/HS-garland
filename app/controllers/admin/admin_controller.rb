class Admin::AdminController < ApplicationController
  layout 'admin'
  def index

  end

  def share_banner
    if request.post?
      ShareBanner.banner.update_attributes(text: banner_params[:text])
    end

    render json: ShareBanner.banner
  end

  def general
    if request.post?
      Setting.general.update_attributes(setting_params)
    end
    render json: Setting.general.to_json
  end

  private

  def banner_params
    params.permit(:text)
  end

  def setting_params
    params.permit(:delivery_moscow, :delivery_free_limit, :guaranty_amount)
  end
end

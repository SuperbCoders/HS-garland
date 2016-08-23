class Admin::AdminController < Admin::BaseController
  layout 'admin'
  def index

  end

  def share_banner
    if request.post?
      ShareBanner.banner.update_attributes(text: banner_params[:text])
    end

    render json: ShareBanner.banner
  end

  def cost_garland
    if request.post?
      CostGarland.banner.update_attributes(text: banner_params[:text])
    end

    render json: CostGarland.banner
  end

  def rent_garland
    if request.post?
      RentGarland.banner.update_attributes(text: banner_params[:text])
    end

    render json: RentGarland.banner
  end

  def general
    if request.post?
      Setting.general.update_attributes(setting_params)
      Setting.general.attach(:contract, params[:contract] ) unless params[:contract].nil?
    end
    render json: Setting.general.to_json
  end

  private

  def banner_params
    params.permit(:text)
  end

  def setting_params
    params.permit(Setting.attribute_names)
  end
end

Rails.application.routes.draw do
  get 'templates(/*url)' => 'application#templates'

  root 'landing#index'
  get 'gallery' => 'landing#gallery'
  post 'order' => 'landing#order'

  namespace :admin do
    get '/' => 'admin#index'

    # Settings
    match '/settings/general' => 'admin#general', via: [:get, :post]
    match '/settings/share_banner' => 'admin#share_banner', via: [:get, :post]

    # Gallery
    scope :gallery do
      post 'upload' => 'gallery#upload'
      get '/' => 'gallery#index'
      post 'destroy' => 'gallery#destroy'
    end

    scope :slider do
      post 'upload' => 'gallery#slider_upload'
      get '/' => 'gallery#slider_index'
      post 'destroy' => 'gallery#slider_destroy'
    end

    # Resources
    resources :garland_prices
    resources :lamp_prices
    resources :orders do
      collection do
        get :statuses
      end
    end
    resources :customers

  end

end

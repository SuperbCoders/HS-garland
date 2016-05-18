Rails.application.routes.draw do
  get 'templates(/*url)' => 'application#templates'

  root 'landing#index'

  namespace :admin do
    get '/' => 'admin#index'

    resources :garland_prices
    resources :lamp_prices
    resources :orders
    resources :customers

  end

end

Rails.application.routes.draw do
  get 'templates(/*url)' => 'application#templates'

  root 'landing#index'

  get 'admin' => 'admin#index'
end

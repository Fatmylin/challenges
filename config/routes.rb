Rails.application.routes.draw do
  resources :companies do
    resources :shipments
  end
end

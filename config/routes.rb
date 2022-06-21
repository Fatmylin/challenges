Rails.application.routes.draw do
  resources :companies do
    resources :shipments do
      collection do
        post :search
      end
    end
  end
end

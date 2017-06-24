Rails.application.routes.draw do
  # Facebook Messenger route (NEEDS TO BE AT THE TOP, OTHERWISE ERROR 502 POPS UP)
  mount Facebook::Messenger::Server, at: 'webhooks/messenger'

  root to: 'stays#index'
  get 'stays/:stay_id/hotels/:hotel_id/services/search', to: 'services#search'

  resources :stays, only: [:index, :new] do
    resources :hotels, only: [:show] do
      get "/calendar_agenda", to: "hotels#calendar_agenda"
      get "/calendar_month", to: "hotels#calendar_month"
      get "/calendar_week", to: "hotels#calendar_week"

      resources :services, only: [:index, :show, :new, :create, :destroy] do
        resources :bookings
      end
      resources :locations, only: [:index, :show]
    end
  end

  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }


  # attachinary route
  mount Attachinary::Engine => "/attachinary"
end

Rails.application.routes.draw do

  # Facebook Messenger route (NEEDS TO BE AT THE TOP, OTHERWISE ERROR 502 POPS UP)
  mount Facebook::Messenger::Server, at: 'webhooks/messenger'
  # End of Facebook Messenger route

  # attachinary route
  mount Attachinary::Engine => "/attachinary"


  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end

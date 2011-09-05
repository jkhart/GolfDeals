GolfNow::Application.routes.draw do
  resources :deals
  root :to => "deals#index"
end

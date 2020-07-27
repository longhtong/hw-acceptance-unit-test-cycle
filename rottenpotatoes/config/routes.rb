Rottenpotatoes::Application.routes.draw do
  resources :movies do
    get 'directors', to: 'movies#samedirector', :as => "similarD", on: :collection
 end
      
  #get 'movies/', :to => 'movies#index'

  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
end

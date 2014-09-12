RemoteFactoryGirlHomeRails::Engine.routes.draw do
  resources :factory, only: [:create, :index] do
    post 'attributes_for', on: :collection
  end
end

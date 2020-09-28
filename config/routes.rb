Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users, param: :_username

      namespace :auth do
        post '/login', to: 'authentication#login'
      end
    end
  end

  get '/*a', to: 'application#not_found'

end

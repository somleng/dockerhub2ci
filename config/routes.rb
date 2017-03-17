Rails.application.routes.draw do
  namespace :api, :defaults => { :format => 'json' } do
    resources :webhooks, :only => [:create, :show]
  end
end

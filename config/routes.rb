Rails.application.routes.draw do
  root :to => redirect('https://github.com/dwilkie/dockerhub2ci')

  namespace :api, :defaults => { :format => 'json' } do
    resources :webhooks, :only => [:create, :show]
  end
end

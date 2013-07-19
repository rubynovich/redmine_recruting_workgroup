# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
resources :competences
resources :projects do
  resources :workload_competences, escept: 'new' do
    collection do
      post :new
    end
  end
end

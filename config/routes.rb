Rails.application.routes.draw do
  defaults format: :json do
    post 'parking' , to: 'parkings#park'
    put 'parking/:plate/pay' , to: 'parkings#pay'
    put 'parking/:plate/out' , to: 'parkings#out'
    get 'parking/:plate' , to: 'parkings#show', format: "json"
  end
end

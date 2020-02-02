Rails.application.routes.draw do
  get '/ruby_sleep_2_seconds', to: 'application#ruby_sleep_2_seconds'
  get '/c_sleep_2_seconds', to: 'application#c_sleep_2_seconds'
end

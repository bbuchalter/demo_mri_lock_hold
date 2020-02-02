Rails.application.routes.draw do
  get '/ruby_sleep_2_seconds', to: 'application#ruby_sleep_2_seconds'
  get '/c_sleep_2_seconds_with_gil', to: 'application#c_sleep_2_seconds_with_gil'
  get '/c_sleep_2_seconds_without_gil', to: 'application#c_sleep_2_seconds_without_gil'
end

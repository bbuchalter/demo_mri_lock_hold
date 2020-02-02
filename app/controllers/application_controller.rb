class ApplicationController < ActionController::Base
  def ruby_sleep_2_seconds
    sleep 2
    head :ok
  end
end

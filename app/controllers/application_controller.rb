class ApplicationController < ActionController::Base
  def ruby_sleep_2_seconds
    sleep 2
    head :ok
  end

  def c_sleep_2_seconds
    MriGilLock::Hold.for_microseconds(2_000_000)
    head :ok
  end
end

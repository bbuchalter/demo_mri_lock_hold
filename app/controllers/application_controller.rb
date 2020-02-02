class ApplicationController < ActionController::Base
  def ruby_sleep_2_seconds
    sleep 2
    head :ok
  end

  def c_sleep_2_seconds_with_gil
    MriGilLock::Hold.for_microseconds(2_000_000)
    head :ok
  end

  def c_sleep_2_seconds_without_gil
    MriGilLock::Hold.for_two_seconds_without_gil
    head :ok
  end
end

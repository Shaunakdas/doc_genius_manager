class ApplicationController < ActionController::API
  include ActionController::Serialization
  def send_otp(mobile_number)
    puts 'Sending OTP to mobile Number'
  end


end

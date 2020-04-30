class ApplicationController < ActionController::API
  include ActionController::Serialization
  serialization_scope :view_context
  def send_otp(mobile_number)
    puts 'Sending OTP to mobile Number'
  end


end

User.where.not(mobile_number: nil).each do |u|
    u.update_attributes!(mobile_number: nil)
end
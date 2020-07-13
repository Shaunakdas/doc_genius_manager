# User.where.not(mobile_number: nil).each do |u|
#     u.update_attributes!(mobile_number: nil)
# end

# User.where(username: nil).each do |u|
#     u.update_attributes!(username: "#{u.first_name}-#{u.id}")
# end
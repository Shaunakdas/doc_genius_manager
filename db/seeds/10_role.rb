['student', 'teacher', 'admin'].each do |role|
  Role.create_with(
    name: role.capitalize
  ).find_or_create_by(
    slug: role
  )
end
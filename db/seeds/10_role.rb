['student', 'teacher', 'admin'].each do |role|
  Role.create_with(
    name: role.capitalize
  ).find_or_create_by(
    slug: role
  )
end

['hard', 'medium', 'easy'].each_with_index do |diff, i|
  DifficultyLevel.create_with(
    name: diff.capitalize,
    sequence: i
  ).find_or_create_by(
    slug: diff
  )
end
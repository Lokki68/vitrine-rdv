Admin.find_or_create_by!(email: ENV.fetch("ADMIN_EMAIL", "admin@example.com")) do |adm|
  adm.password = ENV.fetch("ADMIN_PASSWORD", "Abcd1234")
end
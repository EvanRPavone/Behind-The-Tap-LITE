# db/seeds.rb

if Rails.env.development?
  load Rails.root.join('db', 'seeds', 'dev.rb')
elsif Rails.env.production?
  load Rails.root.join('db', 'seeds', 'prod.rb')
else
  puts "Seeds not loaded for environment: #{Rails.env}"
end

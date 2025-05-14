puts "Seeding the database..."

# Create a company
puts "Creating company..."
company = Company.create!(
  name: 'Development Brewery',
  slug: 'development-brewery'
)

# Create admin user
puts "Creating admin user..."
admin_user = User.create!(
  first_name: 'Admin',
  last_name: 'User',
  email: 'admin@example.com',
  role: 'admin',
  company: company,
  password: 'password'
)

# Create regular users
puts "Creating regular users..."
5.times do |i|
  User.create!(
    first_name: "User#{i + 1}",
    last_name: "Test#{i + 1}",
    email: "user#{i + 1}@example.com",
    role: 'brewer',
    company: company,
    password: 'password'
  )
end

# Create vessels
puts "Creating vessels..."
vessels = [
  { name: 'Fermenter 1', size_bbl: 10.0, company: company, in_use: false },
  { name: 'Fermenter 2', size_bbl: 15.0, company: company, in_use: false },
  { name: 'Bright Tank', size_bbl: 20.0, company: company, in_use: false }
]

vessels.each { |vessel| Vessel.create!(vessel) }

# Fetch created vessels
fermenter_1 = Vessel.find_by(name: 'Fermenter 1')
fermenter_2 = Vessel.find_by(name: 'Fermenter 2')

# Create ingredients
puts "Creating ingredients..."
ingredients = [
  { name: 'Citra', category: 'Hops', amount: 11, type_of_unit: 'Bag', weight_per_unit: 44.0, total_weight: 484.0, brand: nil, company: company },
  { name: 'Cascade', category: 'Hops', amount: 8, type_of_unit: 'Bag', weight_per_unit: 44.0, total_weight: 352.0, brand: nil, company: company },
  { name: 'Crystal 60L', category: 'Malts (Grains)', amount: 5, type_of_unit: 'Bag', weight_per_unit: 50.0, total_weight: 250.0, brand: 'Crisp', company: company }
]

ingredients.each { |ingredient| Ingredient.create!(ingredient) }

# Fetch ingredients
citra = Ingredient.find_by(name: 'Citra')
cascade = Ingredient.find_by(name: 'Cascade')
crystal_malt = Ingredient.find_by(name: 'Crystal 60L')

# Create recipes **before brews**
puts "Creating recipes..."
ipa = Recipe.create!(name: 'IPA', size_bbl: 10.0, target_abv: 6.5, company: company)
pale_ale = Recipe.create!(name: 'Pale Ale', size_bbl: 15.0, target_abv: 5.2, company: company)

# Ensure recipes are saved before assigning ingredients
ipa.reload
pale_ale.reload

# Assign ingredients to recipes
puts "Assigning ingredients to recipes..."
RecipeIngredient.create!(recipe: ipa, ingredient: citra, amount: 5, unit_of_measurement: 'oz')
RecipeIngredient.create!(recipe: ipa, ingredient: cascade, amount: 4, unit_of_measurement: 'oz')
RecipeIngredient.create!(recipe: pale_ale, ingredient: crystal_malt, amount: 10, unit_of_measurement: 'lbs')

# Create brews **after recipes and vessels exist**
puts "Creating brews..."
brews = [
  { batch_no: 'BATCH001', recipe: ipa, status: 0, brew_date: Date.today - 7, target_p: 12.5, vessel_id: fermenter_1.id, target_release: Date.today + 14, company: company },
  { batch_no: 'BATCH002', recipe: pale_ale, status: 1, brew_date: Date.today - 10, target_p: 10.8, vessel_id: fermenter_2.id, target_release: Date.today + 10, company: company }
]

brews.each { |brew| Brew.create!(brew) }

# Remove keg creation
puts "Skipping keg creation as requested."

# Create partnerships
puts "Creating partnerships..."
partner_company = Company.create!(name: 'Partner Brewery', slug: 'partner-brewery')
Partnership.create!(company: company, partner_id: partner_company.id)

puts "Database seeded successfully!"

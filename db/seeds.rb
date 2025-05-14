puts "🌱 Seeding LITE demo data..."

# Reset tables in safe order
puts "🧹 Clearing existing data..."
RecipeIngredient.delete_all
Ingredient.delete_all
Recipe.delete_all
Brew.delete_all
Vessel.delete_all
Company.delete_all

# Create demo company
puts "🏭 Creating demo company..."
company = Company.create!(name: "LITE Brewing Co.")

# Ingredients (accurate to your schema)
puts "🍺 Seeding ingredients..."
ingredients = [
  { name: 'Citra', category: 'Hops', amount: 20, lb_per_bag: 44, brand: 'Yakima Chief', on_order: false },
  { name: 'Cascade', category: 'Hops', amount: 12, lb_per_bag: 44, brand: 'Crosby', on_order: true },
  { name: 'Marris Otter', category: 'Malts (Grains)', amount: 50, lb_per_bag: 55, brand: 'Crisp', on_order: false },
  { name: 'BRY-97', category: 'Yeast', amount: 10, lb_per_bag: 0.5, brand: 'Lallemand', on_order: false }
]

ingredient_records = ingredients.map do |data|
  Ingredient.create!(
    name: data[:name],
    category: data[:category],
    amount: data[:amount],
    lb_per_bag: data[:lb_per_bag],
    brand: data[:brand],
    on_order: data[:on_order],
    company: company
  )
end

# Recipes
puts "📋 Creating recipes..."
ipa = Recipe.create!(name: "Session IPA", company: company, size_bbl: 7.0, target_abv: 4.8)
lager = Recipe.create!(name: "House Lager", company: company, size_bbl: 10.0, target_abv: 5.2)

# Link ingredients to recipes
puts "🧪 Associating ingredients with recipes..."
RecipeIngredient.create!(recipe: ipa, ingredient: ingredient_records[0], amount: 22, unit_of_measurement: "lbs")
RecipeIngredient.create!(recipe: ipa, ingredient: ingredient_records[2], amount: 45, unit_of_measurement: "lbs")
RecipeIngredient.create!(recipe: ipa, ingredient: ingredient_records[3], amount: 1.5, unit_of_measurement: "lbs")

RecipeIngredient.create!(recipe: lager, ingredient: ingredient_records[1], amount: 18, unit_of_measurement: "lbs")
RecipeIngredient.create!(recipe: lager, ingredient: ingredient_records[2], amount: 55, unit_of_measurement: "lbs")
RecipeIngredient.create!(recipe: lager, ingredient: ingredient_records[3], amount: 2.0, unit_of_measurement: "lbs")

# Vessels
puts "🛢️ Adding vessels..."
["FV1", "FV2", "Bright Tank"].each do |name|
  Vessel.create!(name: name, size_bbl: 15, company: company)
end

# Optional: one brew in progress
puts "🍻 Starting one brew..."
Brew.create!(
  batch_no: "BT-001",
  status: 0,
  vessel: Vessel.last,
  brew_date: Date.today,
  target_release: Date.today + 21,
  company: company,
  recipe: Recipe.first,
  in_tank: Recipe.first.id,
  target_p: 12.5
)

puts "✅ Seeding complete!"

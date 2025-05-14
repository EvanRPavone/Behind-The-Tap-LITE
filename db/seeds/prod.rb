# Seeds for production environment
puts "Running Prod seed file with inventory reset"

# Step 1: Delete existing inventory and related data in the correct order
puts "Deleting current inventory, recipes, and related data..."
RecipeIngredient.delete_all
Ingredient.delete_all
Recipe.delete_all
Keg.delete_all
Brew.delete_all

# Step 2: Recreate ingredients using `Ingredient::CATEGORIES` and `Ingredient::UNIT_TYPES`
puts "Seeding hops inventory..."
hops_inventory = [
  { name: 'Citra', amount: 11, type_of_unit: 'Bag', weight_per_unit: 44.0, category: 'Hops' },
  { name: 'HBC 638', amount: 8, type_of_unit: 'Bag', weight_per_unit: 44.0, category: 'Hops' },
  { name: 'Cascade', amount: 0, type_of_unit: 'Bag', weight_per_unit: 44.0, category: 'Hops' },
  { name: 'EKG', amount: 17, type_of_unit: 'Bag', weight_per_unit: 44.0, category: 'Hops' },
  { name: 'Idaho-7', amount: 19, type_of_unit: 'Bag', weight_per_unit: 44.0, category: 'Hops' }
]

hops_inventory.each do |hop|
  Ingredient.create!(
    name: hop[:name],
    category: Ingredient::CATEGORIES.include?(hop[:category]) ? hop[:category] : 'Other',
    amount: hop[:amount],
    type_of_unit: Ingredient::UNIT_TYPES.include?(hop[:type_of_unit]) ? hop[:type_of_unit] : 'Other',
    weight_per_unit: hop[:weight_per_unit],
    total_weight: hop[:amount] * hop[:weight_per_unit],
    company: Company.first
  )
end

puts "Seeding malts inventory..."
malts_inventory = [
  { name: 'Crystal 60L', category: 'Malts (Grains)', brand: 'Crisp', amount: 5, type_of_unit: 'Bag', weight_per_unit: 50.0 },
  { name: 'Crystal 77L', category: 'Malts (Grains)', brand: 'Crisp', amount: 3, type_of_unit: 'Bag', weight_per_unit: 50.0 },
  { name: 'Marris Otter', category: 'Malts (Grains)', brand: 'Crisp', amount: 7, type_of_unit: 'Bag', weight_per_unit: 55.0 }
]

malts_inventory.each do |malt|
  Ingredient.create!(
    name: malt[:name],
    category: Ingredient::CATEGORIES.include?(malt[:category]) ? malt[:category] : 'Other',
    brand: malt[:brand],
    amount: malt[:amount],
    type_of_unit: Ingredient::UNIT_TYPES.include?(malt[:type_of_unit]) ? malt[:type_of_unit] : 'Other',
    weight_per_unit: malt[:weight_per_unit],
    total_weight: malt[:amount] * malt[:weight_per_unit],
    company: Company.first
  )
end

puts "Seeding yeast inventory..."
yeast_inventory = [
  { name: 'BRY-97', category: 'Yeast', brand: 'Lallemand', amount: 10, type_of_unit: 'Packet', weight_per_unit: 0.5 },
  { name: 'NovaLager', category: 'Yeast', brand: 'Lallemand', amount: 20, type_of_unit: 'Packet', weight_per_unit: 0.5 },
  { name: 'Munich Lager', category: 'Yeast', brand: 'Apex', amount: 2, type_of_unit: 'Packet', weight_per_unit: 1.0 }
]

yeast_inventory.each do |yeast|
  Ingredient.create!(
    name: yeast[:name],
    category: Ingredient::CATEGORIES.include?(yeast[:category]) ? yeast[:category] : 'Other',
    brand: yeast[:brand],
    amount: yeast[:amount],
    type_of_unit: Ingredient::UNIT_TYPES.include?(yeast[:type_of_unit]) ? yeast[:type_of_unit] : 'Other',
    weight_per_unit: yeast[:weight_per_unit],
    total_weight: yeast[:amount] * yeast[:weight_per_unit],
    company: Company.first
  )
end

puts "Seeding puree inventory..."
puree_inventory = [
  { name: 'Mango Puree', category: 'Puree', brand: nil, amount: 4, type_of_unit: 'Container', weight_per_unit: 44.0 },
  { name: 'Strawberry Puree', category: 'Puree', brand: nil, amount: 6, type_of_unit: 'Container', weight_per_unit: 44.0 },
  { name: 'Pineapple Puree', category: 'Puree', brand: nil, amount: 5, type_of_unit: 'Container', weight_per_unit: 44.0 }
]

puree_inventory.each do |puree|
  Ingredient.create!(
    name: puree[:name],
    category: Ingredient::CATEGORIES.include?(puree[:category]) ? puree[:category] : 'Other',
    brand: puree[:brand],
    amount: puree[:amount],
    type_of_unit: Ingredient::UNIT_TYPES.include?(puree[:type_of_unit]) ? puree[:type_of_unit] : 'Other',
    weight_per_unit: puree[:weight_per_unit],
    total_weight: puree[:amount] * puree[:weight_per_unit],
    company: Company.first
  )
end

puts "Seeding complete for production!"

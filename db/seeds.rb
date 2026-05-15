# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Categorías base (comunes para todos los usuarios)
base_categories = ["Comida", "Vivienda", "Transporte", "Ocio", "Salud", "Educación"]

base_categories.each do |cat_name|
  Category.find_or_create_by(name: cat_name, user_id: nil) do |category|
    category.deleted_at = nil
  end
end

puts "Categorías base creadas: #{base_categories.join(', ')}"
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding database..."

# Clear existing data
puts "Clearing existing data..."
OrderItem.destroy_all
Order.destroy_all
CartItem.destroy_all
Cart.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all
puts "Existing data cleared."

# Create Categories
puts "Creating categories..."
electronics = Category.find_or_create_by!(name: "Electronics")
clothing = Category.find_or_create_by!(name: "Clothing")
books = Category.find_or_create_by!(name: "Books")
puts "Categories created."

# Create Products
puts "Creating products..."
Product.find_or_create_by!(name: "Laptop Pro", description: "High-end laptop for professionals", price: 1499.99, stock_quantity: 50, category: electronics)
Product.find_or_create_by!(name: "Smartphone X", description: "Latest generation smartphone", price: 999.99, stock_quantity: 100, category: electronics)
Product.find_or_create_by!(name: "Wireless Headphones", description: "Noise-cancelling over-ear headphones", price: 199.99, stock_quantity: 200, category: electronics)

Product.find_or_create_by!(name: "Men's T-Shirt", description: "Comfortable cotton t-shirt", price: 24.99, stock_quantity: 300, category: clothing)
Product.find_or_create_by!(name: "Women's Jeans", description: "Stylish blue denim jeans", price: 49.99, stock_quantity: 150, category: clothing)
Product.find_or_create_by!(name: "Running Shoes", description: "Lightweight running shoes", price: 79.99, stock_quantity: 120, category: clothing)

Product.find_or_create_by!(name: "The Great Novel", description: "A captivating story", price: 14.99, stock_quantity: 500, category: books)
Product.find_or_create_by!(name: "Learn Ruby Programming", description: "Comprehensive guide to Ruby", price: 39.99, stock_quantity: 80, category: books)
Product.find_or_create_by!(name: "Cookbook Delights", description: "Delicious recipes for everyone", price: 29.99, stock_quantity: 250, category: books)
puts "Products created."

# Create a sample user and admin
puts "Creating users..."
User.find_or_create_by!(email: 'user@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.admin = false
end

User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.admin = true
end
puts "Users created."

# Create carts for users (optional, can be created on demand)
# user = User.find_by(email: 'user@example.com')
# Cart.find_or_create_by!(user: user)

puts "Seeding finished."

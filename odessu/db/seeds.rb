# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Product.delete_all
Product.create! id: 1, name: "Banana", price: 0.49
Product.create! id: 2, name: "Apple", price: 0.29
Product.create! id: 3, name: "Carton of Strawberries", price: 1.99

OrderStatus.delete_all
OrderStatus.create! id: 1, status: "In Progress"
OrderStatus.create! id: 2, status: "Placed"
OrderStatus.create! id: 3, status: "Shipped"
OrderStatus.create! id: 4, status: "Cancelled"

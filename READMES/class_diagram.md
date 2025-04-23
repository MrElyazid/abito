# Abito E-commerce - Class Diagram

This diagram shows the relationships between the main models in the Abito application.

```mermaid
classDiagram
    direction LR

    class User {
        +string email
        +string encrypted_password
        +boolean admin
        +has_one : Cart
        +has_many : Order
    }

    class Category {
        +string name
        +has_many : Product
    }

    class Product {
        +string name
        +text description
        +decimal price
        +integer stock_quantity
        +belongs_to : Category
        +has_one_attached : image
        +has_many : CartItem
        +has_many : OrderItem
    }

    class Cart {
        +belongs_to : User
        +has_many : CartItem
        +has_many : Product (through CartItem)
    }

    class CartItem {
        +integer quantity
        +belongs_to : Cart
        +belongs_to : Product
    }

    class Order {
        +decimal total_price
        +string status
        +belongs_to : User
        +has_many : OrderItem
        +has_many : Product (through OrderItem)
    }

    class OrderItem {
        +integer quantity
        +decimal price
        +belongs_to : Order
        +belongs_to : Product
    }

    User "1" --o "1" Cart : has one
    User "1" --* "*" Order : has many
    Category "1" --* "*" Product : has many
    Product "1" --* "*" CartItem : has many
    Product "1" --* "*" OrderItem : has many
    Cart "1" --* "*" CartItem : has many
    Order "1" --* "*" OrderItem : has many

    %% Notes on relationships:
    %% - A User has one Cart (implicitly created).
    %% - A User can have many Orders.
    %% - A Category can have many Products.
    %% - A Product belongs to one Category.
    %% - A Product can be in many CartItems and OrderItems.
    %% - A Cart belongs to one User and has many CartItems.
    %% - An Order belongs to one User and has many OrderItems.
    %% - CartItem links a Cart and a Product, storing quantity.
    %% - OrderItem links an Order and a Product, storing quantity and price at time of order.
    %% - Product uses ActiveStorage for its image (has_one_attached :image).

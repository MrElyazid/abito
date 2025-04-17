# Abito - Simple Rails E-commerce Site

This is a simple e-commerce website built with Ruby on Rails 8 for educational purposes. It demonstrates basic features like user authentication, product browsing, category filtering, and a shopping cart.

## Features Implemented

*   **Project Setup:**
    *   Initialized using `rails new . --css bootstrap --database=sqlite3`.
    *   Uses Rails 8.
    *   Uses Bootstrap for styling.
    *   Uses SQLite3 as the database.
    *   Uses import maps for JavaScript.
    *   Includes basic development tools like `debug`, `brakeman`, `rubocop-rails-omakase`.
    *   Includes testing setup with `capybara` and `selenium-webdriver`.
*   **User Authentication:**
    *   Implemented using the `devise` gem.
    *   Users can sign up (`/users/sign_up`), log in (`/users/sign_in`), and log out.
    *   A boolean `admin` flag exists on the `User` model (default `false`), distinguishing regular users from administrators (admin functionality not yet implemented).
*   **Core Models & Database:**
    *   **User:** Manages user accounts (via Devise), has `admin` flag, `has_one :cart`, `has_many :orders`.
    *   **Category:** Has a `name` (string), `has_many :products`.
    *   **Product:** Has `name` (string), `description` (text), `price` (decimal), `stock_quantity` (integer), `belongs_to :category`, `has_many :cart_items`, `has_many :order_items`.
    *   **Cart:** `belongs_to :user`, `has_many :cart_items`, `has_many :products, through: :cart_items`. A cart is automatically created for a user upon their first action requiring it (like adding an item) if they are logged in.
    *   **CartItem:** `belongs_to :cart`, `belongs_to :product`, has `quantity` (integer). Represents a product within a specific cart.
    *   **Order:** `belongs_to :user`, has `total_price` (decimal), `status` (string), `has_many :order_items`, `has_many :products, through: :order_items`. (Order creation/checkout not yet implemented).
    *   **OrderItem:** `belongs_to :order`, `belongs_to :product`, has `quantity` (integer), `price` (decimal). Represents a product within a specific order, storing the price at the time of purchase.
    *   Database seeded with sample categories (Electronics, Clothing, Books), products within those categories, and two users:
        *   `user@example.com` (password: `password`)
        *   `admin@example.com` (password: `password`, `admin: true`)
*   **Product Browsing:**
    *   **All Products:** View a grid of all products at `/products`.
    *   **Product Details:** View details for a single product at `/products/:id`.
    *   **Products by Category:** View products belonging to a specific category at `/categories/:id`.
    *   Placeholder images from `https://picsum.photos/` are used.
*   **Shopping Cart:**
    *   Logged-in users have a shopping cart.
    *   "Add to Cart" buttons are available on product index and show pages for logged-in users.
    *   Adding an item redirects to the cart page (`/cart`) and shows a notice.
    *   The cart page displays items, quantities, subtotals, and the total price.
    *   A navigation link to the cart (showing item count) appears for logged-in users.
*   **Styling & Layout:**
    *   Uses Bootstrap 5 for basic styling and layout (cards, grid, navbar).
    *   A standard application layout (`application.html.erb`) includes a navigation bar and flash message display.

## How to Run

1.  **Prerequisites:**
    *   Ruby (check `.ruby-version` for required version)
    *   Bundler (`gem install bundler`)
    *   Node.js and Yarn (for asset bundling)
    *   SQLite3
2.  **Clone the repository (if applicable).**
3.  **Install dependencies:**
    ```bash
    bundle install
    yarn install
    ```
4.  **Set up the database:**
    ```bash
    rails db:setup # Creates database, loads schema, and seeds data
    # OR if the database exists:
    # rails db:migrate
    # rails db:seed
    ```
5.  **Start the development server:**
    ```bash
    bundle exec foreman start -f Procfile.dev
    # OR if foreman is in your PATH directly:
    # bin/dev
    ```
6.  **Access the application:** Open your web browser and navigate to `http://localhost:3000`.

## Next Steps / Not Implemented

*   Admin panel for managing products, categories, users, and orders.
*   Cart item removal/quantity update.
*   Checkout process (creating orders from carts).
*   Order history view for users.
*   Actual product image uploads (using Active Storage).
*   More robust styling.
*   Testing.

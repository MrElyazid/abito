# Abito - Simple Rails E-commerce Site

This is a simple e-commerce website built with Ruby on Rails 8 for educational purposes. It demonstrates various features like user authentication, product browsing, category filtering, shopping cart, user comments, and product submissions by users.

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
    *   A boolean `admin` flag exists on the `User` model (default `false`)
*   **Core Models & Database:**
    *   **User:** Manages user accounts (via Devise), has `admin` flag, `has_one :cart`, `has_many :orders`, `has_many :comments`, `has_many :product_submissions (products where submitted_by = user)`.
    *   **Category:** Has a `name` (string), `has_many :products`.
    *   **Product:** Has `name` (string), `description` (text), `price` (decimal), `stock_quantity` (integer), `belongs_to :category`, `has_many :cart_items`, `has_many :order_items`, `has_many :comments`, `has_one_attached :image`, `belongs_to :submitted_by (User), optional`.
    *   **Cart:** `belongs_to :user`, `has_many :cart_items`, `has_many :products, through: :cart_items`. A cart is automatically created for a user upon their first action requiring it (like adding an item) if they are logged in.
    *   **CartItem:** `belongs_to :cart`, `belongs_to :product`, has `quantity` (integer). Represents a product within a specific cart.
    *   **Order:** `belongs_to :user`, has `total_price` (decimal), `status` (string), `has_many :order_items`, `has_many :products, through: :order_items`.
    *   **OrderItem:** `belongs_to :order`, `belongs_to :product`, has `quantity` (integer), `price` (decimal). Represents a product within a specific order, storing the price at the time of purchase.
    *   **Comment:** `belongs_to :user`, `belongs_to :product`, has `body` (text). Represents a user comment on a product.
    *   Database seeded with sample categories (Electronics, Clothing, Books), products within those categories, and two users:
        *   `user@example.com` (password: `password`)
        *   `admin@example.com` (password: `password`, `admin: true`)
*   **Product Browsing:**
    *   **All Products:** View a grid of all products at `/products`. Includes a basic search bar to filter products by name (case-insensitive partial match).
    *   **Product Details:** View details for a single product at `/products/:id`. Includes a section to view existing comments and add new comments (for logged-in users).
    *   **Products by Category:** View products belonging to a specific category at `/categories/:id`.
*   **Shopping Cart:**
    *   Logged-in users have a shopping cart.
    *   "Add to Cart" buttons are available on product index and show pages for logged-in users.
    *   Adding an item redirects to the cart page (`/cart`) and shows a notice.
    *   The cart page (`/cart`) displays items, quantities, subtotals, and the total price.
    *   Users can decrease the quantity of an item (removes item if quantity becomes 0) or remove an item completely directly from the cart page.
*   **Product Submissions:**
    *   Logged-in users can submit new products.
    *   Submitted products are marked as `pending` and are not visible to regular users until approved by an admin.
    *   Admin users can view, approve, or reject product submissions in the admin section.
*   **Styling & Layout:**
    *   Uses Bootstrap 5 for styling and layout.
    *   Includes custom styles for product cards.
    *   Product card display logic refactored into a partial (`app/views/products/_product_card.html.erb`).
    *   A standard application layout (`application.html.erb`) includes a navigation bar (with Cart and Order History links for logged-in users) and flash message display.
*   **Admin Section (`/admin`):**
    *   Requires login as an admin user (e.g., `admin@example.com`).
    *   Uses a separate layout (`admin.html.erb`) with a dark theme and dedicated navigation.
    *   **Dashboard:** Displays site statistics (Product, Category, User, Order counts) with links to management sections.
    *   **Product Management:** Full CRUD functionality for products (`/admin/products`), including image uploads via Active Storage.
    *   **Category Management:** Full CRUD functionality for categories (`/admin/categories`).
    *   **User Management:** View list of users and delete non-admin users (`/admin/users`).
    *   **Order Management:** View list of all orders and order details (`/admin/orders`).
    *   **Product Submissions Management:** View, approve, or reject product submissions (`/admin/products/pending_submissions`).
*   **Checkout Process:**
    *   Users can click "Checkout" in their cart (`/cart`).
    *   This triggers the creation of an `Order` record with associated `OrderItems` based on the cart contents.
    *   The price at the time of purchase is stored in `OrderItems`.
    *   A basic stock check is performed.
    *   The user's cart is cleared upon successful order creation.
*   **User Order History:**
    *   Logged-in users can view their past orders at `/orders`.
    *   Users can view the details of a specific order at `/orders/:id`.
*   **Home Page:**
    *   Client home page (`/`) with an enhanced welcome banner.
    *   Includes a "Shop by Category" section displaying links to category pages.
    *   Includes a "Featured Products" section (displaying the 3 most recently added products) using the styled product cards.
    *   Admin users visiting the root path (`/`) are automatically redirected to the admin dashboard (`/admin`).

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

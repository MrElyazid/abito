# Abito E-commerce - Rails Routing

The Rails router, defined primarily in `config/routes.rb`, is responsible for recognizing incoming request URLs and dispatching them to the appropriate controller action. It acts as the entry point for most web requests.

**Key Concepts:**

1.  **Mapping URLs to Controllers:** The router defines rules that map specific URL patterns and HTTP methods (GET, POST, PUT, PATCH, DELETE) to a controller and action pair.
2.  **RESTful Routes:** Rails encourages a RESTful approach to routing. The `resources` helper is a powerful way to automatically generate the standard set of routes for a resource (like products or categories). For example, `resources :products` creates routes for:
    *   `GET /products` -> `products#index` (List all products)
    *   `GET /products/new` -> `products#new` (Show form for new product)
    *   `POST /products` -> `products#create` (Create a new product)
    *   `GET /products/:id` -> `products#show` (Show details for one product)
    *   `GET /products/:id/edit` -> `products#edit` (Show form to edit a product)
    *   `PATCH /products/:id` or `PUT /products/:id` -> `products#update` (Update a product)
    *   `DELETE /products/:id` -> `products#destroy` (Delete a product)
3.  **Path Helpers:** For each route, Rails automatically generates "path helper" methods that you can use in your controllers and views to create URLs without hardcoding them. Examples:
    *   `products_path` -> `/products`
    *   `new_product_path` -> `/products/new`
    *   `product_path(@product)` -> `/products/1` (if `@product.id` is 1)
    *   `edit_product_path(@product)` -> `/products/1/edit`
4.  **Root Route:** The `root` directive specifies which controller action should handle requests to the base URL of the application (`/`).
5.  **Namespaces:** The `namespace` helper allows grouping related routes under a common path segment and module. This is often used for admin sections.
6.  **Nested Resources:** Routes can be nested to represent relationships. For example, adding cart items is often nested under products.

**Routing in this Project (`config/routes.rb`):**

Let's examine the key parts of this project's `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users

  # Root path depends on user role
  authenticated :user, ->(user) { user.admin? } do
    root to: 'admin/dashboard#index', as: :admin_root
  end
  root to: 'home#index'

  # Public facing resources
  resources :products, only: [:index, :show] do
    resources :cart_items, only: [:create] # Nested: POST /products/:product_id/cart_items
  end
  resources :categories, only: [:show]
  resource :cart, only: [:show] # Singular resource for the current user's cart

  # Admin section
  namespace :admin do
    root to: 'dashboard#index' # /admin
    resources :products # Full CRUD for products under /admin/products
    # Add routes for admin category/user/order management here later
  end

  # ... other routes like health checks ...
end
```

**Breakdown:**

*   `devise_for :users`: Sets up all the necessary routes for user sign-up, login, logout, password recovery, etc., provided by the Devise gem.
*   `authenticated :user, ->(user) { user.admin? } do ... end`: Defines a special root path (`/admin`) for users who are logged in *and* are admins.
*   `root to: 'home#index'`: Sets the default root path (`/`) for non-admin users (or logged-out users) to the `index` action of the `HomeController`.
*   `resources :products, only: [:index, :show]`: Creates the public routes for viewing all products (`/products`) and a single product (`/products/:id`).
*   `resources :cart_items, only: [:create]`: Nested within `products`, this creates the route `POST /products/:product_id/cart_items` mapped to `cart_items#create`. This makes sense because you add a specific product *to* the cart.
*   `resources :categories, only: [:show]`: Creates the route `GET /categories/:id` for viewing products by category.
*   `resource :cart, only: [:show]`: Uses `resource` (singular) because a user typically only has *one* cart. This creates `GET /cart` mapped to `carts#show`.
*   `namespace :admin do ... end`: Groups all admin-related routes under the `/admin` path and expects controllers to be in the `Admin` module (e.g., `Admin::ProductsController`).
    *   `root to: 'dashboard#index'`: Maps `/admin` to `Admin::DashboardController#index`.
    *   `resources :products`: Creates the full set of RESTful routes for managing products within the admin section (e.g., `GET /admin/products`, `POST /admin/products`, `GET /admin/products/:id/edit`, etc.).

**How to Check Routes:**

You can run `bin/rails routes` in your terminal to see a complete list of all routes defined for your application, including the HTTP method, URL pattern, controller#action mapping, and path helper names.

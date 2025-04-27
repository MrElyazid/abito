# Abito E-commerce - Shopping Cart Functionality

The shopping cart allows logged-in users to temporarily store products they intend to purchase.

**Core Components:**

1.  **`Cart` Model (`app/models/cart.rb`):**
    *   Represents a user's shopping cart.
    *   `belongs_to :user`: Each cart belongs to a specific user.
    *   `has_many :cart_items, dependent: :destroy`: A cart contains multiple line items. If a cart is deleted, its associated items are also deleted.
    *   `has_many :products, through: :cart_items`: Provides a convenient way to access the products directly within a cart via the `cart_items` join table.
    *   **Implicit Creation:** The application relies on finding or creating the cart when needed (e.g., `current_user.cart || current_user.create_cart` in `ApplicationController`). A user doesn't explicitly create a cart; it's generated the first time they add an item.

2.  **`CartItem` Model (`app/models/cart_item.rb`):**
    *   Represents a specific product within a specific cart, including the quantity. This is a "join model".
    *   `belongs_to :cart`: Links the item to a shopping cart.
    *   `belongs_to :product`: Links the item to a product.
    *   `quantity` (integer): Stores how many units of the specific product are in the cart.
    *   `dependent: :destroy` on the `Cart` model's `has_many :cart_items` ensures that if a `Cart` is destroyed, its associated `CartItem` records are also automatically deleted.

3.  **`CartItemsController` (`app/controllers/cart_items_controller.rb`):**
    *   Handles the logic for adding, updating, and removing items from the cart.
    *   Uses `before_action :authenticate_user!` for all actions.
    *   Uses `before_action :set_cart_item` (which finds the item within the `current_cart`) for `update` and `destroy`.
    *   **`create` Action:** Triggered by `POST /products/:product_id/cart_items`. Finds or initializes the `CartItem` for the given product in the user's cart and increments the quantity (or sets it to 1). Redirects to `cart_path`.
    *   **`update` Action:** Triggered by `PATCH /cart/cart_items/:id`. Decreases the quantity of the specified `CartItem` by 1. If the quantity becomes 0, the item is destroyed. Redirects to `cart_path`.
    *   **`destroy` Action:** Triggered by `DELETE /cart/cart_items/:id`. Destroys the specified `CartItem`. Redirects to `cart_path`.

4.  **`CartsController` (`app/controllers/carts_controller.rb`):**
    *   Handles displaying the cart.
    *   **`show` Action:**
        *   **Requires Login:** Uses `before_action :authenticate_user!`.
        *   **Finds Cart:** Gets the `current_user`'s cart (`@cart = current_cart`). Includes preloading associated items and products for efficiency (`@cart_items = @cart.cart_items.includes(:product)`).
        *   **Renders View:** Renders the `app/views/carts/show.html.erb` template, passing the `@cart` and `@cart_items` objects to it.

5.  **Cart View (`app/views/carts/show.html.erb`):**
    *   Receives the `@cart` and `@cart_items` objects from the `CartsController`.
    *   Iterates through `@cart_items` to display each product in the cart.
    *   For each `cart_item`, it can access the associated `product` details (e.g., `cart_item.product.name`, `cart_item.product.price`).
    *   Displays the `cart_item.quantity`.
    *   Calculates and displays sub-totals (price * quantity) for each item.
    *   Calculates and displays the overall cart total.
    *   Includes a "Checkout" button.
    *   Includes "Decrease Quantity" (`-`) and "Remove" buttons for each item, linked to the `update` and `destroy` actions in `CartItemsController`.

**Workflow Summary (Add to Cart):**

User clicks button -> POST to `CartItemsController#create` -> Controller finds/creates Cart -> Finds Product -> Finds/builds CartItem -> Increments quantity or sets to 1 -> Saves CartItem -> Redirects to `CartsController#show` -> Controller finds Cart and items -> Renders `carts/show.html.erb` -> User sees updated cart.

**Checkout Workflow:**

User clicks "Checkout" button -> POST to `OrdersController#create` -> Controller finds Cart -> Starts Transaction -> Builds Order & OrderItems (copying price, checking stock) -> Calculates total -> Saves Order -> Clears Cart -> Redirects User (e.g., to home page) with success message.

# Abito E-commerce - Shopping Cart Functionality

The shopping cart allows logged-in users to temporarily store products they intend to purchase.

**Core Components:**

1.  **`Cart` Model (`app/models/cart.rb`):**
    *   Represents a user's shopping cart.
    *   `belongs_to :user`: Each cart belongs to a specific user.
    *   `has_many :cart_items, dependent: :destroy`: A cart contains multiple line items. If a cart is deleted, its associated items are also deleted.
    *   `has_many :products, through: :cart_items`: Provides a convenient way to access the products directly within a cart via the `cart_items` join table.
    *   **Implicit Creation:** The application seems to rely on finding or creating the cart when needed (e.g., `current_user.cart || current_user.create_cart`). A user doesn't explicitly create a cart; it's often generated the first time they add an item.

2.  **`CartItem` Model (`app/models/cart_item.rb`):**
    *   Represents a specific product within a specific cart, including the quantity. This is a "join model".
    *   `belongs_to :cart`: Links the item to a shopping cart.
    *   `belongs_to :product`: Links the item to a product.
    *   `quantity` (integer): Stores how many units of the specific product are in the cart.
    *   `dependent: :destroy` on the `Cart` model's `has_many :cart_items` ensures that if a `Cart` is destroyed, its associated `CartItem` records are also automatically deleted.

3.  **`CartItemsController` (`app/controllers/cart_items_controller.rb`):**
    *   Handles the logic for adding items to the cart.
    *   **`create` Action:** This is the primary action used. It's triggered by a `POST` request, typically from an "Add to Cart" button.
        *   **Requires Login:** It likely uses `before_action :authenticate_user!` to ensure only logged-in users can add items.
        *   **Finds User's Cart:** Gets the `current_user` and finds/creates their associated `Cart` (`@cart = current_user.cart || current_user.create_cart`).
        *   **Finds Product:** Finds the `Product` based on `params[:product_id]` (passed via the nested route).
        *   **Checks for Existing Item:** Looks for an existing `CartItem` in the `@cart` for the specific `@product` (`@cart_item = @cart.cart_items.find_by(product_id: @product.id)`).
        *   **Updates or Creates:**
            *   If `@cart_item` exists, it increments the `quantity` (`@cart_item.increment!(:quantity)`).
            *   If `@cart_item` is `nil`, it creates a new `CartItem` associated with the `@cart` and `@product`, setting the initial `quantity` to 1 (`@cart_item = @cart.cart_items.build(product: @product)`).
        *   **Saves:** Saves the `@cart_item` (either the updated existing one or the new one).
        *   **Redirects:** Redirects the user to the cart page (`cart_path`) with a success notice.

4.  **`CartsController` (`app/controllers/carts_controller.rb`):**
    *   Handles displaying the cart.
    *   **`show` Action:**
        *   **Requires Login:** Uses `before_action :authenticate_user!`.
        *   **Finds Cart:** Gets the `current_user`'s cart (`@cart = current_user.cart`). It might also include preloading associated items for efficiency (`@cart = current_user.cart.includes(cart_items: :product)`).
        *   **Renders View:** Renders the `app/views/carts/show.html.erb` template, passing the `@cart` object to it.

5.  **Cart View (`app/views/carts/show.html.erb`):**
    *   Receives the `@cart` object from the `CartsController`.
    *   Iterates through `@cart.cart_items` to display each product in the cart.
    *   For each `cart_item`, it can access the associated `product` details (e.g., `cart_item.product.name`, `cart_item.product.price`).
    *   Displays the `cart_item.quantity`.
    *   Calculates and displays sub-totals (price * quantity) for each item.
    *   Calculates and displays the overall cart total.
    *   Includes a "Checkout" button.
    *   (Currently missing: Functionality to remove items or update quantities directly from the cart view).

**Workflow Summary (Add to Cart):**

User clicks button -> POST to `CartItemsController#create` -> Controller finds/creates Cart -> Finds Product -> Finds/builds CartItem -> Increments quantity or sets to 1 -> Saves CartItem -> Redirects to `CartsController#show` -> Controller finds Cart and items -> Renders `carts/show.html.erb` -> User sees updated cart.

**Checkout Workflow:**

User clicks "Checkout" button -> POST to `OrdersController#create` -> Controller finds Cart -> Starts Transaction -> Builds Order & OrderItems (copying price, checking stock) -> Calculates total -> Saves Order -> Clears Cart -> Redirects User (e.g., to home page) with success message.

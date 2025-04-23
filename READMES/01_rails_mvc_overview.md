# Abito E-commerce - Rails MVC Overview

Ruby on Rails follows the **Model-View-Controller (MVC)** architectural pattern. This pattern separates the application's concerns into three interconnected components:

1.  **Model:** Represents the application's data and business logic.
    *   **What it does:** Interacts with the database (reading, writing, validating data), defines relationships between different data types, and encapsulates business rules.
    *   **In this project:** The `app/models/` directory contains classes like `User`, `Product`, `Category`, `Cart`, `CartItem`, `Order`, and `OrderItem`. These classes inherit from `ApplicationRecord` (which inherits from `ActiveRecord::Base`), giving them methods to interact with their corresponding database tables (e.g., `users`, `products`). They also define associations (like `has_many`, `belongs_to`) and validations. For example, `Product` `belongs_to :category` and `has_many :cart_items`.

2.  **View:** Represents the user interface (UI) of the application.
    *   **What it does:** Displays data to the user and provides forms for user input. In Rails, views are typically HTML files embedded with Ruby code (ERB - Embedded Ruby). They should contain minimal logic, primarily focused on presentation.
    *   **In this project:** The `app/views/` directory contains subdirectories for each controller (e.g., `app/views/products/`, `app/views/carts/`). Files like `index.html.erb` (list view) and `show.html.erb` (detail view) define how products are displayed. They use data provided by the controller (instance variables like `@products`) and helpers to format it (e.g., `number_to_currency`). Layout files (`app/views/layouts/`) define the common structure (like headers, footers, navigation).

3.  **Controller:** Acts as the intermediary between the Model and the View.
    *   **What it does:** Receives requests from the user (via the Router), interacts with the Model to fetch or modify data, and then selects a View to render, passing the necessary data to it.
    *   **In this project:** The `app/controllers/` directory contains classes like `ProductsController`, `CartsController`, etc. These inherit from `ApplicationController`. Each public method in a controller (called an "action") typically corresponds to a specific user request or page. For example, the `index` action in `ProductsController` fetches all products (`@products = Product.all`) and implicitly renders the `app/views/products/index.html.erb` view. The `create` action in `CartItemsController` interacts with the `Cart` and `CartItem` models to add an item and then redirects the user.

**How they work together (Typical Request Flow):**

1.  A user interacts with the UI (e.g., clicks a link or submits a form).
2.  The browser sends an HTTP request to the Rails application.
3.  The **Rails Router** (`config/routes.rb`) matches the request URL and HTTP method to a specific **Controller** action.
4.  The **Controller** action is executed. It might:
    *   Read parameters from the request.
    *   Interact with one or more **Models** to fetch data (e.g., `Product.find(params[:id])`) or save/update data (e.g., `@cart_item.save`).
    *   Prepare data for the view (by setting instance variables, e.g., `@product`).
5.  The Controller tells Rails which **View** to render (often implicitly based on the action name) or issues a redirect.
6.  The **View** is rendered. It accesses the instance variables set by the controller and uses helpers to generate the final HTML.
7.  The generated HTML response is sent back to the browser.
8.  The browser displays the HTML to the user.

This separation makes the code more organized, easier to maintain, and testable.

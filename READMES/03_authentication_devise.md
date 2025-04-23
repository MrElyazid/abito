# Abito E-commerce - Authentication with Devise

This project uses the popular **Devise** gem for user authentication (handling sign-up, login, logout, password management, etc.).

**Setup:**

1.  **Gem Installation:** The `devise` gem is added to the `Gemfile` and installed via `bundle install`.
2.  **Devise Initializer:** Running `rails generate devise:install` creates an initializer file (`config/initializers/devise.rb`) where various Devise settings can be configured (e.g., email settings, password complexity).
3.  **User Model:** Running `rails generate devise User` creates the `User` model (`app/models/user.rb`) and a corresponding database migration (`db/migrate/..._devise_create_users.rb`).
    *   The `User` model includes Devise modules (like `:database_authenticatable`, `:registerable`, `:recoverable`, `:rememberable`, `:validatable`) which provide the core authentication logic (password hashing, session management, registration, password reset, etc.).
    *   The migration adds columns to the `users` table needed by Devise (e.g., `email`, `encrypted_password`, `reset_password_token`, `remember_created_at`).
4.  **Routes:** `devise_for :users` in `config/routes.rb` automatically generates all the necessary routes for authentication actions (e.g., `/users/sign_in`, `/users/sign_up`, `/users/sign_out`, `/users/password/new`).
5.  **Views (Optional):** Devise provides default views. You can generate them into your project using `rails generate devise:views` if you need to customize their appearance. This project seems to be using the default views or slightly customized ones.

**How it Works (Login Example):**

1.  **User Action:** A user navigates to the login page (e.g., `/users/sign_in`).
2.  **View:** Devise renders the login form (likely `app/views/devise/sessions/new.html.erb`).
3.  **Submission:** The user enters their email and password and submits the form. This sends a POST request to `/users/sign_in`.
4.  **Routing:** `devise_for :users` routes this POST request to Devise's internal `SessionsController#create` action.
5.  **Devise Controller:**
    *   Devise retrieves the submitted email and password from the request parameters.
    *   It finds the `User` record matching the email.
    *   It securely compares the submitted password with the `encrypted_password` stored in the database for that user (using bcrypt by default).
    *   **If valid:** Devise creates a user session, marking the user as logged in. It typically stores the user's ID in the session cookie in an encrypted way.
    *   **If invalid:** Devise usually re-renders the login form with an error message.
6.  **Redirection:** Upon successful login, Devise redirects the user to a specified page (often the root path or a previously requested protected page).

**Key Helpers and Methods Provided by Devise:**

Devise makes several helper methods available in your controllers and views:

*   **`user_signed_in?`:** Returns `true` if a user is currently logged in, `false` otherwise. Used frequently in views to show/hide content (e.g., "Login" vs "Logout" links, "Add to Cart" button).
*   **`current_user`:** Returns the `User` object for the currently logged-in user, or `nil` if no user is logged in. Used in controllers to get the user associated with actions (e.g., finding the user's cart).
*   **`authenticate_user!`:** A controller `before_action` filter. If a user is not logged in, it redirects them to the login page. Used to protect controller actions that require a logged-in user (e.g., viewing the cart, checkout process).
*   **`new_user_session_path`:** Path helper for the login page URL (`/users/sign_in`).
*   **`destroy_user_session_path`:** Path helper for the logout URL (`/users/sign_out`). Requires a DELETE request (often triggered by a link with `data-turbo-method="delete"`).
*   **`new_user_registration_path`:** Path helper for the sign-up page URL (`/users/sign_up`).

**Admin Flag:**

This project adds a boolean `admin` column to the `users` table (`db/migrate/..._add_admin_to_users.rb`). This is *not* part of Devise itself but is a common pattern used alongside it.

*   **Model:** The `User` model has the `admin` attribute.
*   **Authorization:** Code checks `current_user.admin?` to determine if a user has administrative privileges.
    *   The `Admin::BaseController` likely uses a `before_action` to ensure only admin users can access controllers within the `Admin` namespace.
    *   The root path logic in `config/routes.rb` also uses this check to redirect admins to the admin dashboard.

Devise primarily handles **authentication** (who the user is), while checking the `admin` flag is a form of **authorization** (what the user is allowed to do).

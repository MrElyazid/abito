# Abito E-commerce - Image Handling with Active Storage

This project uses Rails **Active Storage** to handle file uploads, specifically for product images. Active Storage provides a way to attach files (like images) to Active Record models and manage their storage (locally, or on cloud services like S3, GCS, Azure).

**Setup:**

1.  **Installation:** Active Storage is included by default in recent Rails versions. The necessary database tables are created by running `rails active_storage:install` followed by `rails db:migrate`. This creates `active_storage_blobs` and `active_storage_attachments` tables (and `active_storage_variant_records` for storing variant details).
2.  **Storage Configuration:** `config/storage.yml` defines where files are stored. In development, it typically defaults to `:local` (storing files in the `storage/` directory). For production, you would configure a cloud service like `:amazon`, `:google`, or `:microsoft`.
3.  **Model Association:** The `Product` model (`app/models/product.rb`) declares the attachment using `has_one_attached :image`. This adds methods to the `Product` model for managing the attached image (e.g., `product.image.attach(...)`, `product.image.attached?`, `product.image.purge`).

**Upload Process (Admin Panel):**

1.  **Form:** The admin product form (`app/views/admin/products/_form.html.erb`) uses a standard Rails `file_field` helper:
    ```erb
    <%= form.file_field :image, class: "form-control" %>
    ```
    When the form is submitted with a file selected, the browser sends the file data as part of the request.
2.  **Controller:** The `Admin::ProductsController` (`app/controllers/admin/products_controller.rb`) needs to permit the `:image` attribute in its strong parameters method (`product_params`):
    ```ruby
    def product_params
      params.require(:product).permit(..., :image)
    end
    ```
3.  **Model Update:** When `@product.update(product_params)` or `Product.new(product_params)` is called with the `:image` parameter containing the uploaded file data, Active Storage automatically handles:
    *   Uploading the file to the configured storage service (local disk in development).
    *   Creating a record in the `active_storage_blobs` table to store metadata about the file (filename, content type, size, checksum, storage key).
    *   Creating a record in the `active_storage_attachments` table to link the `Product` record (via `record_type` and `record_id`) to the `active_storage_blobs` record (via `blob_id`) using the attachment name (`image`).

**Displaying Images (Public Views):**

1.  **Checking for Attachment:** Views like `app/views/products/index.html.erb` and `show.html.erb` first check if an image is actually attached:
    ```erb
    <% if product.image.attached? %>
      <%# Display image %>
    <% else %>
      <%# Display placeholder %>
    <% end %>
    ```
2.  **Rendering Variants:** To display images efficiently (e.g., thumbnails), Active Storage uses **variants**. Variants are transformations (like resizing) applied to the original image on demand. The `image_processing` gem (which requires `libvips` or `ImageMagick` to be installed on the system) handles this.
    ```erb
    <%= image_tag product.image.variant(resize_to_limit: [300, 200]), class: "card-img-top" %>
    ```
    *   When this code is first encountered for a specific product and variant size, Active Storage:
        *   Downloads the original image from storage if necessary.
        *   Uses `image_processing` (libvips) to perform the resize operation.
        *   Uploads the *generated variant* back to storage.
        *   Creates an `active_storage_variant_records` entry linking the original blob to this specific transformation.
        *   Generates a temporary, signed URL pointing to the stored variant.
    *   The `image_tag` helper renders an `<img>` tag with the `src` attribute set to this temporary URL.
    *   On subsequent requests for the *same* variant, Active Storage finds the existing variant record and serves the already-generated variant directly, making it much faster.
3.  **Placeholder:** If `product.image.attached?` is false, a placeholder image is displayed instead.

**Key Points:**

*   Active Storage abstracts away the details of where and how files are stored.
*   Variants allow efficient display of different image sizes without modifying the original upload.
*   The `image_processing` gem (and its system dependency `libvips`) is crucial for creating variants. If `libvips` is missing, variant generation will fail (as seen previously with the 500 error).

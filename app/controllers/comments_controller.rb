class CommentsController < ApplicationController
  before_action :authenticate_user! # Ensure user is logged in to comment

  def create
    @product = Product.find(params[:product_id])
    @comment = @product.comments.build(comment_params)
    @comment.user = current_user # Associate comment with the logged-in user

    if @comment.save
      redirect_to product_path(@product), notice: 'Comment added successfully.'
    else
      # If saving fails, redirect back to product page with an alert
      # We need to reload comments in the product show view to display errors if needed
      # For simplicity now, just show a generic alert.
      # A more robust solution might re-render the product show page with the @comment object containing errors.
      redirect_to product_path(@product), alert: 'Failed to add comment. Please ensure your comment is not empty.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
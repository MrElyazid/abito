class AddProductSubmissionFieldsToProducts < ActiveRecord::Migration[8.0]
  def change
    add_reference :products, :submitted_by, foreign_key: { to_table: :users }, null: true
    add_column :products, :status, :string, default: 'pending'
    add_column :products, :admin_notes, :text
    add_index :products, :status
  end
end

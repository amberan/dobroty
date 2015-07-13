class AddColumnsToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :name, :string
    add_column :recipes, :summary, :text
    add_column :recipes, :description, :text
    add_column :recipes, :created_at, :datetime
    add_column :recipes, :updated_at, :datetime
  end
end

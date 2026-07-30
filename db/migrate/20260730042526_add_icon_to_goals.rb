class AddIconToGoals < ActiveRecord::Migration[8.0]
  def change
    add_column :goals, :icon, :string, default: "fa-bullseye"
  end
end

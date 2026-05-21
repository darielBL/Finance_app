class AddSourceToIncomeSources < ActiveRecord::Migration[8.0]
  def change
    add_column :income_sources, :source, :string
  end
end

class RemoveFrequencyFromIncomeSources < ActiveRecord::Migration[8.0]
  def change
    remove_column :income_sources, :frequency, :string
  end
end

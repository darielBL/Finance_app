class RenameGoalContributionsSourceToFromSource < ActiveRecord::Migration[8.0]
  def change
    rename_column :goal_contributions, :source, :from_source
  end
end

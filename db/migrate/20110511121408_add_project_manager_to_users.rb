class AddProjectManagerToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :project_manager, :boolean
  end

  def self.down
    remove_column :users, :project_manager
  end
end

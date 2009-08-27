class CreateAssistants < ActiveRecord::Migration
  def self.up
    create_table :assistants do |t|
      t.string  :name
      t.integer :devhouse
      t.string  :nickname
      t.string  :twitter
      t.string  :facebook
      t.string  :project_name
      t.text    :project_description

      t.timestamps
    end
  end

  def self.down
    drop_table :assistants
  end
end

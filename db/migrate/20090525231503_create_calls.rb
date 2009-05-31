class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.text :description
      t.integer :hours
      t.integer :minutes
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :day
      t.integer :week

      t.timestamps 
    end
  end

  def self.down
    drop_table :events
  end
end
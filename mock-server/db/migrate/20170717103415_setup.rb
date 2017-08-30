class Setup < ActiveRecord::Migration[5.1]
  def change
    
    create_table :test_runs do |t|
      t.string :name
      t.timestamp :started
      t.timestamp :ended
      t.timestamps
    end
    
    add_index :test_runs, :name, unique: true
    
    create_table :tracking_events do |t|
      t.text :content
      t.integer :test_run_id
      t.timestamps
    end
    
    add_foreign_key :tracking_events, :test_runs
    
    create_table :mock_responses do |t|
      t.string :url
      t.string :parameters
      t.string :method
      t.integer :response_status_code
      t.text :response_body
      t.integer :test_run_id
    end
    
    add_foreign_key :mock_responses, :test_runs
    
  end
end

class CreateRegapps < ActiveRecord::Migration
  # registered wechat app
  
  def self.up
    create_table :regapps do |t|
      t.string :cid
      t.string :token
      t.string :key
      t.string :app # app name
      

      t.timestamps
    end
    add_index(:regapps, ["token"], {:unique=>true})
  end

  def self.down
    drop_table :regapps
  end
end

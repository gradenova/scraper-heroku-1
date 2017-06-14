class CreateLogin < ActiveRecord::Migration[5.1]
  def up
  	create_table :logins do |t|
  		t.string :name
  		t.string :password
  	end
  end

  def down
  	drop_table :logins
  end
end
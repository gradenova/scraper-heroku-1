class CreateLogin < ActiveRecord::Migration[5.1]
  def up
  	create_table :login do |t|
  		t.string :name
  		t.string :password
  	end
  end

  def down
  	drop_table :login
  end
end

#https://samuelstern.wordpress.com/2012/11/28/making-a-simple-database-driven-website-with-sinatra-and-heroku/
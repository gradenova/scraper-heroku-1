require "sinatra"
require "mechanize"
require 'sinatra/activerecord'
require "sinatra/cookies" #cookies! yummy
require "./models/login" #database login
require "./models/webscrapers" #webscraper models

get "/" do
	erb :index
end


get "/search" do
		erb :search
end

post "/search" do

	query = params[:q]

	@hof = params[:hof]
	@industry = params[:industry]
	@tool = params[:tool]
	@radwell = params[:radwell]
	@industrialproducts = params[:industrialproducts]
	@webstaurant = params[:webstaurant]
	@zorinmaterial = params[:zorin]
	@digitalbuyer = params[:digitalbuyer]
	@globalindustrial = params[:globalindustrial]
	# @productsthatihave = params[:productclass]

	myscraper = WebScrapers.new

	if @hof == "hofequipment"
		@hofarray = myscraper.arrayhofequipment(query)
	end

	if @industry == "industrialsafety"
		@industrialarray = myscraper.arrayindustrialsafety(query)
	end

	if @tool == "toolfetch"
		@toolfetcharray = myscraper.arraytoolfetch(query)
	end

	if @radwell == "radwell"
		@radwellarray = myscraper.radwell(query)
	end

	if @industrialproducts == "industrialproducts"
		@industrialproductsarray = myscraper.industrialproducts(query)
	end

	if @globalindustrial == "globalindustrial"
		@globalindustrialarray = myscraper.globalindustrial(query)
	end

	if @webstaurant == "webstaurant"
		@webstaurantarray = myscraper.webstaurantstore(query)
	end

	if @zorinmaterial == "zorinmaterial"
		@zorinmaterialarray = myscraper.zorinmaterial(query)
	end

	# paused
	# if @digitalbuyer == "digitalbuyer"
	# 	@digitalbuyerarray = myscraper.digitalbuyer(query)
	# end

	# productclass = Products.new
	# if @productsthatihave == "wireproduct"

	# 	@returninformation = productclass.wireproduct

	# elsif @productsthatihave == "mezzanine"

	# 	@returninformation = productclass.mezzanine

	# elsif @productsthatihave == "inplantoffice"

	# 	@returninformation = productclass.inplantoffice

	# elsif @productsthatihave == "lockers"

	# 	@returninformation = productclass.lockers

	# elsif @productsthatihave == "matting"

	# 	@returninformation = productclass.matting

	# elsif @productsthatihave == "stretchwrapper"

	# 	@returninformation = productclass.stretchwrapper

	# end

	erb :search
end

get "/schedule" do

		erb :schedule

end

get "/signup" do
	erb :signup
end

post "/signup" do
	#@signup = Login.new(params[:model])

	# if @signup.save
	# 	cookies[:loggedin] = "yes"
	# 	redirect "/search"
	# else
	# 	redirect "/signup"
	# 	@error = "Sorry, there was an error!"
	# end

end


get "/login" do
	erb :login
end

post "/login" do

	#loginform = Login.find_by(name: params[:name], password: params[:password])

	#if loginform
		#cookies[:loggedin] = "yes"
	# 	redirect "/search"
	# else
	# 	redirect "/login"
	# end

end

get "/csv/hofequipment" do


		send_file('csv/hofequipment.csv', :filename => "csv/hofequipment.csv")


end

get "/csv/industrialsafety" do

		send_file('csv/industrialsafety.csv', :filename => "csv/industrialsafety.csv")


end

get "/csv/digitalbuyer" do

		send_file('csv/digitalbuyer.csv', :filename => "csv/digitalbuyer.csv")

end

get "/csv/globalindustrial" do

		send_file('csv/globalindustrial.csv', :filename => "csv/globalindustrial.csv")

end


get "/csv/industrialproducts" do

		send_file('csv/industrialproducts.csv', :filename => "csv/industrialproducts.csv")

end


get "/csv/radwell" do

		send_file('csv/radwell.csv', :filename => "csv/radwell.csv")

end


get "/csv/webstaurant" do

		send_file('csv/webstaurantstore.csv', :filename => "csv/webstaurantstore.csv")

end


get "/csv/zorinmaterial" do

		send_file('csv/zorinmaterial.csv', :filename => "csv/zorinmaterial.csv")

end

get "/csv/mixed" do

		send_file('csv/mixed.csv', :filename => "csv/mixed.csv")


end

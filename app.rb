require 'mechanize'
require 'sucker_punch'
require 'sinatra'
require './models/webscrapers'


get "/" do
	erb :index
end

get "/search" do
    erb :search
end
get '/products' do
  erb :products
end
post "/search" do
    @query = params[:query]

	@hofequipment = params[:hofequipment]
	@industrialsafety = params[:industrialsafety]
	@industrialproducts = params[:industrialproducts]
	@zorinmaterial = params[:zorinmaterial]
	@webstaurant = params[:webstaurant]
	@radwell = params[:radwell]
	@globalindustrial = params[:globalindustrial]
	@toolfetch = params[:toolfetch]

	if @hofequipment == "hofequipment"
    	HOFequipment.perform_async(@query)
	end

	if @industrialsafety == "industrialsafety"
    	Industrialsafety.perform_async(@query)
	end

	if @industrialproducts == "industrialproducts"
    	Industrialproducts.perform_async(@query)
	end

	if @toolfetch == "toolfetch"
    	Toolfetch.perform_async(@query)
	end

	if @webstaurant == "webstaurant"
    	Webstaurantstore.perform_async(@query)
	end

	if @radwell == "radwell"
    	Radwell.perform_async(@query)
	end

	if @globalindustrial == "globalindustrial"
    	GlobalIndustrial.perform_async(@query)
	end

	erb :search
end

get "/schedule" do
	return "OH NO! YOU BROKE THE WEBSITE! QUICKLY RETURN TO WHERE YOU CAME FROM."
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

get "/csv/toolfetch" do
		send_file('csv/toolfetch.csv', :filename => "csv/toolfetch.csv")
end

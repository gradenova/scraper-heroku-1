require "sinatra"
require "mechanize"
require "./models/webscrapers"


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

	mytest = WebScrapers.new
	if @hof == "hofequipment"
		@hofarray = mytest.arrayhofequipment(query)
	end

	if @industry == "industrialsafety"
		@industrialarray = mytest.arrayindustrialsafety(query)
	end

	if @tool == "toolfetch"
		@toolfetcharray = mytest.arraytoolfetch(query)
	end	

	erb :search
end

get "/csv/hofequipment" do
	send_file('csv/hofequipment.csv', :filename => "csv/hofequipment.csv")
end

get "/csv/industrialsafety" do
	send_file('csv/industrialsafety.csv', :filename => "csv/industrialsafety.csv")
end

get "/csv/toolfetch" do
	send_file('csv/toolfetch.csv', :filename => "csv/toolfetch.csv")
end

get "/csv/mixed" do
	send_file('csv/mixed.csv', :filename => "csv/mixed.csv")
end

require "sinatra"
require "mechanize"


get "/" do
	erb :index
end

get "/multiple" do
	erb :multiple
end

post "/multiple" do
	#gets query
	query = params[:q]

	#assigns lowest number variable
	@lowestnum = lowestnum(industrialsafety(query), hofequipment(query), toolfetch(query))

	#assigns company variable
	@company = company(industrialsafety(query), hofequipment(query), toolfetch(query))

	#scraper numbers
	@industrialsafety = industrialsafety(query)
	@hofequipment = hofequipment(query)
	@toolfetch = toolfetch(query)


	#this returns views/index.erb
	
	erb :multiple
end

get "/hofequipment" do
	erb :hofequipment
end

post "/hofequipment" do
	query = params[:query]

	@returnedarray = arrayhofequipment(query)

	erb :hofequipment
end

get "/industrialsafety" do
	erb :industrialsafety
end

post "/industrialsafety" do
	query = params[:query]

	@returnedarray = arrayindustrialsafety(query)

	erb :industrialsafety
end

get "/toolfetch" do
	erb :toolfetch
end

post "/toolfetch" do
	query = params[:query]

	@returnedarray = arraytoolfetch(query)

	erb :toolfetch
end

get "/individual" do
	erb :individual
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

get "/test" do
	erb :test
end

post "/test" do
	
	@hof = arrayindustrialsafety(params[:hof])
	@industry = arrayhofequipment(params[:industry])
	@tool = arraytoolfetch(params[:tool])

	erb :test
end


def returnindustrialsafety(query)
	return query
end

#returns table of results from query 
def arrayhofequipment(query)
	open("csv/hofequipment.csv", "w") do |csv|
		csv.truncate(0)				
	end

	query = query.gsub(/\s+/, '')	

	foundprices = []

	myarray = query.split(",")

	myarray.each do |input|

		mechanize = Mechanize.new

		page = mechanize.get("http://hofequipment.com/cart.php?m=search_results&search=" + input)
		
		product = page.at('span.item-name a')
		
		if product
			page = mechanize.click(product)

			price = page.at(".item-price").text.strip
			table = page.at("table")

			if page.at(".chartPersonalization")

				table_data = table.search('tr').map do |row|
					row.search('th, td').map { |cell| cell.text.strip }
				end

				table_data.each do |row|
					row.each do |x|
						if x == input
							price = row[-2]
							price = price.gsub(/[()]/, "")
							price = price.gsub(/[$]/, "")
							price = price.gsub(/[,]/, "")
							foundprices.push(input)
							foundprices.push(price)
							
							
							open("csv/hofequipment.csv", "a") do |csv|
								csv << "HOFequipment"
								csv << ","
								csv << input
								csv << ","	
								csv << price
								csv << "\n"
							
							end
						end
					end
				end

			elsif page.at(".item-price")
					price = price.gsub(/[()]/, "")
					price = price.gsub(/[$]/, "")
					price = price.gsub(/[,]/, "")					
					foundprices.push(input)
					foundprices.push(price)

					open("csv/hofequipment.csv", "a") do |csv|
						csv << "HOFequipment"
						csv << ","
						csv << input
						csv << ","	
						csv << price
						csv << "\n"
					end					
			else
				foundprices.push(input)
				foundprices.push("0.00")
				open("csv/hofequipment.csv", "a") do |csv|
					csv << "HOFequipment"
					csv << ","
					csv << input
					csv << ","	
					csv << "0.00"
					csv << "\n"
				end		

			end

		else
			foundprices.push(input)
			foundprices.push("0.00")
			open("csv/hofequipment.csv", "a") do |csv|
				csv << "HOFequipment"
				csv << ","
				csv << input
				csv << ","	
				csv << "0.00"
				csv << "\n"
			end					
		end
	end

	return foundprices
end

def arrayindustrialsafety(query)
	open("csv/industrialsafety.csv", "w") do |csv|
		csv.truncate(0)				
	end	

	query = query.gsub(/\s+/, '')	

	foundprices = []

	myarray = query.split(",")

	myarray.each do |input|

		url = "http://www.industrialsafety.com/searchresults.asp?Search=" + input + "&Submit="

		mechanize = Mechanize.new

		page = mechanize.get(url)

		if page
			
			product = page.at(".pricecolor")

			# product_code = page.at(".v-product .colors_productname").text

			# product_code = product_code.slice input			


			# if product_code == input
				if product

					price = product.text.strip
					price = price.gsub(/[()]/, "")
					price = price.gsub(/[$]/, "")
					price = price.gsub(/[,]/, "")
					price.slice! "Our Price: "
					foundprices.push(input)
					foundprices.push(price)

					open("csv/industrialsafety.csv", "a") do |csv|
						csv << "Industrial Safety"
						csv << ","
						csv << input
						csv << ","	
						csv << price
						csv << "\n"
					end
				else 
					open("csv/industrialsafety.csv", "a") do |csv|
						csv << "Industrial Safety"
						csv << ","
						csv << input
						csv << ","	
						csv << "0.00"
						csv << "\n"
					end
				end
			# else
			# 	open("csv/industrialsafety.csv", "a") do |csv|
			# 		csv << "Industrial Safety"
			# 		csv << ","
			# 		csv << input
			# 		csv << ","	
			# 		csv << "0.00"
			# 		csv << "\n"
			# 	end
			#end
		end
	end

	return foundprices
end

def arraytoolfetch(query)
	open("csv/toolfetch.csv", "w") do |csv|
		csv.truncate(0)				
	end	

	foundprices = []
	
	query = query.gsub(/\s+/, '')	

	myarray = query.split(",")

		myarray.each do |input|

		mechanize = Mechanize.new

		url = "http://www.bing.com/search?q=site:toolfetch.com+" + input
			
		page = mechanize.get(url)

		if page

			product = page.at("li.b_algo h2 a")

			if product

				page = mechanize.click(product)

				price = page.at("span.price").text.strip

				price = price.gsub(/[$]/, "")
				price = price.gsub(/[,]/, "")

				foundprices.push(input)
				foundprices.push(price)
				
				open("csv/toolfetch.csv", "a") do |csv|
					csv << "Toolfetch"
					csv << ","
					csv << input
					csv << ","	
					csv << price
					csv << "\n"
				end								

			else
				foundprices.push(input)
				foundprices.push("0.00")
				
				open("csv/toolfetch.csv", "a") do |csv|
					csv << "Toolfetch"
					csv << ","
					csv << input
					csv << ","	
					csv << "0.00"
					csv << "\n"
				end						

			end

		else
			foundprices.push(input)
			foundprices.push("0.00")

			open("csv/toolfetch.csv", "a") do |csv|
				csv << "Toolfetch"
				csv << ","
				csv << input
				csv << ","	
				csv << "0.00"
				csv << "\n"
			end				

		end
	end

	return foundprices
end


#scrapers
def hofequipment(input)
	mechanize = Mechanize.new

	page = mechanize.get("http://hofequipment.com/cart.php?m=search_results&search=" + input)
	
	product = page.at('span.item-name a')
	
	if product
		page = mechanize.click(product)

		price = page.at(".item-price").text.strip
		table = page.at("table")

		if page.at(".chartPersonalization")

			table_data = table.search('tr').map do |row|
				row.search('th, td').map { |cell| cell.text.strip }
			end

			table_data.each do |row|
				row.each do |x|
					if x == input
						mynum = row[-2]
						mynum = mynum.gsub(/[()]/, "")
						mynum = mynum.gsub(/[$]/, "")

						open("csv/mixed.csv", "a") do |csv|
							csv << "HOFequipment"
							csv << ","
							csv << input
							csv << ","	
							csv << mynum
							csv << "\n"
						end				

						return mynum

					end
				end
			end

		elsif page.at(".item-price")
				price = price.gsub(/[()]/, "")
				price = price.gsub(/[$]/, "")

				open("csv/mixed.csv", "a") do |csv|
					csv << "HOFequipment"
					csv << ","
					csv << input
					csv << ","	
					csv << price
					csv << "\n"
				end	

				return price
		end

	else
		open("csv/mixed.csv", "a") do |csv|
			csv << "HOFequipment"
			csv << ","
			csv << input
			csv << ","	
			csv << "$0.00"
			csv << "\n"
		end

		return "0.00"
	end
end

def industrialsafety(input)
	url = "http://www.industrialsafety.com/searchresults.asp?Search=" + input + "&Submit="

	open("csv/mixed.csv", "w") do |csv|
		csv.truncate(0)				
	end

	mechanize = Mechanize.new

	page = mechanize.get(url)

	if page
		
		product = page.at(".pricecolor")

		if product

			textInfo = product.text.strip
			clean_string = textInfo.gsub(/[()]/, "")
			clean_string = clean_string.gsub(/[$]/, "")
			clean_string.slice! "Our Price: "
			
			open("csv/mixed.csv", "a") do |csv|
				csv << "Industrial Safety"
				csv << ","
				csv << input
				csv << ","	
				csv << clean_string
				csv << "\n"
			end

			return clean_string
		end

	end
end

def toolfetch(input)
	mechanize = Mechanize.new

	url = "http://www.bing.com/search?q=site:toolfetch.com+" + input
		
	page = mechanize.get(url)

	if page

		price = page.at("li.b_algo h2 a")

		if price

			newprice = mechanize.click(price)

			newprice = newprice.at("span.price").text.strip

			newprice = newprice.gsub(/[$]/, "")

			open("csv/mixed.csv", "a") do |csv|
				csv << "Toolfetch"
				csv << ","
				csv << input
				csv << ","	
				csv << newprice
				csv << "\n"
			end


			return newprice

		else

			open("csv/mixed.csv", "a") do |csv|
				csv << "Toolfetch"
				csv << ","
				csv << input
				csv << ","	
				csv << "0.00"
				csv << "\n"
			end

			return "0.00"

		end

	else

		open("csv/mixed.csv", "a") do |csv|
			csv << "Toolfetch"
			csv << ","
			csv << input
			csv << ","	
			csv << "0.00"
			csv << "\n"
		end


		return "0.00"

	end
end

def mixed(input)
	open("csv/hofequipment.csv", "w") do |csv|
		csv.truncate(0)				
	end

	hofequipment(input)
	industrialsafety(input)
	toolfetch(input)
end

#returns lowest number
def lowestnum(arr1, arr2, arr3)
	myarr = [arr1, arr2, arr3]

	myarr.each do |x|
		if myarr.min == 0 || myarr.min == "0.00"
			myarr.delete(myarr.min)
			return myarr.min
		else
			return myarr.min
		end
	end
end

#returns company of lowest number
def company(arr1, arr2, arr3)

	if arr1 == @lowestnum
		return "Industrial Safety"
	elsif arr2 == @lowestnum
		return "HOFequipment"
	elsif arr3 == @lowestnum
	 	return "Toolfetch"
	else
		return "company name function is broken"
	end
end

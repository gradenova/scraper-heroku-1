require "sinatra"
require "mechanize"

require "sinatra"
require "mechanize"

class WebScrapers

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

end

class Products

	def mezzanine
		return "MEZZ-200"
	end

	def inplantoffice
		return "SHED-5932 SHED-5932-F SHED-118"
	end

	def wireproduct
		return "VWIRE-32H VWIRE-40H VWIRE-48H PCH-96 PCH-108 PCH-120"
	end

	def lockers
		return "VSL-1818 VSL-1836 VSL-2436 VSL-3030 VSL-3636 JVSL-1818 JVSL-2424 JVSL-3030 JVSL-3636"
	end

	def matting
		return "CK-35 CK-310 MAT-EZ-23 MAT-EZ-35 MAT-EZ-310 MAT-EZ-312 MAT-DP-23 MAT-DP-35 MAT-DP-310 MAT-DP-312 MAT-CT-23 MAT-CT-35 MAT-CT-310 MAT-CT-312 EAM-S EAM-D F-GRID F-GRID"
	end

	def stretchwrapper
		return "SWA-48 SWA-54 SWA-60 S-2001"
	end


end



def industrialproducts(input)
	mechanize = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE};

	url = "http://www.industrialproducts.com/"

	page = mechanize.get(url)

	if page
		search_form = page.form

		search_form['q'] = input

		page = search_form.submit

		price = page.at(".price")

		if price
			price = price.text.strip
			# price = price.gsub(/[$]/, "")
			price = price.gsub(/[,]/, "")
			open('example.csv', 'a') do |csv|
				
				csv <<  "Industrial Products"				
				csv << ","
				csv << input
				csv << ","
				csv << price
				csv << "\n"
			end

		else
			open('example.csv', 'a') do |csv|
				
				csv <<  "Industrial Products"				
				csv << ","				
				csv << input
				csv << ","
				csv << "$0.00"
				csv << "\n"
			end
		end
	end
end

def zorinmaterial(input)

	mechanize = Mechanize.new

	mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE


	page = mechanize.get("http://www.zorinmaterial.com/home/")
	
	if page
		search_form = page.form

		search_form['search'] = input

		page = search_form.submit

		viewproduct = page.at("a.le-button")

		page = mechanize.click(viewproduct)

		return puts page.at(".prices .price-current").text.strip

	end
end

def webstaurantstore(input)

	mechanize = Mechanize.new

	mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE


	page = mechanize.get("https://www.webstaurantstore.com/")
	
	if page
		search_form = page.form

		search_form['searchval'] = input

		page = search_form.submit

		price = page.at("p.price").text.strip

		return puts price

	end
end

def digitalbuyer(input)

	mechanize = Mechanize.new

	mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE


	page = mechanize.get("http://www.digitalbuyer.com/")
	
	if page
		search_form = page.form

		search_form['q'] = input

		page = search_form.submit

		price = page.at("span.price").text.strip

		return puts price

	end
end

def radwell(input)
	mechanize = Mechanize.new

	page = mechanize.get("http://www.radwell.com/en-US/")
	
	if page
		search_form = page.form

		search_form['q'] = input

		page = search_form.submit

		price = page.at("span.searchPrLow.searchPr").text.strip

		return puts price

	end
end
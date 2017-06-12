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
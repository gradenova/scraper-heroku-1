#all the webscrapers that are retrieve information

require "sinatra"
require "mechanize"

class WebScrapers

	def formatPrice(price)
		return price.gsub(/[()]/, "").gsub(/[$]/, "").gsub(/[,]/, "")
	end

	def truncateCSV(name)
		open("csv/#{name}.csv", "w") do |csv|
			csv.truncate(0)
		end
	end

	def cleanQuery(myquery)
		return myarray = myquery.gsub(/\s+/, '').split(",")
	end

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

			aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']

			mechanize.user_agent_alias = aliases.sample

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

			aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']

			mechanize.user_agent_alias = aliases.sample

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

	def industrialproducts(query)
		open("csv/industrialproducts.csv", "w") do |csv|
			csv.truncate(0)
		end

		foundprices = []

		query = query.gsub(/\s+/, '')

		myarray = query.split(",")

		myarray.each do |input|

			mechanize = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE};

			aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']

			mechanize.user_agent_alias = aliases.sample

			url = "http://www.industrialproducts.com/"

			page = mechanize.get(url)

			if page
				search_form = page.form

				search_form['q'] = input

				page = search_form.submit

				price = page.at(".price")

				if price
					price = price.text.strip
					price = price.gsub(/[$]/, "")
					price = price.gsub(/[,]/, "")

					foundprices.push(input)
					foundprices.push(price)

					open('csv/industrialproducts.csv', 'a') do |csv|
						csv <<  "Industrial Products"
						csv << ","
						csv << input
						csv << ","
						csv << price
						csv << "\n"
					end
				else

					foundprices.push(input)
					foundprices.push("0.00")

					open('csv/industrialproducts.csv', 'a') do |csv|
						csv <<  "Industrial Products"
						csv << ","
						csv << input
						csv << ","
						csv << "$0.00"
						csv << "\n"
					end
				end
			else

					foundprices.push(input)
					foundprices.push("0.00")

					open('csv/industrialproducts.csv', 'a') do |csv|

						csv <<  "Industrial Products"
						csv << ","
						csv << input
						csv << ","
						csv << "$0.00"
						csv << "\n"
					end
			end
		end

		return foundprices
	end

	def zorinmaterial(query)
		open("csv/zorinmaterial.csv", "w") do |csv|
			csv.truncate(0)
		end

		foundprices = []

		query = query.gsub(/\s+/, '')

		myarray = query.split(",")

		myarray.each do |input|

			mechanize = Mechanize.new

			mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']

			mechanize.user_agent_alias = aliases.sample

			page = mechanize.get("http://www.zorinmaterial.com/home/")

			if page
				search_form = page.form

				search_form['search'] = input

				page = search_form.submit

				viewproduct = page.at("a.le-button")

				page = mechanize.click(viewproduct)

				price = page.at(".prices .price-current")


				if price

					price = price.text.strip
					price = price.gsub(/[$]/, "")
					price = price.gsub(/[,]/, "")

					open('csv/zorinmaterial.csv', 'a') do |csv|
							csv <<  "Zorin Material"
							csv << ","
							csv << input
							csv << ","
							csv << price
							csv << "\n"
					end

					foundprices.push(input)
					foundprices.push(price)
				else

					foundprices.push(input)
					foundprices.push("0.00")

					open('csv/zorinmaterial.csv', 'a') do |csv|
						csv <<  "Zorin Material"
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

				open('csv/zorinmaterial.csv', 'a') do |csv|
					csv <<  "Zorin Material"
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

	def webstaurantstore(query)
		open("csv/webstaurantstore.csv", "w") do |csv|
			csv.truncate(0)
		end

			foundprices = []

			query = query.gsub(/\s+/, '')

			myarray = query.split(",")

			myarray.each do |input|

				mechanize = Mechanize.new

				aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']

				mechanize.user_agent_alias = aliases.sample

				mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

				page = mechanize.get("https://www.webstaurantstore.com/")

				if page
					search_form = page.form

					search_form['searchval'] = input

					page = search_form.submit

					price = page.at("p.price")


					if price

						price = price.text.strip
						price = price.gsub(/[$]/, "")
						price = price.gsub(/[,]/, "")

						foundprices.push(input)
						foundprices.push(price)

						open('csv/webstaurantstore.csv', 'a') do |csv|
							csv <<  "Webstaurant"
							csv << ","
							csv << input
							csv << ","
							csv << price
							csv << "\n"
						end
					else

						foundprices.push(input)
						foundprices.push("0.00")

						open('csv/webstaurantstore.csv', 'a') do |csv|
							csv <<  "Webstaurant"
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

					open('csv/webstaurantstore.csv', 'a') do |csv|
						csv <<  "Webstaurant"
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

	def radwell(query)
		open("csv/radwell.csv", "w") do |csv|
			csv.truncate(0)
		end

		foundprices = []

		query = query.gsub(/\s+/, '')

		myarray = query.split(",")

		myarray.each do |input|

			aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']

			mechanize.user_agent_alias = aliases.sample

			mechanize = Mechanize.new

			page = mechanize.get("http://www.radwell.com/en-US/")



			if page
				search_form = page.form

				search_form['q'] = input

				page = search_form.submit

				price = page.at("span.searchPrLow.searchPr")

				if price

					foundprices.push(input)
					foundprices.push(price)

					open('csv/radwell.csv', 'a') do |csv|
						csv <<  "Webstaurant"
						csv << ","
						csv << input
						csv << ","
						csv << price.text.strip
						csv << "\n"
					end

				else

					foundprices.push(input)
					foundprices.push("0.00")

					open('csv/radwell.csv', 'a') do |csv|
						csv <<  "Webstaurant"
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

				open('csv/radwell.csv', 'a') do |csv|
					csv <<  "Webstaurant"
					csv << ","
					csv << "0.00"
					csv << ","
					csv << price
					csv << "\n"
				end
			end
		end

		return foundprices

	end

	def globalindustrial(query)
		open("csv/globalindustrial.csv", "w") do |csv|
			csv.truncate(0)
		end

		foundprices = []

		query = query.gsub(/\s+/, '')

		myarray = query.split(",")

			myarray.each do |input|

			mechanize = Mechanize.new

			aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']

			mechanize.user_agent_alias = aliases.sample

			mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			page = mechanize.get("http://www.globalindustrial.com/")

			if page
				search_form = page.form_with(id: 'searchForm')

				search_form['q'] = input

				page = search_form.submit

				price = page.at(".price")

				if price

					price = price.text.strip
					price = price.gsub(/[$]/, "")
					price = price.gsub(/[,]/, "")

					foundprices.push(input)
					foundprices.push(price)

					open('csv/globalindustrial.csv', 'a') do |csv|
						csv <<  "Global Industrial"
						csv << ","
						csv << input
						csv << ","
						csv << price
						csv << "\n"
					end
				else

					foundprices.push(input)
					foundprices.push("0.00")

					open('csv/globalindustrial.csv', 'a') do |csv|
						csv <<  "Global Industrial"
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

				open('csv/globalindustrial.csv', 'a') do |csv|
					csv <<  "Global Industrial"
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

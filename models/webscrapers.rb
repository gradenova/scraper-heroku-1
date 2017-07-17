require "sucker_punch"
require "sinatra"
require "mechanize"

class HOFequipment
	include SuckerPunch::Job

	def perform(event)
		arrayhofequipment(event)
	end

	def arrayhofequipment(event)
		open("csv/hofequipment.csv", "w") do |csv|
            csv.truncate(0)
        end

            event = event.gsub(/\s+/, '')

            foundprices = []

            myarray = event.split(",")

            myarray.each do |input|

                mechanize = Mechanize.new

                page = mechanize.get("http://hofequipment.com/cart.php?m=search_results&search=" + input)

				sleep(rand(0..3))

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
end

class Industrialsafety
	include SuckerPunch::Job

    def perform(event)
        arrayindustrialsafety(event)
    end

	def arrayindustrialsafety(event)
		open("csv/industrialsafety.csv", "w") do |csv|
			csv.truncate(0)
		end

		event = event.gsub(/\s+/, '')

		foundprices = []

		myarray = event.split(",")

		myarray.each do |input|

			url = "http://www.industrialsafety.com/searchresults.asp?Search=" + input + "&Submit="

			mechanize = Mechanize.new

			aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']

			page = mechanize.get(url)

			sleep(rand(0..3))

			if page

				product = page.at(".pricecolor")

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
end

class Toolfetch
	include SuckerPunch::Job

    def perform(event)
        arraytoolfetch(event)
    end

	def arraytoolfetch(event)
		open("csv/toolfetch.csv", "w") do |csv|
			csv.truncate(0)
		end

		foundprices = []

		event = event.gsub(/\s+/, '')

		myarray = event.split(",")

		myarray.each do |input|

			mechanize = Mechanize.new

			aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']

			url = "http://www.bing.com/search?q=site:toolfetch.com+" + input

			page = mechanize.get(url)

			sleep(rand(0..3))

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

class Zorinmaterial
	include SuckerPunch::Job

    def perform(event)
        zorinmaterial(event)
    end

	def arrayzorinmaterial(event)
		open("csv/zorinmaterial.csv", "w") do |csv|
			csv.truncate(0)
		end

		foundprices = []

		event = event.gsub(/\s+/, '')

		myarray = event.split(",")

		myarray.each do |input|

			mechanize = Mechanize.new

			mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']

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
end

class Webstaurantstore
	include SuckerPunch::Job

    def perform(event)
        arraywebstaurantstore(event)
    end

	def arraywebstaurantstore(event)
		open("csv/webstaurantstore.csv", "w") do |csv|
			csv.truncate(0)
		end

			foundprices = []

			event = event.gsub(/\s+/, '')

			myarray = event.split(",")

			myarray.each do |input|

				mechanize = Mechanize.new

				aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']



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
end

class Industrialproducts
	include SuckerPunch::Job

    def perform(event)
        arrayindustrialproducts(event)
    end

	def arrayindustrialproducts(event)
		open("csv/industrialproducts.csv", "w") do |csv|
			csv.truncate(0)
		end

		foundprices = []

		event = event.gsub(/\s+/, '')

		myarray = event.split(",")

		myarray.each do |input|

			mechanize = Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE};

			aliases = ['Linux Firefox', 'Windows Chrome', 'Mac Safari']



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
end

class Radwell
	include SuckerPunch::Job

    def perform(query)
        arrayradwell(query)
    end

	def arrayradwell(query)
		open("csv/radwell.csv", "w") do |csv|
			csv.truncate(0)
		end

		foundprices = []

		query = query.gsub(/\s+/, '')

		myarray = query.split(",")

		myarray.each do |input|

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
						csv <<  "Radwell"
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
						csv <<  "Radwell"
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
					csv <<  "Radwell"
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
end

class GlobalIndustrial
	include SuckerPunch::Job

    def perform(query)
        globalindustrial(query)
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

#newly added classes
class Guardian
    include SuckerPunch::Job

	def perform(event)
		guardiancatalog(event)
	end

    def guardiancatalog(event)
        #opens and destroys any prices in guardiancatalog
		 open("csv/guardiancatalog.csv", "w") do |csv|
             csv.truncate(0)
         end
            event = event.gsub(/\s+/, '')
            myarray = event.split(",")
            foundprices = []

            myarray.each do |input|

                mechanize = Mechanize.new

                #grabs website
                page = mechanize.get("http://www.guardiancatalog.com/default.asp")

                #grabs first form on website, inputs model number and submits
                search_form = page.form
                search_form['Search'] = input
				page = search_form.submit

                #grabs url of first product, clicks and grabs price
				url = page.at("a.productnamecolor")

                if url
                    page = mechanize.click(url)
                    price = page.at(".product_saleprice span")

                    if price
                        price = price.text.strip
                        price = price.gsub(/[()]/, "")
                        price = price.gsub(/[$]/, "")
                        price = price.gsub(/[,]/, "")
                        foundprices.push(input)
                        foundprices.push(price)


                        open("csv/guardiancatalog.csv", "a") do |csv|
                            csv << "Guardian Catalog"
                            csv << ","
                            csv << input
                            csv << ","
                            csv << price
                            csv << "\n"
                        end
                    else

                        open("csv/guardiancatalog.csv", "a") do |csv|
                            csv << "Guardian Catalog"
                            csv << ","
                            csv << input
                            csv << ","
                            csv << "0.00"
                            csv << "\n"
                        end

                    end
                else

                    open("csv/guardiancatalog.csv", "a") do |csv|
                        csv << "Guardian Catalog"
                        csv << ","
                        csv << input
                        csv << ","
                        csv << "0.00"
                        csv << "\n"
                    end

                end
            end
    end
end

class Bizchair
    include SuckerPunch::Job

    def perform(event)
        bizchair(event)
    end

    def bizchair(event)
        #opens and destroys any prices in guardiancatalog
		open("csv/bizchair.csv", "w") do |csv|
          csv.truncate(0)
        end
            event = event.gsub(/\s+/, '')
            myarray = event.split(",")
            foundprices = []

            myarray.each do |input|

                mechanize = Mechanize.new

                #grabs website
                page = mechanize.get("http://www.bizchair.com/")


                search_form = page.form

                search_form["w"] = input

                page = search_form.submit

                if page

                    price = page.at(".sale-price").text.strip

                    if price

                        price = price.gsub("$", "")
						price.slice! "Your Price:"

                        open("csv/bizchair.csv", "a") do |csv|
                            csv << "Bizchair,"
                            csv << price
                            csv << ","
                            csv << input
                            csv << "\n"
                        end

                    else

	                    open("csv/bizchair.csv", "a") do |csv|
	                        csv << "Bizchair,"
	                        csv << "0.00"
	                        csv << ","
	                        csv << input
	                        csv << "\n"
	                    end

                    end
                else

	                open("csv/bizchair.csv", "a") do |csv|
	                    csv << "Bizchair,"
	                    csv << "0.00"
	                    csv << ","
	                    csv << input
	                    csv << "\n"
	                end

                end

            end
    end
end

class OpenTip
    include SuckerPunch::Job

    def perform(event)
        opentip(event)
    end

    def opentip(event)
        #opens and destroys any prices in guardiancatalog
		open("csv/opentip.csv", "w") do |csv|
         csv.truncate(0)
        end
            event = event.gsub(/\s+/, '')
            myarray = event.split(",")
            foundprices = []

            myarray.each do |input|

                mechanize = Mechanize.new

                #grabs website
                page = mechanize.get("http://www.opentip.com/search.php")


                search_form = page.form

                search_form["keywords"] = input

                page = search_form.submit

                if page

                    price = page.at(".products_price").text.strip

                    if price


                        price = price.gsub("$", "")
						price.slice! "Your Price:"

                        open("csv/opentip.csv", "a") do |csv|
                            csv << "OpenTip,"
                            csv << price
                            csv << ","
                            csv << input
                            csv << "\n"
                        end

                    else

	                    open("csv/opentip.csv", "a") do |csv|
	                        csv << "OpenTip,"
	                        csv << "0.00"
	                        csv << ","
	                        csv << input
	                        csv << "\n"
	                    end

                    end
                else

	                open("csv/opentip.csv", "a") do |csv|
	                    csv << "OpenTip,"
	                    csv << "0.00"
	                    csv << ","
	                    csv << input
	                    csv << "\n"
	                end

                end

            end
    end
end

#not working - website makes ajax requests
class Kimco
    include SuckerPunch::Job

    def perform(event)
        kimco(event)
    end

    def kimco(event)
        #opens and destroys any prices in guardiancatalog
		open("kimco.csv", "w") do |csv|
         csv.truncate(0)
        end

            event = event.gsub(/\s+/, '')
            myarray = event.split(",")
            foundprices = []

            myarray.each do |input|

                mechanize = Mechanize.new

                mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
                #grabs website
                page = mechanize.get("https://gokimco.com/")

                search_form = page.form

                search_form["q"] = input

                page = search_form.submit

                if page
					sleep(2)
                    price = page.at(".price")

                    if price

                        price = price.text.strip
                        price = price.gsub("$", "")

                        open("kimco.csv", "a") do |csv|
                            csv << "Kimco,"
                            csv << price
                            csv << ","
                            csv << input
                            csv << "\n"

                        end

                    else

	                    open("kimco.csv", "a") do |csv|
	                        csv << "Kimco,"
	                        csv << "0.00"
	                        csv << ","
	                        csv << input
	                        csv << "\n"

	                    end

                    end
                else

	                open("kimco.csv", "a") do |csv|
	                    csv << "Kimco,"
	                    csv << "0.00"
	                    csv << ","
	                    csv << input
	                    csv << "\n"

	                end

                end

            end
    end
end

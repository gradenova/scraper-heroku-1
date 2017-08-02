require "sucker_punch"
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


	    mechanize = Mechanize.new

	    myQuery = event.split(",")
	    event = event.gsub(/\s+/, '')

	    myQuery.each do |individualItem|
	        page = mechanize.get("http://hofequipment.com/cart.php?m=search_results&search=" + individualItem)

			puts "hofequipment has been gotten"
			#need to better throttle requests
			sleep(rand(0..3))

	        productLink = page.search(".grid__item a.thumb")

			#if there are no products returned
			if productLink.empty?
				open("csv/hofequipment.csv", "a") do |csv|
					csv << "HOFequipment"
					csv << ","
					csv << individualItem
					csv << ","
					csv << "0.00"
					csv << "\n"
				end
			else
	        	productLink.each do |thisLink|
					#loops through every product on the page and get the title
					#compares the title to the individualItem, which is the SKU number
					#if the individualItem + "-" is included in the title, eg(Wp-4848-48BB when the search term is WP-4848) then we know to exclude it
					#when the individualItem does NOT include that, we click it because that is the correct one
					#this is very messy and desperately needs to be refactored
	            	if !(thisLink.at(".photoClass")["title"].include? individualItem + "-")
	                    page = mechanize.click(thisLink)

	                    price = page.at(".item-price").text.strip
	                    table = page.at("table")

						#checks to see if the information is in a table
	                    if page.at(".chartPersonalization")

							#table_data is an array with every individual cell as an item
	                        table_data = table.search('tr').map do |row|
	                            row.search('th, td').map { |cell| cell.text.strip }
	                        end

	                        table_data.each do |row|
	                            row.each do |x|
	                                if x == individualItem
										#grabs price, row[-2] = price
	                                    price = row[-2]

										#clean up price, and takes away commas, parentetheses, dollar sign
	                                    price = price.gsub(/[()]/, "").gsub(/[$]/, "").gsub(/[,]/, "")


	                                    open("csv/hofequipment.csv", "a") do |csv|
	                                        csv << "HOFequipment"
	                                        csv << ","
	                                        csv << individualItem
	                                        csv << ","
	                                        csv << price
	                                        csv << "\n"
	                                    end

	                                end
	                            end
	                        end

						#if not in a table, it grabs the price
	                    elsif page.at(".item-price")
							#clean up price, and takes away commas, parentetheses, dollar sign
                            price = price.gsub(/[()]/, "").gsub(/[$]/, "").gsub(/[,]/, "")

                            open("csv/hofequipment.csv", "a") do |csv|
                                csv << "HOFequipment"
                                csv << ","
                                csv << individualItem
                                csv << ","
                                csv << price
                                csv << "\n"
                            end
	                    end
		            end
		        end
			end
		end
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

		myarray = event.split(",")

		myarray.each do |input|

			url = "http://www.industrialsafety.com/searchresults.asp?Search=" + input + "&Submit="

			mechanize = Mechanize.new

			page = mechanize.get(url)

			#do better
			sleep(rand(0..3))

			if page

				product = page.search(".v-product")

                product.each do |individualProduct|
					if !(individualProduct.at("a.v-product__img")["title"].include? input + "-")

						array = individualProduct.at("a.v-product__img")["title"].split(" ")

						array.each do |x|

							if x == input
		                        price = individualProduct.at("div.product_productprice").text

		                        #('a'..'z').to_a ensure perfect match
								price = price.gsub(/[()]/, "").gsub(/[$]/, "").gsub(/[,]/, "")
								price.slice! "Our Price: "

								open("csv/industrialsafety.csv", "a") do |csv|
									csv << "Industrial Safety"
									csv << ","
									csv << input
									csv << ","
									csv << price
									csv << "\n"
								end
							end

						end
					end
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

		return foundprices
	end
end

class Toolfetch
	include SuckerPunch::Job

    def perform(event)
        arraytoolfetch(event)
    end

	def arraytoolfetch(event)
		open("toolfetch.csv", "w") do |csv|
			csv.truncate(0)
		end

		event = event.gsub(/\s+/, '')

		myarray = event.split(",")

		myarray.each do |input|

			mechanize = Mechanize.new

			url = "http://www.bing.com/search?q=site:toolfetch.com+" + input

			page = mechanize.get(url)

			sleep(rand(0..3))

			if page

				product = page.links

				product.each do |x|
					if (x.to_s.include? input)
						page = mechanize.click(x)

						price = page.at(".price").text.strip

						price = price.gsub(/[$]/, "").gsub(/[,]/, "")


						open("csv/toolfetch.csv", "a") do |csv|
							csv << "Toolfetch"
							csv << ","
							csv << input
							csv << ","
							csv << price
							csv << "\n"
						end
					end
				end
			end
		end
		return foundprices
	end
end

class Zorinmaterial
	include SuckerPunch::Job

    def perform(event)
        arrayzorinmaterial(event)
    end

	def arrayzorinmaterial(event)
		open("csv/zorinmaterial.csv", "w") do |csv|
			csv.truncate(0)
		end

		event = event.gsub(/\s+/, '')

		myarray = event.split(",")

		myarray.each do |input|

			mechanize = Mechanize.new

			mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			page = mechanize.get("http://www.zorinmaterial.com/home/")

			sleep(rand(0..3))

			if page
				search_form = page.form

				search_form['searchstring'] = input

				page = search_form.submit

				viewproduct = page.search(".products-list .product-item .body .title a:nth-last-child(1)")

				viewproduct.each do |x|
					if !(x.to_s.include? input + "-")
						page = mechanize.click(x)
						price = page.at(".price-current").text.strip
						price = price.gsub(/[$]/, "").gsub(/[,]/, "")


						open('csv/zorinmaterial.csv', 'a') do |csv|
							csv <<  "Zorinmaterial"
							csv << ","
							csv << input
							csv << ","
							csv << price
							csv << "\n"
						end
					end
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

		query = query.gsub(/\s+/, '')

		myarray = query.split(",")

		myarray.each do |input|

				mechanize = Mechanize.new

				mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

				page = mechanize.get("http://www.globalindustrial.com/")

				if page
					search_form = page.form_with(id: 'searchForm')

					search_form['q'] = input

					page = search_form.submit

					price = page.search(".info .title a")

					price.each do |link|
						page = mechanize.click(link)

						tableElement = page.search(".prodSpec ul ul li span:nth-child(2)")
						newprice = page.at("span[@itemprop='price']")
						tableElement.each do |x|

							if x.text.strip == input
								newprice = newprice.text.strip.gsub(/\,/, '')

								open("csv/globalindustrial.csv", "a") do |csv|
									csv << "Global Industrial,"
									csv << x.text.strip
									csv << ","
									csv << newprice
									csv << "\n"
								end
							end
						end
					end
				end
			end
		return foundprices
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

            myarray.each do |input|

                mechanize = Mechanize.new

                #grabs website
                page = mechanize.get("http://www.opentip.com/search.php")

				sleep(rand(0.5..3))

                search_form = page.form

                search_form["keywords"] = input

                page = search_form.submit

                if page

                    product = page.search(".data")
					product.each do |x|
						modelNumber = x.at(".products_sku").text.strip.gsub("SKU: ETI-", "")

						if modelNumber == input

							open("csv/opentip.csv", "a") do |csv|
								csv << "OpenTip"
								csv << ","
								csv << modelNumber
								csv << ","
								csv << x.at(".usedNewPrice").text.strip.gsub(/[,]/, "").gsub(/[$]/, "")
								csv << "\n"
							end
						end
					end
				end
            end
    end
end

#website responds with weird search return occasionally
# eg query => q=WP-4848-84B-FF
class Industrialproducts
	include SuckerPunch::Job

    def perform(event)
        arrayindustrialproducts(event)
    end

	def arrayindustrialproducts(event)
		open("csv/industrialproducts.csv", "w") do |csv|
			csv.truncate(0)
		end

		puts "Start"
		event = event.gsub(/\s+/, '')
		myarray = event.split(",")

		puts "array has been split"

		myarray.each do |input|

		mechanize =	Mechanize.new{|a| a.ssl_version, a.verify_mode = 'SSLv3', OpenSSL::SSL::VERIFY_NONE};

		mechanize.user_agent_alias = "Windows Chrome"

			mechanize.request_headers

			url = "www.industrialproducts.com"

			page = mechanize.get(url)

			puts "url has been grabbed"

			if page
				search_form = page.form


				search_form['q'] = input

				page = search_form.submit

				puts page.uri

				pageLinks = page.search(".products-grid .product-image")

				pageLinks.each do |link|
					page = mechanize.click(link)

					table = page.search(".data-table tbody tr td a")

					table.each do |x|
						if !(x.text.include? input + "-") && (x.text.include? input)
							page = mechanize.click(x)
							price = page.at("span.map").text

							price = price.gsub(/[$]/, "").gsub(/[,]/, "")

							open("csv/industrialproducts.csv", "a") do |csv|
								csv << "Industrial Products"
								csv << ","
								csv << input
								csv << ","
								csv << price
								csv << "\n"
							end
						end
					end
				end
			end
		end
	end
end
#################################### not working

#having difficulty - not completed
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
#delayed
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

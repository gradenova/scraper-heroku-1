require "sucker_punch"
require "mechanize"


class HOFequipment
	include SuckerPunch::Job

	def perform(event)
		arrayhofequipment(event)
	end

	def stripQuery(string)
		string = string.gsub("MODEL	OUR PRICE	LIST PRICE	OUR COST	COMPETITOR	COMPETITOR NAME", "").gsub(/\$(\d+)\.(\d+)/, "").gsub(/\t/, "").split("\n")

	    arr = string.map do |x|
	    	x.gsub(/\s+/, "")
	    end

	    (0..3).each do |x|
      		arr.shift()
	    end

	    (0..2).each do |x|
	    	arr.pop()
	    end

	    arr = arr.uniq

	    arr.shift()

	    return arr
	end

	def arrayhofequipment(event)
		open("csv/hofequipment.csv", "w") do |csv|
	        csv.truncate(0)
	    end

	    mechanize = Mechanize.new

		myQuery = stripQuery(event)

	    myQuery.each do |individualItem|
	        page = mechanize.get("http://hofequipment.com/cart.php?m=search_results&search=" + individualItem)

			puts "hofequipment has been gotten"
			puts individualItem
			#need to better throttle requests
			sleep(rand(0..3))

	        productLink = page.search(".grid__item a.thumb")


			if productLink.empty?
				open("csv/hofequipment.csv", "a") do |csv|
					csv << "HOFequipment,"
					csv << individualItem
					csv << ","
					csv << "0.00"
					csv << "\n"
				 end

			 else
	        	productLink.each do |thisLink|

					#loops through every product on the page and get the title		 +
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
 	                                        csv << "HOFequipment,"
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
								 csv << "HOFequipment,"
								 csv << individualItem
								 csv << ","
								 csv << price
								 csv << "\n"
                              end

						else
							open("csv/hofequipment.csv", "a") do |csv|
								csv << "HOFequipment,"
								csv << individualItem
								csv << ","
								csv << "0.00"
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

	def stripQuery(string)
		string = string.gsub("MODEL	OUR PRICE	LIST PRICE	OUR COST	COMPETITOR	COMPETITOR NAME", "").gsub(/\$(\d+)\.(\d+)/, "").gsub(/\t/, "").split("\n")

		arr = string.map do |x|
			x.gsub(/\s+/, "")
		end

		(0..3).each do |x|
			arr.shift()
		end

		(0..2).each do |x|
			arr.pop()
		end

		arr = arr.uniq

		arr.shift()

		return arr
	end

	def arrayindustrialsafety(event)
		open("csv/industrialsafety.csv", "w") do |csv|
			csv.truncate(0)
		end

		myarray = stripQuery(event)

			myarray.each do |input|

			url = "http://www.industrialsafety.com/searchresults.asp?Search=" + input + "&Submit="

			mechanize = Mechanize.new

			page = mechanize.get(url)

			#do better
			sleep(rand(0..3))


			if page

				product = page.search(".v-product")

				if product.empty?
					open("csv/industrialsafety.csv", "a") do |csv|
						csv << "Industrial Safety," + input + "," + "0.00" + "\n"
					end
				end


                product.each do |individualProduct|

					#basically makes selection faster
					#will
					if !(individualProduct.at("a.v-product__img")["title"].include? input + "-")

						array = individualProduct.at("a.v-product__img")["title"].split(" ")

						array.each do |x|

							if x == input
		                        price = individualProduct.at("div.product_productprice").text

		                        #('a'..'z').to_a ensure perfect match
								price = price.gsub(/[()]/, "").gsub(/[$]/, "").gsub(/[,]/, "")
								price.slice! "Our Price: "

								open("csv/industrialsafety.csv", "a") do |csv|
									csv << "Industrial Safety," + input + "," + price + "\n"
								end
							end
	                	end
					end
				end
			end
		end
	end
end

class Toolfetch
	include SuckerPunch::Job

    def perform(event)
        arraytoolfetch(event)
    end

	def stripQuery(string)
		string = string.gsub("MODEL	OUR PRICE	LIST PRICE	OUR COST	COMPETITOR	COMPETITOR NAME", "").gsub(/\$(\d+)\.(\d+)/, "").gsub(/\t/, "").split("\n")

	    arr = string.map do |x|
	    	x.gsub(/\s+/, "")
	    end

	    (0..3).each do |x|
      		arr.shift()
	    end

	    (0..2).each do |x|
	    	arr.pop()
	    end

	    arr = arr.uniq

	    arr.shift()

	    return arr
	end

	def arraytoolfetch(event)
		open("csv/toolfetch.csv", "w") do |csv|
			csv.truncate(0)
		end

		myarray = stripQuery(event)

		myarray.each do |input|


			mechanize = Mechanize.new
			mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			url = "http://www.bing.com/search?q=site:toolfetch.com+" + input

			page = mechanize.get(url)

			sleep(rand(0..3))

			if page

				product = page.search("li.b_algo h2 a")

				if product.empty?
					open("csv/toolfetch.csv", "a") do |csv|
						csv << "Toolfetch, " + input + "," + "0.00" + "\n"
					end
				end

				product.each do |x|
					if x['href'].include? ".pdf"
						puts x
						puts "passed"

					else
						page = mechanize.click(x)

							if page
								title = page.title.split(" ")

								if title[1] == input #this is going to break --- be aware

									price = page.at(".price").text.strip
									price = price.gsub(/[$]/, "").gsub(/[,]/, "")

									open("csv/toolfetch.csv", "a") do |csv|
										csv << "Toolfetch, " + input + "," + price + "\n"
									end
								end
							end
					end
				end
			end
		end
	end
end

class Zorinmaterial
	include SuckerPunch::Job

    def perform(event)
        arrayzorinmaterial(event)
    end

	def stripQuery(string)
		string = string.gsub("MODEL	OUR PRICE	LIST PRICE	OUR COST	COMPETITOR	COMPETITOR NAME", "").gsub(/\$(\d+)\.(\d+)/, "").gsub(/\t/, "").split("\n")

	    arr = string.map do |x|
	    	x.gsub(/\s+/, "")
	    end

	    (0..3).each do |x|
      		arr.shift()
	    end

	    (0..2).each do |x|
	    	arr.pop()
	    end

	    arr = arr.uniq

	    arr.shift()

	    return arr
	end

	def arrayzorinmaterial(event)
		open("csv/zorinmaterial.csv", "w") do |csv|
			csv.truncate(0)
		end

		myarray = stripQuery(event)

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


				if viewproduct.empty?
					open('csv/zorinmaterial.csv', 'a') do |csv|
						csv <<  "Zorinmaterial," + input +  "," + "0.00" + "\n"
					end
				end


				viewproduct.each do |x|
					if !(x.to_s.include? input + "-")
						page = mechanize.click(x)
						price = page.at(".price-current").text.strip
						price = price.gsub(/[$]/, "").gsub(/[,]/, "")


						open('csv/zorinmaterial.csv', 'a') do |csv|
							csv <<  "Zorinmaterial," + input +  "," + price + "\n"
						end
					end
				end
			end
		end
	end
end

class GlobalIndustrial
	include SuckerPunch::Job

    def perform(query)
        globalindustrial(query)
    end

	def stripQuery(string)
		string = string.gsub("MODEL	OUR PRICE	LIST PRICE	OUR COST	COMPETITOR	COMPETITOR NAME", "").gsub(/\$(\d+)\.(\d+)/, "").gsub(/\t/, "").split("\n")

	    arr = string.map do |x|
	    	x.gsub(/\s+/, "")
	    end

	    (0..3).each do |x|
      		arr.shift()
	    end

	    (0..2).each do |x|
	    	arr.pop()
	    end

	    arr = arr.uniq

	    arr.shift()

	    return arr
	end

	def globalindustrial(query)
		open("csv/globalindustrial.csv", "w") do |csv|
			csv.truncate(0)
		end

		myarray = stripQuery(query)

		myarray.each do |input|

			mechanize = Mechanize.new

			mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			page = mechanize.get("http://www.globalindustrial.com/")

			if page
				search_form = page.form_with(id: 'searchForm')

				search_form['q'] = input

				page = search_form.submit

				price = page.search(".grid .prod li .info .title a")

				if price.empty?
					open("csv/globalindustrial.csv", "a") do |csv|
						csv << "Global Industrial," +  input + "," + "0.00" + "\n"
					end
				end

				price.each do |link|
					page = mechanize.click(link)

					tableElement = page.search(".prodSpec ul ul li span:nth-child(2)")
					newprice = page.at("span[@itemprop='price']")

					#goes through product specifications on page
					tableElement.each do |x|

						if x.text.strip == input
							newprice = newprice.text.strip.gsub(/\,/, '')

							open("csv/globalindustrial.csv", "a") do |csv|
								csv << "Global Industrial," +  input + "," + newprice + "\n"
							end
						end
					end
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

	def stripQuery(string)
		string = string.gsub("MODEL	OUR PRICE	LIST PRICE	OUR COST	COMPETITOR	COMPETITOR NAME", "").gsub(/\$(\d+)\.(\d+)/, "").gsub(/\t/, "").split("\n")

		arr = string.map do |x|
			x.gsub(/\s+/, "")
		end

		(0..3).each do |x|
			arr.shift()
		end

		(0..2).each do |x|
			arr.pop()
		end

		arr = arr.uniq

		arr.shift()

		return arr
	end

    def opentip(event)
        #opens and destroys any prices in guardiancatalog
		open("csv/opentip.csv", "w") do |csv|
         csv.truncate(0)
        end

            myarray = stripQuery(event)

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

					if product.empty?
						open("csv/opentip.csv", "a") do |csv|
							csv << "OpenTip," +  input + "," + "0.00" + "\n"
						end
					end

					product.each do |x|
						modelNumber = x.at(".products_sku").text.strip.gsub("SKU: ETI-", "")

						if modelNumber == input

							open("csv/opentip.csv", "a") do |csv|
								csv << "OpenTip," +  input + "," + x.at(".usedNewPrice").text.strip.gsub(/[,]/, "").gsub(/[$]/, "") + "\n"
							end
						end
					end
				end
            end
    end
end

#VERY difficult to scrape
#class Webstaurantstore
	include SuckerPunch::Job

    def perform(event)
        arraywebstaurantstore(event)
    end

	def stripQuery(string)
		string = string.gsub("MODEL	OUR PRICE	LIST PRICE	OUR COST	COMPETITOR	COMPETITOR NAME", "").gsub(/\$(\d+)\.(\d+)/, "").gsub(/\t/, "").split("\n")

		arr = string.map do |x|
			x.gsub(/\s+/, "")
		end

		(0..3).each do |x|
			arr.shift()
		end

		(0..2).each do |x|
			arr.pop()
		end

		arr = arr.uniq

		arr.shift()

		return arr
	end

	def arraywebstaurantstore(event)
		open("csv/webstaurantstore.csv", "w") do |csv|
			csv.truncate(0)
		end

		myarray = stripQuery(event)

		puts myarray

		myarray.each do |input|

			mechanize = Mechanize.new

			mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			page = mechanize.get("https://www.webstaurantstore.com/")

			sleep(rand(0..3))

			if page
				search_form = page.form

				search_form['searchval'] = input

				page = search_form.submit

				price = page.search("div.details a")

				if price.empty?
					open('csv/webstaurantstore.csv', 'a') do |csv|
						csv <<  "Webstaurant," +  input + "," + "0.00" + "\n"
					end
				end

				notfound = price.length
				notfoundcount = 0
				puts notfound
				price.each do |x|
					page = mechanize.click(x)
					mypage = page.at(".mfr-number")

					if mypage.contains? == input
						price = page.at("p.price span")

						open('csv/webstaurantstore.csv', 'a') do |csv|
							csv <<  "Webstaurant," +  input + "," + price + "\n"
						end

					else
						notfoundcount += 1

						if notfound == notfoundcount
							open('csv/webstaurantstore.csv', 'a') do |csv|
								csv <<  "Webstaurant," +  input + "," + "0.00" + "\n"
							end
						end
					end
				end
			else
				open('csv/webstaurantstore.csv', 'a') do |csv|
					csv <<  "Webstaurant," +  input + "," + "0.00" + "\n"
				end
			end
		end
	end
end

class Ckitchen
	include SuckerPunch::Job

    def perform(event)
        ckitchen(event)
    end

	def ckitchen(event)
		open("csv/ckitchen.csv", "w") do |csv|
			csv.truncate(0)
		end

			myarray = stripQuery(event)

			myarray.each do |input|

				mechanize = Mechanize.new

				mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

				page = mechanize.get("https://www.ckitchen.com/")

				sleep(rand(0..3))

			if page
				search_form = page.form

				search_form['query'] = input
				page = search_form.submit

				item = page.search(".products-grid-item .desc-zone a")

				if item.empty?
					open('csv/webstaurantstore.csv', 'a') do |csv|
						csv <<  "Webstaurant"
						csv << ","
						csv << input
						csv << ","
						csv << "0.00"
						csv << "\n"
					end
				end


				item.each do |x|
					page = mechanize.click(x)
					sku = page.at("div.product-sku").text

					if sku == input
						price = page.at(".product-price .price-bold").text.gsub("$", "").gsub(",", "")

						open('csv/ckitchen.csv', 'a') do |csv|
							csv <<  "Ckitchen"
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

class HotelRestaurant
	include SuckerPunch::Job

    def perform(event)
        hotelRestaurantSupply(event)
    end

	def hotelRestaurantSupply(event)
		open("csv/hotelrestaurant.csv", "w") do |csv|
			csv.truncate(0)
		end

		event = event.gsub(/\s+/, '')

		myarray = event.split(",")

		myarray.each do |input|

			mechanize = Mechanize.new

			mechanize.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			page = mechanize.get("https://www.hotelrestaurantsupply.com/mm5/merchant.mvc?Screen=JSON&Products=MTR-" + input)

			sleep(rand(0..3))

			if page

				if page.at("span.subProdPrice span.red")
					price = page.at("span.subProdPrice span.red").text.strip.gsub("Today's Price: $", "").gsub("/ Each", "")

					open("csv/hotelrestaurant.csv", "a") do |csv|
						csv << "HotelRestaurantSupply,"
						csv << input
						csv << ","
						csv << price
						csv << "\n"
					end

				else

					open("csv/hotelrestaurant.csv", "a") do |csv|
						csv << "HotelRestaurantSupply,"
						csv << input
						csv << ","
						csv << "0.00"
						csv << "\n"
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

			url = "http://www.industrialproducts.com"

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
						#if the input is a substring of another model number, it should return false
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

		myarray = query.gsub(/\s+/, '').split(",")

		myarray.each do |input|

			mechanize = Mechanize.new

			page = mechanize.get("http://www.radwell.com/en-US/")

			if page
				search_form = page.form

				search_form['q'] = input

				page = search_form.submit

				price = page.at("span.searchPrLow.searchPr")

				if price

					open('csv/radwell.csv', 'a') do |csv|
						csv <<  "Radwell"
						csv << ","
						csv << input
						csv << ","
						csv << price.text.strip
						csv << "\n"
					end
				else

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

            search_form["q"] = input

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

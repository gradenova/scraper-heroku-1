require "sinatra"
require "mechanize"


get "/" do
	erb :index
end

post "/" do
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
	erb :index
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
						return mynum

					end
				end
			end

		elsif page.at(".item-price")
				price = price.gsub(/[()]/, "")
				price = price.gsub(/[$]/, "")
				return price
		end

	else
		return "0.00"
	end
end

def industrialsafety(input)
	url = "http://www.industrialsafety.com/searchresults.asp?Search=" + input + "&Submit="

	mechanize = Mechanize.new

	page = mechanize.get(url)

	if page
		
		product = page.at(".pricecolor")

		if product

			textInfo = product.text.strip
			clean_string = textInfo.gsub(/[()]/, "")
			clean_string = clean_string.gsub(/[$]/, "")
			clean_string.slice! "Our Price: "
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

			newprice = newprice.at("span.price").text	

			newprice = newprice.gsub(/[$]/, "")

			return newprice
		else
			return "0.00"
		end

	else
		return "0.00"
	end
end

#returns lowest number
def lowestnum(arr1, arr2, arr3)

	arr1, arr2, arr3, arr4 = arr1.to_f, arr2.to_f, arr3.to_f, arr4.to_f


	myarr = [arr1, arr2, arr3, arr4]

	myarr.each do |x|
		if myarr.min == 0
			myarr.delete(myarr.min)
			return myarr.min
		else
			return myarr.min
		end
	end
end

#returns company of lowest number
def company(arr1, arr2, arr3)

	if arr1.to_f == @lowestnum
		return "Industrial Safety"
	elsif arr2.to_f == @lowestnum
		return "HOFequipment"
	elsif arr3.to_f == @lowestnum
	 	return "Toolfetch"
	else
		return "company name function is broken"
	end
end


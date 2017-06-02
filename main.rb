require "sinatra"
require "mechanize"


get "/" do
	erb :index
end

post "/" do
	#gets query
	query = params[:q]

	#assigns lowest number variable
	@lowestnum = lowestnum(industrialsafety(query), hofequipment(query), toolfetch(query), industrialproducts(query))

	#assigns company variable
	@company = company(industrialsafety(query), hofequipment(query), toolfetch(query), industrialproducts(query))

	#scraper numbers
	@industrialsafety = industrialsafety(query)
	@hofequipment = hofequipment(query)
	@toolfetch = toolfetch(query)
	@industrialproducts = industrialproducts(query)

	#returns views/index.erb
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

			#CSV.open('example.csv', 'a') do |csv|
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
			#end

		elsif page.at(".item-price")
				price = price.gsub(/[()]/, "")
				price = price.gsub(/[$]/, "")
				return price
				# open("example.csv", "a") do |fileopen|
				# 	fileopen << input
				# 	fileopen << ","
				# 	fileopen << price
				# 	fileopen << "\n"
				# end
			
		end

	else
		return "0.00"
	end
end

def industrialproducts(input)
	mechanize = Mechanize.new

	url = "http://www.industrialproducts.com/"

	page = mechanize.get(url)

	search_form = page.form

	search_form['q'] = input

	page = search_form.submit

	price = page.at(".price")

	if price
		price = price.text
		price = price.gsub(/[$]/, "")
		return price
	else
		return "0.00"
	end
end

def industrialsafety(input)
	url = "http://www.industrialsafety.com/searchresults.asp?Search=" + input + "&Submit="

	mechanize = Mechanize.new

	page = mechanize.get(url)

	product = page.at(".pricecolor")
	if product
		textInfo = product.text.strip
		clean_string = textInfo.gsub(/[()]/, "")
		clean_string = clean_string.gsub(/[$]/, "")
		clean_string.slice! "Our Price: "
		return clean_string
		# CSV.open('example.csv', 'a') do |csv|
		# 	csv << [model, textInfo]
		# end
	end
end

def toolfetch(input)
	mechanize = Mechanize.new
	url = "http://www.bing.com/search?q=site:toolfetch.com+" + input
		
	page = mechanize.get(url)

	price = page.at("li.b_algo h2 a")

	newprice = mechanize.click(price)

	newprice = newprice.at("span.price").text	
	newprice = newprice.gsub(/[$]/, "")
	return newprice
end

#returns lowest number
def lowestnum(arr1, arr2, arr3, arr4)

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
def company(arr1, arr2, arr3, arr4)

	if arr1.to_f == @lowestnum
		return "Industrial Safety"
	elsif arr2.to_f == @lowestnum
		return "HOFequipment"
	elsif arr3.to_f == @lowestnum
		return "Toolfetch"
	elsif arr4.to_f == @lowestnum
		return "Industrial Products"
	else
		return "something broke, tell sam"
	end
end


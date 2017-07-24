require 'mechanize'
require 'sucker_punch'
require 'sinatra'
require './models/webscrapers'
require './models/products'


get "/" do
	erb :index
end

get "/search" do
    erb :search
end


post "/search" do
    @query = params[:query]

	@hofequipment = params[:hofequipment]
	@industrialsafety = params[:industrialsafety]
	@industrialproducts = params[:industrialproducts]
	@zorinmaterial = params[:zorinmaterial]
	@webstaurant = params[:webstaurant]
	@radwell = params[:radwell]
	@globalindustrial = params[:globalindustrial]
	@toolfetch = params[:toolfetch]
	@zorinmaterial = params[:zorinmaterial]
	@opentip = params[:opentip]

	if @hofequipment == "hofequipment"
    	HOFequipment.perform_async(@query)
	end

	if @industrialsafety == "industrialsafety"
    	Industrialsafety.perform_async(@query)
	end

	if @zorinmaterial == "zorinmaterial"
		Zorinmaterial.perform_async(@query)
	end

	if @industrialproducts == "industrialproducts"
    	Industrialproducts.perform_async(@query)
	end

	if @toolfetch == "toolfetch"
    	Toolfetch.perform_async(@query)
	end

	if @webstaurant == "webstaurant"
    	Webstaurantstore.perform_async(@query)
	end

	if @radwell == "radwell"
    	Radwell.perform_async(@query)
	end

	if @globalindustrial == "globalindustrial"
    	GlobalIndustrial.perform_async(@query)
	end

	if @opentip == "opentip"
		OpenTip.perform_async(@query)
	end


	erb :search
end

get "/schedule" do
	return "OH NO! YOU BROKE THE WEBSITE! QUICKLY RETURN TO WHERE YOU CAME FROM."
end


get "/csv/hofequipment" do
		send_file('csv/hofequipment.csv', :filename => "csv/hofequipment.csv")
end

get "/csv/industrialsafety" do
		send_file('csv/industrialsafety.csv', :filename => "csv/industrialsafety.csv")
end

get "/csv/digitalbuyer" do
		send_file('csv/digitalbuyer.csv', :filename => "csv/digitalbuyer.csv")
end

get "/csv/globalindustrial" do
		send_file('csv/globalindustrial.csv', :filename => "csv/globalindustrial.csv")
end

get "/csv/industrialproducts" do
		send_file('csv/industrialproducts.csv', :filename => "csv/industrialproducts.csv")
end

get "/csv/radwell" do
		send_file('csv/radwell.csv', :filename => "csv/radwell.csv")
end

get "/csv/webstaurant" do
		send_file('csv/webstaurantstore.csv', :filename => "csv/webstaurantstore.csv")
end

get "/csv/zorinmaterial" do
		send_file('csv/zorinmaterial.csv', :filename => "csv/zorinmaterial.csv")
end

get "/csv/toolfetch" do
		send_file('csv/toolfetch.csv', :filename => "csv/toolfetch.csv")
end

get '/products' do
	erb :products
end

post '/products' do

	@submission = params[:submission]

	vestil = Vestil.new
	dutro = Dutro.new
	lyon = Lyon.new
	wesco = Wesco.new
	valleycraft = ValleyCraft.new
	lewisbins = LewisBins.new
	quantum = Quantum.new
	equipto = Equipto.new
	iac = IAC.new
	royal = Royal.new
	bluff = Bluff.new
	metro = Metro.new
	tennsco = Tennsco.new
	morse = Morse.new
	durham = Durham.new
	presto = Presto.new
	mecoomaha = MecoOmaha.new
	eagle = Eagle.new
	jesco = Jesco.new
	harpertrucks = HarperTrucks.new
	aignerindex = AignerIndex.new
	jarke = Jarke.new
	genie = Genie.new
	roach = Roach.new
	wearwell = Wearwell.new
	bishamon = Bishamon.new
	wesley = Wesley.new
	ballymore = BallyMore.new
	ladder = Ladder.new
	chasedoors = ChaseDoors.new
	nordock = Nordock.new
	pacific = Pacific.new
	other = Other.new
	akrofloormats = AkroFloorMats.new
	notrax = NoTrax.new
	triplediamond = TripleDiamond.new
	scotlandrack = ScotlandRack.new
	clearway = Clearway.new
	marsair = MarsAir.new
	benchpro = BenchPro.new
	flexmaterialhandling = FlexMaterialHandling.new
	southworth = Southworth.new
	hamiltoncasters = HamiltonCasters.new
	kubinec = Kubinec.new
	reelcraft = Reelcraft.new
	durashelf = Durashelf.new
	orbis = Orbis.new
	flexangle = FlexAngle.new
	advancetabco = AdvanceTabco.new
	biofit = BioFit.new
	handy = Handy.new
	infrapak = InfraPak.new
	trilitemars = TriLiteMars.new
	forearmforklift = ForearmForklift.new
	pioneer = Pioneer.new
	bestconveyors = BestConveyors.new
	stackbin = Stackbin.new
	lakeside = Lakeside.new
	littlegiant = LittleGiant.new
	spanco = Spanco.new
	jet = Jet.new
	hillmanrollers = HillmanRollers.new
	newlondon = NewLondon.new
	rollaway = RollAway.new
	borroughs = Borroughs.new
	illinoisengineered = IllinoisEngineered.new
	interthor = Interthor.new
	topperindustrial = TopperIndustrial.new
	mfg = MFG.new
	meese = Meese.new
	bayhead = Bayhead.new
	autoquip = AutoQuip.new
	raymond = Raymond.new
	mallard = Mallard.new
	huskyrack = HuskyRack.new
	quikpik = QuikPik.new
	rivetier = RiveTier.new
	luxor = Luxor.new
	copperloy = CopperLoy.new
	fairbanks = Fairbanks.new
	akromills = AkroMills.new
	coxreels = Coxreels.new
	pucel = Pucel.new
	nashville = Nashville.new
	hwilson = HWilson.new
	wisconsin = Wisconsin.new
	bevco = Bevco.new
	mobile = Mobile.new
	rousseau = Rousseau.new
	pollard = Pollard.new
	safco = Safco.new
	midstates = MidStates.new
	singerssafety = SingerSafety.new
	goff = Goff.new
	triton = Triton.new
	thern = Thern.new
	budgit = Budgit.new
	coffing = Coffing.new
	cm = CM.new
	omtec = Omtec.new
	ezlift = Ezlift.new
	tractek = Tractel.new
	bradleycorp = BradleyCorp.new
	cotterman = Cotterman.new
	hallowell = Hallowell.new
	louisvilleladder = LouisvilleLadder.new
	nutting = Nutting.new
	sandusky = Sandusky.new
	carefreetire = CarefreeTire.new




if @submission == "vestil"
@information = vestil.product
end
if @submission == "dutro"
@information = dutro.product
end
if @submission == "lyon"
@information = lyon.product
end
if @submission == "wesco"
@information = wesco.product
end
if @submission == "valleycraft"
@information = valleycraft.product
end
if @submission == "lewisbins"
@information = lewisbins.product
end
if @submission == "quantum"
@information = quantum.product
end
if @submission == "equipto"
@information = equipto.product
end
if @submission == "iac"
@information = iac.product
end
if @submission == "royal"
@information = royal.product
end
if @submission == "bluff"
@information = bluff.product
end
if @submission == "metro"
@information = metro.product
end
if @submission == "tennsco"
@information = tennsco.product
end
if @submission == "morse"
@information = morse.product
end
if @submission == "durham"
@information = durham.product
end
if @submission == "presto"
@information = presto.product
end
if @submission == "mecoomaha"
@information = mecoomaha.product
end
if @submission == "eagle"
@information = eagle.product
end
if @submission == "jesco"
@information = jesco.product
end
if @submission == "harpertrucks"
@information = harpertrucks.product
end
if @submission == "aignerindex"
@information = aignerindex.product
end
if @submission == "jarke"
@information = jarke.product
end
if @submission == "genie"
@information = genie.product
end
if @submission == "roach"
@information = roach.product
end
if @submission == "wearwell"
@information = wearwell.product
end
if @submission == "bishamon"
@information = bishamon.product
end
if @submission == "wesley"
@information = wesley.product
end
if @submission == "ballymore"
@information = ballymore.product
end
if @submission == "ladder"
@information = ladder.product
end
if @submission == "chasedoors"
@information = chasedoors.product
end
if @submission == "nordock"
@information = nordock.product
end
if @submission == "pacific"
@information = pacific.product
end
if @submission == "other"
@information = other.product
end
if @submission == "akrofloormats"
@information = akrofloormats.product
end
if @submission == "notrax"
@information = notrax.product
end
if @submission == "triplediamond"
@information = triplediamond.product
end
if @submission == "scotlandrack"
@information = scotlandrack.product
end
if @submission == "clearway"
@information = clearway.product
end
if @submission == "marsair"
@information = marsair.product
end
if @submission == "benchpro"
@information = benchpro.product
end
if @submission == "flexmaterialhandling"
@information = flexmaterialhandling.product
end
if @submission == "southworth"
@information = southworth.product
end
if @submission == "hamiltoncasters"
@information = hamiltoncasters.product
end
if @submission == "kubinec"
@information = kubinec.product
end
if @submission == "reelcraft"
@information = reelcraft.product
end
if @submission == "durashelf"
@information = durashelf.product
end
if @submission == "orbis"
@information = orbis.product
end
if @submission == "flexangle"
@information = flexangle.product
end
if @submission == "advancetabco"
@information = advancetabco.product
end
if @submission == "biofit"
@information = biofit.product
end
if @submission == "handy"
@information = handy.product
end
if @submission == "infrapak"
@information = infrapak.product
end
if @submission == "trilitemars"
@information = trilitemars.product
end
if @submission == "forearmforklift"
@information = forearmforklift.product
end
if @submission == "pioneer"
@information = pioneer.product
end
if @submission == "bestconveyors"
@information = bestconveyors.product
end
if @submission == "stackbin"
@information = stackbin.product
end
if @submission == "lakeside"
@information = lakeside.product
end
if @submission == "littlegiant"
@information = littlegiant.product
end
if @submission == "spanco"
@information = spanco.product
end
if @submission == "jet"
@information = jet.product
end
if @submission == "hillmanrollers"
@information = hillmanrollers.product
end
if @submission == "newlondon"
@information = newlondon.product
end
if @submission == "rollaway"
@information = rollaway.product
end
if @submission == "borroughs"
@information = borroughs.product
end
if @submission == "illinoisengineered"
@information = illinoisengineered.product
end
if @submission == "interthor"
@information = interthor.product
end
if @submission == "topperindustrial"
@information = topperindustrial.product
end
if @submission == "mfg"
@information = mfg.product
end
if @submission == "meese"
@information = meese.product
end
if @submission == "bayhead"
@information = bayhead.product
end
if @submission == "autoquip"
@information = autoquip.product
end
if @submission == "raymond"
@information = raymond.product
end
if @submission == "mallard"
@information = mallard.product
end
if @submission == "huskyrack"
@information = huskyrack.product
end
if @submission == "quikpik"
@information = quikpik.product
end
if @submission == "rivetier"
@information = rivetier.product
end
if @submission == "luxor"
@information = luxor.product
end
if @submission == "copperloy"
@information = copperloy.product
end
if @submission == "fairbanks"
@information = fairbanks.product
end
if @submission == "akromills"
@information = akromills.product
end
if @submission == "coxreels"
@information = coxreels.product
end
if @submission == "pucel"
@information = pucel.product
end
if @submission == "nashville"
@information = nashville.product
end
if @submission == "hwilson"
@information = hwilson.product
end
if @submission == "wisconsin"
@information = wisconsin.product
end
if @submission == "bevco"
@information = bevco.product
end
if @submission == "mobile"
@information = mobile.product
end
if @submission == "rousseau"
@information = rousseau.product
end
if @submission == "pollard"
@information = pollard.product
end
if @submission == "safco"
@information = safco.product
end
if @submission == "midstates"
@information = midstates.product
end
if @submission == "singerssafety"
@information = singerssafety.product
end
if @submission == "goff"
@information = goff.product
end
if @submission == "triton"
@information = triton.product
end
if @submission == "thern"
@information = thern.product
end
if @submission == "budgit"
@information = budgit.product
end
if @submission == "coffing"
@information = coffing.product
end
if @submission == "cm"
@information = cm.product
end
if @submission == "omtec"
@information = omtec.product
end
if @submission == "ezlift"
@information = ezlift.product
end
if @submission == "tractek"
@information = tractek.product
end
if @submission == "bradleycorp"
@information = bradleycorp.product
end
if @submission == "cotterman"
@information = cotterman.product
end
if @submission == "hallowell"
@information = hallowell.product
end
if @submission == "louisvilleladder"
@information = louisvilleladder.product
end
if @submission == "nutting"
@information = nutting.product
end
if @submission == "sandusky"
@information = sandusky.product
end
if @submission == "carefreetire"
@information = carefreetire.product
end

	erb :products
end

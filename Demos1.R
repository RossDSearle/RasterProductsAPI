library(jsonlite)
library()

fromJSON('http://127.0.0.1:6954/ProductInfo')
fromJSON('http://127.0.0.1:6954/ProductInfo?product=EEOWindspeed')

fromJSON('http://127.0.0.1:6954/Drill?longitude=140&latitude=-26&attribute=Clay%20Content&component=Value&verbose=F&usr=demo.user@somewhere.au&key=fjhf567sgq')


fromJSON("http://127.0.0.1:6954/Register?firstname=Ross&lastname=Searle&email=ross.searle%40gmail.com&organisation=CSIRO")


key = 'fjhf567sgq'
usr = 'demo.user@somewhere.au'

# Get all the product info
fromJSON("https://esoil.io/TERNLandscapes/RasterProductsAPI/ProductInfo")

# Get the product info with various filters applied
fromJSON("https://esoil.io/TERNLandscapes/RasterProductsAPI/ProductInfo?product=EEOWindspeed")
fromJSON("https://esoil.io/TERNLandscapes/RasterProductsAPI/ProductInfo?product=SLGA")
fromJSON("https://esoil.io/TERNLandscapes/RasterProductsAPI/ProductInfo?datatype=Soil")

# Get some data at a location. Notice you need to be registered to get the data. I have created a temporary Demo one for now

# Drill the 30m DEM at a given location
fromJSON(URLencode('https://esoil.io/TERNLandscapes/RasterProductsAPI/Drill?longitude=140&latitude=-26&product=30m_Covariate&name=Relief_dem1sv1_0&verbose=F&usr=demo.user@somewhere.au&key=fjhf567sgq'))

# Drill the SLGA 30m relief product at a given location
fromJSON(URLencode('https://esoil.io/TERNLandscapes/RasterProductsAPI/Drill?longitude=140&latitude=-26&product=30m_Covariate&attribute=Relief&verbose=F&usr=demo.user@somewhere.au&key=fjhf567sgq'))

# Drill the Annual Wind Speed product
fromJSON(URLencode('https://esoil.io/TERNLandscapes/RasterProductsAPI/Drill?longitude=140&latitude=-26&product=EEOWindspeed&name=Near-Surface Wind Speed v10 - Annual&verbose=F&usr=demo.user@somewhere.au&key=fjhf567sgq'))

# Drill all Wind Speed products
fromJSON(URLencode('https://esoil.io/TERNLandscapes/RasterProductsAPI/Drill?longitude=140&latitude=-26&product=EEOWindspeed&name=Near-Surface Wind Speed v10 - Annual&verbose=F&usr=demo.user@somewhere.au&key=fjhf567sgq'))

# Drill all depths of SLGA Clay Content products
fromJSON(URLencode('https://esoil.io/TERNLandscapes/RasterProductsAPI/Drill?longitude=140&latitude=-26&attribute=Clay Content&component=Value&verbose=F&usr=demo.user@somewhere.au&key=fjhf567sgq'))



###  If you are keen you can create your own registration key - use your own details
fromJSON(URLencode('https://esoil.io/TERNLandscapes/RasterProductsAPI/Register?firstname=Bob&lastname=Smith&email=bob.smith@gmail.com&organisation=SomethingInc'))

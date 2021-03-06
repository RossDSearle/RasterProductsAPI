library(RSQLite)

source('C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/TernLandscapes/APIs/RasterProductsAPI/config.R')
#source('/srv/plumber/TERNLandscapes/RasterProductsAPI/config.R')


rpdb <- 'C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/TernLandscapes/APIs/RasterProductsAPI/DB/RasterProducts.db'
d <- read.csv('C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/SLGAapi/RasterProductDB.csv', stringsAsFactors = F)


conn <- DBI::dbConnect(RSQLite::SQLite(), rpdb)
#dbWriteTable(conn, 'products', d )


sql <- "Select * from Products where DataType = 'Soil'"

res <- dbSendQuery(conn, sql)
dbFetch(res)


q_params <- list('SoilData', "SLGA or DataType = 'Climatology'")
q_params <- list('SoilData', "SLGA")
q_params <- list('SoilData', "SLGA;Delete from products")
sql <- "Select * from Products where DataType = ? and Source = ? "

res <- dbSendQuery(conn, sql, params = q_params)
dbFetch(res)


Products <- getProducts(Product='SLGA', DataType='Soil', Source='TERN',	Attribute='Avalaible Water Capacity',	Component='EV')
colnames(Products)
getProducts2(Component='EV')
getProducts2(Component='EV',	Attribute='Avalaible Water Capacity')
getProducts2(Attribute='Clay Content')

lon = 140
lat = -25

getDrillData(Product='SLGA', DataType='Soil', Source='TERN',	Attribute='Avalaible Water Capacity',	Component='Value', Longitude = 140, Latitude = -26, Verbose = F)

getDrillData(Product='SLGA', 	Attribute='Avalaible Water Capacity',	Component='EV', Longitude = lon, Latitude = lat, Verbose = T)
getDrillData(Product='SLGA', 	Attribute='Clay Content', Longitude = lon, Latitude = lat, Verbose = F)

getDrillData(Product='SLGA', Component='EV', Longitude = lon, Latitude = lat, Verbose = F)


getDrillData(Product='EEOWindspeed', Component='Monthly', Longitude = lon, Latitude = lat, Verbose = F)

getDrillData(Product='90m_Covariate', Attribute='Soil', Longitude = lon, Latitude = lat, Verbose = F, Usr= 'demo.user@somewhere.au' , Key='fjhf567sgq')
getDrillData(Attribute='Soil', Longitude = lon, Latitude = lat, Verbose = F, Usr= 'demo.user@somewhere.au' , Key='fjhf567sgq')

getDrillData(Attribute='Soil', Longitude = 4, Latitude = lat, Verbose = F, Usr= 'demo.user@somewhere.au' , Key='fjhf567sgq')

getDrillData(Longitude = lon, Latitude = lat, Product = 'EEOWindspeed', Name='Near-Surface Wind Speed v10 - Annual',  Verbose = F, Usr= 'demo.user@somewhere.au' , Key='fjhf567sgq')


Product=NULL; DataType=NULL; Source=NULL;	Attribute=NULL;	Component=NULL; Name=NULL;
df <- getMetaData()
colnames(df)


AuthenticateAPIKey(usr = 'ross.searle@csiro.au', key = '1ndw8K91CBFcYzh5Phvv')



registerDB(FirstName='Ross', LastName='Searle',	Email='ross.searle@gmail.com',	Organisation='CSIRO')

longitude=140; latitude=-28; product=NULL; datatype=NULL; source=NULL;	attribute=NULL;	component=NULL; name='Near-Surface Wind Speed v10 - Annual'; usr='demo.user@somewhere.au'; key='fjhf567sgq'; format='json'

fromJSON(URLencode('http://127.0.0.1:6954/Drill?longitude=140&latitude=-26&product=EEOWindspeed&name=Near-Surface Wind Speed v10 - Annual&verbose=F&usr=demo.user@somewhere.au&key=fjhf567sgq'))

fromJSON(URLencode('http://127.0.0.1:6954/Drill?longitude=140&latitude=-26&attribute=Clay Content&component=Value&verbose=F&usr=demo.user@somewhere.au&key=fjhf567sgq'))



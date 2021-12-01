library(RSQLite)

#source('C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/TernLandscapes/APIs/RasterProductsAPI/config.R')
source('/srv/plumber/TERNLandscapes/RasterProductsAPI/config.R')


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
getProducts2(Component='EV')
getProducts2(Component='EV',	Attribute='Avalaible Water Capacity')
getProducts2(Attribute='Clay Content')

lon = 140
lat = -25

getDrillData(Product='SLGA', DataType='Soil', Source='TERN',	Attribute='Avalaible Water Capacity',	Component='EV', Longitude = 140, Latitude = -26, Verbose = T)

getDrillData(Product='SLGA', 	Attribute='Avalaible Water Capacity',	Component='EV', Longitude = lon, Latitude = lat, Verbose = T)
getDrillData(Product='SLGA', 	Attribute='Clay Content', Longitude = lon, Latitude = lat, Verbose = F)

getDrillData(Product='SLGA', Component='EV', Longitude = lon, Latitude = lat, Verbose = F)










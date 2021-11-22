library(RSQLite)

rpdb <- 'C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/SLGAapi/RasterProducts.db'
d <- read.csv('C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/SLGAapi/RasterProductDB.csv', stringsAsFactors = F)


conn <- DBI::dbConnect(RSQLite::SQLite(), rpdb)
#dbWriteTable(conn, 'products', d )


sql <- "Select * from products where DataType = 'SoilData' "

res <- dbSendQuery(conn, sql)
dbFetch(res)


q_params <- list('SoilData', "SLGA or DataType = 'Climatology'")
q_params <- list('SoilData', "SLGA")
q_params <- list('SoilData', "SLGA;Delete from products")
sql <- "Select * from products where DataType = ? and Source = ? "

res <- dbSendQuery(conn, sql, params = q_params)
dbFetch(res)


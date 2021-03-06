library(RSQLite)
library(DBI)

doQuery <- function(sql, params){

  print(productsDB)

  conn <- DBI::dbConnect(RSQLite::SQLite(), productsDB)

  qry <- dbSendQuery(conn, sql)
  dbBind(qry, params)
  res <- dbFetch(qry)
  dbClearResult(qry)
  dbDisconnect(conn)
  return(res)
}

runSQL <- function(sql){

  print(productsDB)

  conn <- DBI::dbConnect(RSQLite::SQLite(), productsDB)

  qry <- dbSendQuery(conn, sql)
  res <- dbFetch(qry)
  dbClearResult(qry)
  dbDisconnect(conn)
  return(res)
}

##############   SLGA   ############

slgacodes <-  c("AWC" ,  "BDW"  ,  "CLY",  "DER" ,  "DES" ,  "ECE"  ,  "NTO",   "pHc",  "PTO" ,  "SLT" ,  "SND" ,  "SOC")
slganames <-  c("Avalaible Water Capacity",
                "Bulk Density - Whole Earth",
                "Clay Content",
                "Depth to Regolith",
                "Depth of Soil",
                "Effective Cation Exchange Capacity",
                "Total Nitrogen",
                "pH - Calcium Carbonate",
                "Total Phosphorous",
                "Silt Content",
                "Sand Content",
                "Soil Organic Carbon Content"
)
units <- c('%', 'g/cm3', '%', 'm', 'm', 'meq/100g', '%', 'None', '%', '%', '%', '%'  )
slgaDir <-  c("AWC", "Bulk-Density", "Clay", "Depth_of_Regolith", "Depth_of_Soil", "ECEC", "Total_N", "pHc","Total_P", "Silt", "Sand","SOC")

SLGAAttributes <- data.frame(code=slgacodes, Desc=slganames,DirNames=slgaDir, units)

slgaUpperDepths <- c('000', '005', '015', '030', '060', '100')
slgaLowerDepths <- c('005', '015', '030', '060', '100', '200')
slgaComponents <- c('05', 'EV','95')
slgaComponentsV <- c('Uncert_05', 'EV','Uncert_95')
slgaComponentsFulnames <- c('5th percentile uncertainty bound', 'Estimated value','95th percentile uncertainty bound')
slgaSuffix <- '_N_P_AU_NAT_C_20140801'


rootDir <- 'D:/TERNSoils/National_digital_soil_property_maps'

odf <- data.frame()
for(i in 1:nrow(SLGAAttributes)){

  rec <- SLGAAttributes[i,]
  for (j in 1:length(slgaComponents)) {
    for (k in 1:length(slgaUpperDepths)) {

      fname <- paste0(  rec$code, '_', slgaUpperDepths[k], '_', slgaLowerDepths[k], '_', slgaComponents[j], slgaSuffix, '.tif' )
      filePath <- paste0(rootDir,'/', rec$DirNames, '/', fname )
      webPath <- paste0('https://esoil.io/TERNLandscapes/Public/Products/TERN/SLGA/', rec$code, '/', fname)
      print(filePath)

      rdf <- data.frame( Product='SLGA',
                         DataType='Soil',
                         Source='TERN',
                         Attribute=rec$Desc,
                         Component=slgaComponentsV[j],
                         Name = paste0(slgaComponentsFulnames[j], ' of ', rec$Desc, ' for ', as.numeric(slgaUpperDepths[k])/100, ' to ', as.numeric(slgaLowerDepths[k])/100, ' metres' ),
                         Units = rec$units,
                         Description = paste0(slgaComponentsFulnames[j], ' of ', rec$Desc, ' for ', as.numeric(slgaUpperDepths[k])/100, ' to ', as.numeric(slgaLowerDepths[k])/100, ' metres' ),
                         UpperDepth_m = as.numeric(slgaUpperDepths[k])/100,
                         LowerDepth_m = as.numeric(slgaLowerDepths[k])/100,
                         Path=filePath,
                         COGsPath=webPath,
                         MetadataLink = 'https://www.clw.csiro.au/aclep/soilandlandscapegrid/index.html')

      odf <- rbind(odf, rdf)
    }
  }
}

write.csv(odf, 'C:/Projects/RasterProductsAPI/DataMassage/SLGARaw.csv', row.names = F)


productsDB <- 'C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/TernLandscapes/APIs/RasterProductsAPI/DB/RasterProducts.db'
conn <- DBI::dbConnect(RSQLite::SQLite(), productsDB)

DBI::dbWriteTable(conn, 'Products', odf)



###### Windspeed



sql <- "select * from Products"
df <- runSQL(sql)
DBI::dbWriteTable(conn, 'Products2', df)

ws <- read.csv('C:/Projects/RasterProductsAPI/DataMassage/Windspeed.csv', stringsAsFactors = F)
DBI::dbAppendTable(conn, 'Products', ws)



########  SLGA Covariates

sql <- "select * from Products"
df <- runSQL(sql)
DBI::dbWriteTable(conn, 'Products3', df)

covs <- read.csv('C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/TernLandscapes/APIs/RasterProductsAPI/DB/DataMassage/Covariates.csv', stringsAsFactors = F)
head(covs)

idxs <- which(covs$Resolution == '30m')
covs$COGsPath[idxs] <- paste0('https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/30m/', covs$Name[idxs], '.tif')

idxs <- which(covs$Resolution == '90m')
covs$COGsPath[idxs] <- paste0('https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90m/', covs$Name[idxs], '.tif')


covs$MetadataLink <- 'https://shiny.esoil.io/Covariates'
colnames(covs)[11] <- "UpperDepth_m"


DBI::dbAppendTable(conn, 'Products', covs)

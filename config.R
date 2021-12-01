
machineName <- as.character(Sys.info()['nodename'])
if(machineName=='soils-discovery'){

  logDir <- '/mnt/data/APILogs/SoilDataFederator/'
  productsDB <- '/srv/plumber/TERNLandscapes/RasterProductsAPI/DB/RasterProducts.db'

}else{
  SLGARoot <- paste0('D:/TERNSoils/National_digital_soil_property_maps')
  logDir <- 'c:/temp/Logs'
  productsDB <- 'C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/TernLandscapes/APIs/RasterProductsAPI/DB/RasterProducts.db'
}

source(paste0(deployDir, '/R/register.R'))
source(paste0(deployDir, '/R/dbMethods.R'))
source(paste0(deployDir, '/R/rasterMethods.R'))
source(paste0(deployDir, '/R/apiHelpers.R'))


adminPerson <- 'Ross Searle'
adminEmail <- 'ross.searle@csiro.au'


storeRoot='https://esoil.io/TERNLandscapes/Public/Products/TERN'
covariateRoot <- paste0(storeRoot, '/Covariates')

covMetaPath <- paste0(covariateRoot,'/Metadata/CovariateMetaData - 01-12-2020.csv')






machineName <- as.character(Sys.info()['nodename'])
if(machineName=='soils-discovery'){

  deployDir <- '/srv/plumber/TERNLandscapes/RasterProductsAPI'
  logDir <- '/mnt/data/APILogs/RasterProductsAPI/'
  productsDB <- '/srv/DB/RasterProductsAPI/RasterProducts.db'

}else{
  deployDir <- 'C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/TernLandscapes/APIs/RasterProductsAPI'
  logDir <- 'c:/temp/Logs'
  productsDB <- 'C:/Users/sea084/OneDrive - CSIRO/ProjectAdmin/DataBases/RasterProducts.db'
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







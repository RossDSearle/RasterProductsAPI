library(plumber)

machineName <- as.character(Sys.info()['nodename'])
if(machineName=='soils-discovery'){

  deployDir <-'/srv/plumber/TERNLandscapes/RasterProductsAPI'
  server <- '0.0.0.0'
  options("plumber.host" = 'esoil.io/TERNLandscapes/RasterProducts/')
  portNum <- 8079

}else{
  deployDir <-'C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/TernLandscapes/APIs/RasterProductsAPI'
  server <- '127.0.0.1'
  options("plumber.host" = "127.0.0.1:3077")
  options("plumber.apiHost" = "127.0.0.1:3077")
  portNum <- 3077
}

source(paste0(deployDir, '/R/dbMethods.R'))
source(paste0(deployDir, '/R/rasterMethods.R'))
source(paste0(deployDir, '/R/apiHelpers.R'))

#print(options())
r <- plumb(paste0(deployDir, "/WebAPI/apiEndPoints.R"))
print(r)
r$run(host= server, port=portNum, swagger=TRUE)





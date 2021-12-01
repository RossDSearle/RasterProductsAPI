library(terra)
library(raster)


drillRasters <- function(Products, Longitude, Latitude, Verbose=T){

  # xlon <- as.numeric(Longitude)
  # xlat <- as.numeric(Latitude)

  pt <- as.matrix(data.frame(x=c(Longitude), y=c(Latitude)))

  odf <- data.frame()

  fls <- list.files('/datasets/work/lw-soildatarepo/work/http/Products/TERN/SLGA/CLY', full.names = T)

  for (i in 1:nrow(Products)) {

     rec <- Products[i,]


      # p <- str_replace_all(rec$COGsPath, 'https://esoil.io/TERNLandscapes/Public/Products', '/datasets/work/lw-soildatarepo/work/http/Products')
      # r <- raster::raster(p)
      # val <- raster::extract(r, pt)
      # v = as.numeric(val)

     rl <- rast(paste0('/vsicurl/',rec$COGsPath))
     val <- terra::extract(rl, pt)
     v = as.numeric(val[1,1])

    if(Verbose){

      rdf <- data.frame(rec, Value= v )
      #colnames(rdf) <- c('Name', 'Value')
    }else{

      rdf <- data.frame(rec$Name, Value= v )
      colnames(rdf) <- c('Name', 'Value')
    }

    odf <- rbind(odf, rdf)
  }

  return(odf)
}






# drillSLGA <- function(){
#
#
#   odf <- data.frame(filename=character(), Val=numeric())
#   for (i in 1:nrow(SLGAAttributes)) {
#
#
#     rec <- SLGAAttributes[i,]
#
#     if(rec$code != 'DER' & rec$code != 'DES'){
#     #r <- rast('/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90m/Veg_LandCoverTrend_evi_mean.tif')
#     f<-paste0(SLGARoot, '/', SLGAAttributes$DirNames[i], '/',SLGAAttributes$code[i], '_000_005_EV_N_P_AU_NAT_C_20140801.tif')
#     r <- rast(f)
#     #pts <- as.matrix(data.frame(x=c(140, 143), y=c(-25, -30)))
#     pts <- as.matrix(data.frame(x=c(140), y=c(-25)))
#     vals <- extract(r, pts)
#
#     rdf <- data.frame(path=f, val=vals)
#     colnames(rdf) <- c('filename', 'Val')
#     odf <- rbind(odf, rdf)
#     }
#   }
#
# return(odf)
#
# }













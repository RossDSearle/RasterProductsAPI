library(terra)
library(raster)


drillRasters <- function(Products, Longitude, Latitude, Verbose=T){

  xlon <- as.numeric(Longitude)
  xlat <- as.numeric(Latitude)

  pt <- as.matrix(data.frame(x=c(xlon), y=c(xlat)))
  print(pt)
  odf <- data.frame()

  fls <- list.files('/datasets/work/lw-soildatarepo/work/http/Products/TERN/SLGA/CLY', full.names = T)

  for (i in 1:nrow(Products)) {

     rec <- Products[i,]
     print(rec)


     # p <- str_replace_all(rec$COGsPath, 'https://esoil.io/TERNLandscapes/Public/Products', '/datasets/work/lw-soildatarepo/work/http/Products')
     # r <- raster::raster(p)
     # print(r)
     # val <- raster::extract(r, pt)

       rl <- terra::rast('/datasets/work/lw-soildatarepo/work/http/Products/TERN/SLGA/CLY/CLY_100_200_EV_N_P_AU_NAT_C_20140801.tif')
       val <- terra::extract(rl, pt)

    print(val)

    if(Verbose){

      rdf <- data.frame(rec, Value=val)
    }else{

      rdf <- data.frame(rec$Name, Value=val[1,])
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













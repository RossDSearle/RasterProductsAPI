library(terra)



drillRasters <- function(Products, Longitude, Latitude, Verbose=T){

  pt <- as.matrix(data.frame(x=c(Longitude), y=c(Latitude)))
  print(pt)
  odf <- data.frame()


  for (i in 1:nrow(Products)) {

     rec <- Products[i,]
     print(rec)
     rl <- rast(paste0('/vsicurl/',rec$COGsPath))
     val <- terra::extract(rl, pt)

    print(val)

    if(Verbose){

      rdf <- data.frame(rec, Value=val[1,])
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













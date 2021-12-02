library(terra)
library(raster)
library(httr)

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

     #if(!http_error(rec$COGsPath)){

     rl <- rast(paste0('/vsicurl/',rec$COGsPath))
     val <- terra::extract(rl, pt)
     v = as.numeric(val[1,1])


    if(Verbose){

      rdf <- data.frame(rec, Value= v )
      #colnames(rdf) <- c('Name', 'Value')
    }else{

      rdf <- data.frame(rec$Product, rec$Name, Value= v, Units=rec$Units )
      colnames(rdf) <- c('Product', 'Name', 'Value', 'Units')
    }

    odf <- rbind(odf, rdf)

    # }else{
    #    print(paste0('URL does not exist - ', rec$COGsPath))
    # }
  }

  return(odf)
}




pointsInAustralia <- function(Lon, Lat){

  outdf <- if(Lon > 112.9211 &  Lon < 153.6386 &  Lat > -43.64309 &  Lat < -9.229727){
    return(T)
  }else{
    return(F)
  }

  # odf <- data.frame(Longitude=lon, Latitude=Lat)
  # pts <- st_as_sf(odf, coords = c("Longitude", "Latitude"), crs = 4326)
  # pt1 = st_sfc(st_point(c(Longitude,Latitude)))
  # sfPt = st_sf(geom = pt1)
  #
  # st_crs(pt1) = 4326
  #
  # da <- convertMetersToArcSecs(Latitude, Radius)
  #
  # buff <- st_buffer( pt1, da)
  # idxs <- which(lengths(st_within(pts, buff)) > 0)
  # op <- pts[idxs,]
}












library(stringr)
library(terra)



#To start in supervisorctl on esoil use this - "sudo supervisorctl -c /etc/supervisor/supervisord.conf start plumber_SoilFed"

machineName <- as.character(Sys.info()['nodename'])
if(machineName=='soils-discovery'){

  deployDir <-'/srv/plumber/TERNLandscapes/RasterProductsAPI'
  logDir <- '/mnt/data/APILogs/SLGAapi/'
}else{
  deployDir <<-'C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/TernLandscapes/APIs/RasterProductsAPI'
  logDir <- 'c:/temp/Logs'
}

source(paste0(deployDir, '/config.R'))



#* @apiTitle TERN Landscapes Raster Products API
#* @apiDescription Allows you to drill pixels of TERN Landscapes Raster Products and return values for a cell



#' Log system time, request method and HTTP user agent of the incoming request
#' @filter logger
function(req, res){

  logentry <- paste0(as.character(now()), ",",
       machineName, ",",
       req$REQUEST_METHOD, req$PATH_INFO, ",",
       str_replace_all( req$HTTP_USER_AGENT, ",", ""), ",",
       req$QUERY_STRING, ",",
       req$REMOTE_ADDR
      )

  dt <- format(Sys.time(), "%d-%m-%Y")

  if(!dir.exists(logDir)){
     dir.create(logDir , recursive = T)
    }

  logfile <- paste0(logDir, "/SoilFederationAPI_logs_", dt, ".csv")
  try(writeLogEntry(logfile, logentry), silent = TRUE)
  plumber::forward()
}


writeLogEntry <- function(logfile, logentry){

  if(file.exists(logfile)){
    cat(logentry, '\n', file=logfile, append=T)
  }else{
    hdr <- paste0('System_time,Server,Request_method,HTTP_user_agent,QUERY_STRING,REMOTE_ADDR\n')
    cat(hdr, file=logfile, append=F)
    cat(logentry, '\n', file=logfile, append=T)
  }
}


#* Register to use the API - Your API user name will be your email address and the the API key will be emailed to you
#* @param format (Optional) format of the response to return. Either json, csv, or xml. Default = json

#* @param organisation (Required) Your organisation name
#* @param email (Required) Your email address
#* @param lastname  (Required) Your surname
#* @param firstname (Required) Your first name
#*
#* @tag Raster Products
#* @get /Register
apiRegister <- function( req, res, firstname=NULL, lastname=NULL,	email=NULL,	organisation=NULL, usr=NULL, key=NULL, format='json'){
  tryCatch({

    rdf <- registerDB( FirstName=firstname, LastName=lastname,	Email=email,	Organisation=organisation)
    resp <- cerealize(rdf, label, format, res)
    return(resp)

  }, error = function(res)
  {
    print(geterrmessage())
    res$status <- 400
    list(error=jsonlite::unbox(geterrmessage()))
  })
}




#* Returns information about the DataSets available the Raster Products Store

#* @param key (Required)  API key for accessing the API.
#* @param usr (Required) User name for accessing the API. To register for an API key go to - https://shiny.esoil.io/SoilDataFederator/Register/
#* @param format (Optional) format of the response to return. Either json, csv, or xml. Default = json

#* @param product (Required)
#* @param component (Optional)
#* @param attribute (Optional)
#* @param source (Optional)
#* @param datatype (Optional)
#*
#* @tag Raster Products
#* @get /ProductInfo
apiGetProducts <- function( req, res, product=NULL, datatype=NULL, source=NULL,	attribute=NULL,	component=NULL, usr=NULL, key=NULL, format='json'){

  tryCatch({

    prodDF <- getProducts(Product=product, DataType=datatype, Source=source,	Attribute=attribute, Component=component)
    print(prodDF)

    #library(terra)
    # r <- rast('/vsicurl/https://esoil.io/TERNLandscapes/Public/Products/TERN/Covariates/Mosaics/90m/Veg_LandCoverTrend_evi_mean.tif')
    # pts <- as.matrix(data.frame(x=c(140, 143), y=c(-25, -30)))
    # vals <- extract(r, pts)

   # df <- data.frame(ID='Default', EstimateType="Modelled" )
   # vals <- drillSLGA()

    # df[1,1] <- 'test'
    # df[2,1] <- 'test2'
    # df[1,2] <- 'test3'
    #
    #
    # vals <- c(1,2,3,4,5,6)
    # vals2 <- c(10,20,30,40,50,6)
    # df2 <- data.frame(bob=vals, bob2=vals)
    # df[[2,2]] <- df2
    # df
    #
     label <- ''

    resp <- cerealize(prodDF, label, format, res)
    return(resp)

  }, error = function(res)
  {
    print(geterrmessage())
    res$status <- 400
    list(error=jsonlite::unbox(geterrmessage()))
  })
}




#* Returns data values at from a raster cell from the Raster Products Store

#* @param key (Optional)  API key for accessing the API.
#* @param usr (Optional) User name for accessing the API. To register for an API key go to - https://shiny.esoil.io/SoilDataFederator/Register/
#* @param format (Optional) format of the response to return. Either json, csv, or xml. Default = json

#* @param verbose
#* @param product
#* @param component
#* @param attribute
#* @param source
#* @param datatype
#* @param latitude
#* @param longitude
#*
#* @tag Raster Products
#* @get /Drill
apiDrillRasters <- function( req, res, longitude=NULL, latitude=NULL, product=NULL, datatype=NULL, source=NULL,	attribute=NULL,	component=NULL, usr=NULL, key=NULL, format='json', verbose=T){

  tryCatch({

    prodDF <- getDrillData(Longitude=as.numeric(longitude), Latitude=as.numeric(latitude), Product=product, DataType=datatype, Source=source,	Attribute=attribute, Component=component, Verbose=verbose)
    print(prodDF)

    label <- ''

    resp <- cerealize(prodDF, label, format, res)
    return(resp)

  }, error = function(res)
  {
    print(geterrmessage())
    res$status <- 400
    list(error=jsonlite::unbox(geterrmessage()))
  })
}


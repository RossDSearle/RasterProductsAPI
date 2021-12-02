library(RSQLite)
library(DBI)



doParamQuery <- function(sql, params){

  conn <- DBI::dbConnect(RSQLite::SQLite(), productsDB, flags=RSQLite::SQLITE_RO)
  qry <- dbSendQuery(conn, sql)
  dbBind(qry, params)
  res <- dbFetch(qry)
  dbClearResult(qry)
  dbDisconnect(conn)
  return(res)
}

doQuery <- function(sql){

  conn <- DBI::dbConnect(RSQLite::SQLite(), productsDB, flags=RSQLite::SQLITE_RO)
  qry <- dbSendQuery(conn, sql)
  res <- dbFetch(qry)
  dbClearResult(qry)
  dbDisconnect(conn)
  return(res)
}


getProducts<- function(Product=NULL, DataType=NULL, Source=NULL,	Attribute=NULL,	Component=NULL){

  #print(paste0('Product = ', Product))

  if(!is.null(Component)){

    q_params <- c(Product,DataType, Source,	Attribute,	Component)
    sql <- "Select * from Products where Product=? and DataType = ? and Source = ? and Attribute = ? and Component= ?"
  }else if(!is.null(Attribute)){
    q_params <- c(Product, DataType, Source,	Attribute)
    sql <- "Select * from Products where Product=? and DataType = ? and Source = ? and Attribute = ?"
  }else if(!is.null(Source)){
    q_params <- c(Product, DataType, Source)
    sql <- "Select * from Products where Product=? and DataType = ? and Source = ?"
  }else if(!is.null(DataType)){
    q_params <- c(Product,DataType)
    sql <- "Select * from Products where Product=? and DataType = ?"
  }else if(!is.null(Product)){
    q_params <- c(Product)
    sql <- "Select * from Products where Product=?"
  }else{
    stop("Please specifiy a data group at least to the 'Product' level")
  }

  prods = doParamQuery(sql = sql, params = q_params)
 return(prods)
}

getProducts2 <- function(Product=NULL, DataType=NULL, Source=NULL,	Attribute=NULL,	Component=NULL, Name=NULL){

  conds <- c()
  q_params <-c()

  # if(is.null(Product)){
  #     stop("Please specifiy a data group at least to the 'Product' level")
  # }

  if(!is.null(Component)){
    conds <- c(conds, paste0('Component= ?'))
    q_params <- c(q_params, Component)
  }
  if(!is.null(Attribute)){
    conds <- c(conds, paste0('Attribute= ?'))
    q_params <- c(q_params, Attribute)
  }
  if(!is.null(Source)){
    conds <- c(conds, paste0('Source= ?'))
    q_params <- c(q_params, Source)
  }
  if(!is.null(DataType)){
    conds <- c(conds, paste0('DataType= ?'))
    q_params <- c(q_params, DataType)
  }
  if(!is.null(Product)){
    conds <- c(conds, paste0('Product= ?'))
    q_params <- c(q_params, Product)
  }
  if(!is.null(Name)){
    conds <- c(conds, paste0('Name= ?'))
    q_params <- c(q_params, Name)
  }

  if(length(conds) == 0){

      sql <- paste0('Select * from Products')
      prods = doQuery(sql = sql)

  }else{

    sql <- paste0(sql, ' WHERE ', conds[1])
    if(length(conds) > 1){
      for (i in 2:length(conds)) {
        sql <- paste0(sql, ' and ', conds[i])
      }
    }
    prods = doParamQuery(sql = sql, params = q_params)
  }



  return(prods)
}


getDrillData <- function(Product=NULL, DataType=NULL, Source=NULL,	Attribute=NULL,	Component=NULL, Name=NULL, Longitude=NULL, Latitude=NULL, Verbose=T){

  # Authenticate auth  <- AuthenticateAPIKey(usr, key)
  if(!pointsInAustralia(Longitude, Latitude)){
    stop('The coordinates you supplied are not within Australia')
  }

  if(is.null(Product) & is.null(Product) & is.null(Product) & is.null(Product) & is.null(Product) & is.null(Product)){
    stop('Please specify a filter')
  }

 prods <- getProducts2(Product=Product, DataType=DataType, Source=Source,	Attribute=Attribute,	Component=Component, Name=Name)

 if(nrow(prods) == 0){
   stop('No datasets match the filter you specified')
 }

 odfr <- drillRasters(Products=prods, Longitude=Longitude, Latitude=Latitude, Verbose=Verbose)
 return(odfr)

}

getMetaData<- function(Product=NULL, DataType=NULL, Source=NULL, Attribute=NULL,	Component=NULL, Name=NULL){
  prods <- getProducts2(Product=Product, Source=Source,	Attribute=Attribute,	Component=Component, Name=Name)
  outDF <- prods #[, -c(11,12)]
  return(outDF)
}




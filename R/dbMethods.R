library(RSQLite)
library(DBI)



doQuery <- function(sql, params){

  conn <- DBI::dbConnect(RSQLite::SQLite(), productsDB, flags=RSQLite::SQLITE_RO)
  qry <- dbSendQuery(conn, sql)
  dbBind(qry, params)
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

  prods = doQuery(sql = sql, params = q_params)
 return(prods)
}

getProducts2 <- function(Product=NULL, DataType=NULL, Source=NULL,	Attribute=NULL,	Component=NULL){

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

  sql <- paste0('Select * from Products WHERE ', conds[1])

  if(length(conds)>1){
      for (i in 2:length(conds)) {
        sql <- paste0(sql, ' and ', conds[i])
      }
  }

  prods = doQuery(sql = sql, params = q_params)

  return(prods)
}


getDrillData <- function(Product=NULL, DataType=NULL, Source=NULL,	Attribute=NULL,	Component=NULL, Longitude=NULL, Latitude=NULL, Verbose=T){

 prods <- getProducts2(Product=Product, DataType=DataType, Source=Source,	Attribute=Attribute,	Component=Component)
 print(nrow(prods))
 odfr <- drillRasters(Products=prods, Longitude=Longitude, Latitude=Latitude, Verbose=Verbose)
 return(odfr)

}

getMetaData<- function(Product=NULL, DataType=NULL, Source=NULL, Attribute=NULL,	Component=NULL){

  prods <- getProducts2(Product, Source,	Attribute,	Component)
  outDF <- prods[, -c(11,12)]
}


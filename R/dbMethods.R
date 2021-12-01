library(RSQLite)
library(DBI)



doQuery <- function(sql, params){

  print(productsDB)

  conn <- DBI::dbConnect(RSQLite::SQLite(), productsDB)

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

    q_params <- list(Product,DataType, Source,	Attribute,	Component)
    sql <- "Select * from products where Product=? and DataType = ? and Source = ? and Attribute = ? and Component= ?"
  }else if(!is.null(Attribute)){
    q_params <- list(Product, DataType, Source,	Attribute)
    sql <- "Select * from products where Product=? and DataType = ? and Source = ? and Attribute = ?"
  }else if(!is.null(Source)){
    q_params <- list(Product, DataType, Source)
    sql <- "Select * from products where Product=? and DataType = ? and Source = ?"
  }else if(!is.null(DataType)){
    q_params <- list(Product,DataType)
    sql <- "Select * from products where Product=? and DataType = ?"
  }else if(!is.null(Product)){
    q_params <- list(Product)
    sql <- "Select * from products where Product=?"
  }else{
    stop("Please specifiy a data group at least to the 'Product' level")
  }

  prods = doQuery(sql = sql, params = q_params)


 return(prods)
}




getDrillData <- function(Product=NULL, DataType=NULL, Source=NULL,	Attribute=NULL,	Component=NULL){

 prods <- getProducts(Product, Source,	Attribute,	Component)

}

getMetaData<- function(Product=NULL, DataType=NULL, Source=NULL,	Attribute=NULL,	Component=NULL){

  prods <- getProducts(Product, Source,	Attribute,	Component)

  outDF <- prods[, -c(11,12)]

}


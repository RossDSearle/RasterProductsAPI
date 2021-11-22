library(RSQLite)
library(DBI)



doQuery <- function(sql, params){

  conn <- DBI::dbConnect(RSQLite::SQLite(), productsDB)

  qry <- dbSendQuery(conn, sql)
  dbBind(qry, params)
  res <- dbFetch(qry)
  dbClearResult(qry)
  dbDisconnect(conn)
  return(res)
}

getProducts<- function(Product=NULL, Source=NULL,	Attribute=NULL,	Component=NULL){

  print(paste0('Product = ', Product))

  if(!is.null(Component)){

    q_params <- list(Product, Source,	Attribute,	Component)
    sql <- "Select * from products where Product = ? and Source = ? and Attribute = ? and Component= ?"
  }else if(!is.null(Attribute)){
    q_params <- list(Product, Source,	Attribute)
    sql <- "Select * from products where Product = ? and Source = ? and Attribute = ?"
  }else if(!is.null(Source)){
    q_params <- list(Product, Source)
    sql <- "Select * from products where Product = ? and Source = ?"
  }else if(!is.null(Product)){
    q_params <- list(Product)
    sql <- "Select * from products where DataType = ?"
  }else{
    stop("Please specifiy a data group at least to the 'Product' level")
  }

  prods = doQuery(sql = sql, params = q_params)

 return(prods)
}




getDrillData <- function(Product=NULL, Source=NULL,	Attribute=NULL,	Component=NULL){

 prods <- getProducts(Product, Source,	Attribute,	Component)

}

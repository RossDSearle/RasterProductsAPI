library(RSQLite)
library(DBI)

getProducts<- function(Product=NULL, Source=NULL,	Attribute=NULL,	Component=NULL){

  conn <- DBI::dbConnect(RSQLite::SQLite(), productsDB)
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
    sql <- "Select * from products where Product = ?"
  }else{
    stop("Please specifiy a data group at least to the 'Product' level")
  }
  res <- dbSendQuery(conn, sql, params = q_params)
 prods <- dbFetch(res)


 DBI::dbDisconnect(conn)

 return(prods)
}




getDrillData <- function(Product=NULL, Source=NULL,	Attribute=NULL,	Component=NULL){

  conn <- DBI::dbConnect(RSQLite::SQLite(), rpdb)

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
    stop("Please specifiy a data group at least to the 'Product' level")
  }
    res <- dbSendQuery(conn, sql, params = q_params)
    dbFetch(res)
  }



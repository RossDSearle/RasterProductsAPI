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

# FirstName='Ross'
# LastName='Searle'
# Email='ross.searle@gmail.com'
# Organisation='CSIRO'
#
# registerDB(FirstName=FirstName, LastName=LastName,	Email=Email,	Organisation=Organisation)

registerDB <- function(FirstName=NULL, LastName=NULL,	Email=NULL,	Organisation=NULL){

  if(!isValidString(FirstName)){
    stop('Please provide a valid first name')
  }
  if(!isValidString(LastName)){
    stop('Please provide a valid last name')
  }
  if(!isValidString(Email)){
    stop('Please provide a valid email address')
  }
  if(!isValidString(Organisation)){
    stop('Please provide a valid organisation name')
  }

  if(!isValidEmail(Email)){
    stop('Please provide a valid email address')
  }

  q_params <- list(Email)
  sqlQry <- paste0("Select * from AuthUsers where usrID = ?")
  print(sqlQry)
  user <- doQuery(sqlQry, q_params)

  if(nrow(user) == 0 ){

    apiKey <- makeRandomString(1)
    sqlInsert <- paste0("Insert into AuthUsers (usrID, FirstName, Surname, Organisation, Key) VALUES(?, ?, ?, ?, ?)")
    q_params <- list(Email,FirstName, LastName, Organisation, apiKey)

    if(updateKey(sqlInsert, q_params)){
      msg <- paste0("Thanks for registering with the TERN Raster Products Web API. We just sent you an email containing the API key to use with the API. Please keep this somewhere safe.")
      emailInfo <- paste0('echo "<p> Dear ', FirstName, ',</p><p><br></p><p>Thanks for registering with the TERN Raster Products. </P><P>Your API key is - <span style=color:#FF0000;font-weight:bold;>',  apiKey,'</span></p><p><br></p><p>Regards</p><p>The TERN Landscape Team" | mail -s "$(echo "TERN Raster Products API Key Confirmation\nContent-Type: text/html")" ', Email,' -r no-reply@soils-discovery.csiro.au')
      system(emailInfo)
    }else{
      msg <- paste0("Oh Dear.... Something went wrong but I don't really know what!")
    }
  }else{
    msg <- paste0("User Exists " , Email, ".</P><P> Please contact ross.searle@csiro.au to sort this out.</P><P> Did you click on the link in the email we sent you?<P>")
  }


}



makeRandomString <- function(n=1)
{
  lenght = sample(c(10:20))
  randomString <- c(1:n)
  for (i in 1:n)
  {
    randomString[i] <- paste(sample(c(0:9, letters, LETTERS),lenght, replace=TRUE),collapse="")
  }
  return(randomString)
}

isValidEmail <- function(x) {
  grepl("\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>", as.character(x), ignore.case=TRUE)
}

isValidString <- function(x) {
  return(!(is.na(x) || x == '' || is.null(x)))
}





# confirmUser <- function(email, firstName, lastName, organisation, tKey){
#
#   sqlQry <- paste0("Select * from AuthUsers where usrID = '", email, "' and Pwd = '", tKey, "';")
#   print(sqlQry)
#   user <- doQueryFromFed(sqlQry)
#
#
#   if(nrow(user) > 0 ){
#
#     apiKey <- makeRandomString(1)
#     sqlInsert <- paste0("Update AuthUsers SET Pwd = '", apiKey, "' where usrID = '", email, "' and Pwd = '", tKey, "';")
#
#
#     if(updateKey(sqlInsert)){
#       msg <- paste0("<P>Thanks for registering with the SoilDataFederator Web API</P><P>Your SoilDataFederator API Key is - <span style='color:#FF0000; font-weight:bold;'>", apiKey, "</span></P><P>We just sent you an email containing the API key for your records. Please keep this somewhere safe.</P>")
#       emailInfo <- paste0('echo "<p> Dear ', firstName, ',</p><p><br></p><p>Thanks for registering with the TERN SoilDataFederator. </P><P>Your API key is - <span style=color:#FF0000;font-weight:bold;>',  apiKey,'</span></p><p><br></p><p>Regards</p><p>The TERN SoilDataFederator" | mail -s "$(echo "SoilDataFederator API Key Confirmation\nContent-Type: text/html")" ', email,' -r no-reply@soils-discovery.csiro.au')
#       system(emailInfo)
#     }else{
#       msg <- paste0("Oh Dear.... Something went wrong but I don't really know what!")
#     }
#   }else{
#     msg <- paste0("<P>Thanks for trying to register with the SoilDataFederator Web API, but unfortunatley we could not confirm the registration for " , email, ".</P><P> Please contact ross.searle@csiro.au to sort this out.</P><P> Did you click on the link in the email we sent you?<P>")
#   }
#
#   return(msg)
# }

updateKey <- function(sqlInsert, q_params){
  result <- tryCatch({

    authcon <- dbConnect(RSQLite::SQLite(), productsDB, flags = SQLITE_RW)
    rs <- dbSendStatement(authcon,sqlInsert)
    dbBind(rs, q_params)
    nr <- dbGetRowsAffected(rs)
    print(nr)
    dbDisconnect(authcon)
    return(T)

  }, error = function(err) {
    print(err)
    return(F)
  })
}

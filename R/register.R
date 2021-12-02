


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
  user <- doParamQuery(sqlQry, q_params)

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
    msg <- paste0("User Exists - " , Email, ". Please contact ross.searle@csiro.au to sort this out.")
  }

  return(msg)

}


AuthenticateAPIKey <- function(usr, key){

  sql <- 'Select * from AuthUsers WHERE UsrID = ? and key=?'
  ps <- c(usr, key)
  res <- doParamQuery(sql, ps)

  if(nrow(res) == 1){
    return(T)
  }else{
    return(F)
  }

}


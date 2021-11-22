
df <- data.frame()
df[1,1] <- 'test'
df[2,1] <- 'test2'
df[1,2] <- 'test3'


vals <- c(1,2,3,4,5,6)
vals2 <- c(10,20,30,40,50,6)
df2 <- data.frame(bob=vals, bob2=vals)
df[[2,2]] <- as.data.frame(df2)
df

label <- 'DataSets'
resp <- cerealize(df, label, format, res)

library(jsonlite)
x <- toJSON(df)
cat(x)


fromJSON(x)

sadf <- data.frame(SoilAttributes=data.frame())


df <- data.frame(ID='Default', EstimateType="Modelled", SoilAttributes='1')
df[[1,3]] <- df2

j <- toJSON(df)
fromJSON(j)



d1 <- data.frame(i=1:5, m=I(vector(mode="list", length=5)))
d1[[2, "m"]] <- matrix(rnorm(9), 3, 3)
d1[[3, "m"]] <- df2
d1

j <- toJSON(d1)
fromJSON(j)



df <- fromJSON('https://www.asris.csiro.au/ASRISApi/api/SLGA/simple/Drill?longitude=147&latitude=-29.5&layers=ALL&kernal=0&json=true')

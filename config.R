
machineName <- as.character(Sys.info()['nodename'])
if(machineName=='soils-discovery'){

  logDir <- '/mnt/data/APILogs/SoilDataFederator/'
  productsDB <- '/srv/plumber/TERNLandscapes/RasterProductsAPI/DB/RasterProducts.db'

}else{
  SLGARoot <- paste0('D:/TERNSoils/National_digital_soil_property_maps')
  logDir <- 'c:/temp/Logs'
  productsDB <- 'C:/Users/sea084/OneDrive - CSIRO/RossRCode/Git/TernLandscapes/APIs/RasterProductsAPI/DB/RasterProducts.db'
}

storeRoot='https://esoil.io/TERNLandscapes/Public/Products/TERN'
covariateRoot <- paste0(storeRoot, '/Covariates')

covMetaPath <- paste0(covariateRoot,'/Metadata/CovariateMetaData - 01-12-2020.csv')

slgacodes <-  c("AWC" ,  "BDW"  ,  "CLY",  "DER" ,  "DES" ,  "ECE"  ,  "NTO",   "pHc",  "PTO" ,  "SLT" ,  "SND" ,  "SOC")
slganames <-  c("Avaliable Water Capacity (%)",
                "Bulk Density - Whole Earth (g/cm3)",
                "Clay Content (%)",
                "Depth to Regolith (m)",
                "Depth of Soil (m)",
                "Effective Cation Exchange Capacity (meq/100g)",
                "Total Nitrogen (%)",
                "pH - Calcium Carbonate",
                "Total Phosphorous (%)",
                "Silt Content (%)",
                "Sand Content (%)",
                "Soil Organic Carbon Conetent (%)"
)
slgaDir <-  c("AWC", "Bulk-Density", "Clay", "Depth_of_Regolith", "Depth_of_Soil", "ECEC", "Total_N", "pHc","Total_P", "Silt", "Sand","SOC")

SLGAAttributes <- data.frame(code=slgacodes, Desc=slganames,DirNames=slgaDir)


slgaUpperDepths <- c('000', '005', '015', '030', '060', '100')
slgaLowerDepths <- c('005', '015', '030', '060', '100', '200')
slgaComponents <- c('05', 'EV','95')
slgaSuffix <- '_N_P_AU_NAT_C_20140801'


# TOP ####

require(lidR)
require(raster)
require(rasterVis)

plotcoords<-read.csv('data/Troendelag_20m_flater_pkt.csv',header=T,sep=';',dec=',')
plotcoords_telemark<-read.csv('data/Koordinater_20x20_Telemark.csv',header=T,sep=';',dec=',')
plotcoords_hedmark_akershus<-read.csv('data/Koordinater_20x20_Hedmark_Akershus.csv',header=T,sep=';',dec=',')

# NOTE: files are in data/clipped_las

# Import clipped files ----------------------------------------------------
#Trondelag
bratsberg_b       <- readLAS('data/clipped_las/bratsberg_b.las')
bratsberg_ub      <- readLAS('data/clipped_las/bratsberg_ub.las')
hi_tydal_b        <- readLAS('data/clipped_las/hi_tydal_b.las')
hi_tydal_ub       <- readLAS('data/clipped_las/hi_tydal_ub.las')
malvik_b          <- readLAS('data/clipped_las/malvik_b.las')
malvik_ub         <- readLAS('data/clipped_las/malvik_ub.las')
namdalseid_1kub_b <- readLAS('data/clipped_las/namdalseid_1kub_b.las')
namdalseid_1kub_ub<- readLAS('data/clipped_las/namdalseid_1kub_ub.las')
nsb_verdal_b      <- readLAS('data/clipped_las/nsb_verdal_b.las')
nsb_verdal_ub     <- readLAS('data/clipped_las/nsb_verdal_ub.las')
selbu_flub_b      <- readLAS('data/clipped_las/selbu_flub_b.las')
selbu_flub_ub     <- readLAS('data/clipped_las/selbu_flub_ub.las')
selbu_kl_b        <- readLAS('data/clipped_las/selbu_kl_b.las')
selbu_kl_ub       <- readLAS('data/clipped_las/selbu_kl_ub.las')
selbu_sl_b        <- readLAS('data/clipped_las/selbu_sl_b.las')
selbu_sl_ub       <- readLAS('data/clipped_las/selbu_sl_ub.las')
singsaas_b        <- readLAS('data/clipped_las/singsaas_b.las')
singsaas_ub       <- readLAS('data/clipped_las/singsaas_ub.las')
sl_tydal_b        <- readLAS('data/clipped_las/sl_tydal_b.las')
sl_tydal_ub       <- readLAS('data/clipped_las/sl_tydal_ub.las')
steinkjer_1BBb_b  <- readLAS('data/clipped_las/steinkjer_1BBb_b.las')
steinkjer_1BBb_ub <- readLAS('data/clipped_las/steinkjer_1BBb_ub.las')
steinkjer_2BBb_b  <- readLAS('data/clipped_las/steinkjer_2BBb_b.las')
steinkjer_2BBb_ub <- readLAS('data/clipped_las/steinkjer_2BBb_ub.las')
sub_namdalseid_b  <- readLAS('data/clipped_las/sub_namdalseid_b.las')
sub_namdalseid_ub <- readLAS('data/clipped_las/sub_namdalseid_ub.las')
verdal_1vb_b      <- readLAS('data/clipped_las/verdal_1vb_b.las')
verdal_1vb_ub     <- readLAS('data/clipped_las/verdal_1vb_ub.las')
verdal_2vb_b      <- readLAS('data/clipped_las/verdal_2vb_b.las')
verdal_2vb_ub     <- readLAS('data/clipped_las/verdal_2vb_ub.las')
#Telemark
drangedal1_b       <-readLAS('data/clipped_las/drangedal1_b.las')
drangedal1_ub      <-readLAS('data/clipped_las/drangedal1_ub.las')
drangedal3_b       <-readLAS('data/clipped_las/drangedal3_b.las')
drangedal3_ub      <-readLAS('data/clipped_las/drangedal3_ub.las')
drangedal4_b       <-readLAS('data/clipped_las/drangedal4_b.las')
drangedal4_ub      <-readLAS('data/clipped_las/drangedal4_ub.las')
fritsoe2_b         <-readLAS('data/clipped_las/fritsoe2_b.las')
fritsoe2_ub        <-readLAS('data/clipped_las/fritsoe2_ub.las')
fritsoe1_b         <-readLAS('data/clipped_las/fritsoe1_b.las')
fritsoe1_ub        <-readLAS('data/clipped_las/fritsoe1_ub.las')
fyresdal_b         <-readLAS('data/clipped_las/fyresdal_b.las')
fyresdal_ub        <-readLAS('data/clipped_las/fyresdal_ub.las')
kviteseid1_b       <-readLAS('data/clipped_las/kviteseid1_b.las')
kviteseid1_ub      <-readLAS('data/clipped_las/kviteseid1_ub.las')
kviteseid2_b       <-readLAS('data/clipped_las/kviteseid2_b.las')
kviteseid2_ub      <-readLAS('data/clipped_las/kviteseid2_ub.las')
kviteseid3_b       <-readLAS('data/clipped_las/kviteseid3_b.las')
kviteseid3_ub      <-readLAS('data/clipped_las/kviteseid3_ub.las')
n_cappelen1_b      <-readLAS('data/clipped_las/nome_cappelen_1_b.las')
n_cappelen1_ub     <-readLAS('data/clipped_las/nome_cappelen_1_ub.las')
n_cappelen2_b      <-readLAS('data/clipped_las/nome_cappelen_2_b.las')
n_cappelen2_ub     <-readLAS('data/clipped_las/nome_cappelen_2_ub.las')
notodden3_b        <-readLAS('data/clipped_las/notodden3_b.las')
notodden3_ub       <-readLAS('data/clipped_las/notodden3_ub.las')
notodden5_b        <-readLAS('data/clipped_las/notodden5_b.las')
notodden5_ub       <-readLAS('data/clipped_las/notodden5_ub.las')
notodden6_b        <-readLAS('data/clipped_las/notodden6_b.las')
notodden6_ub       <-readLAS('data/clipped_las/notodden6_ub.las')
#Hedmark and Akershus
didrik_holmsen_b   <-readLAS('data/clipped_las/didrik_holmsen_b.las')
didrik_holmsen_ub  <-readLAS('data/clipped_las/didrik_holmsen_ub.las')
eidskog_b          <-readLAS('data/clipped_las/eidskog_b.las')
eidskog_ub         <-readLAS('data/clipped_las/eidskog_ub.las')
fet3_b             <-readLAS('data/clipped_las/fet3_b.las')
fet3_ub            <-readLAS('data/clipped_las/fet3_ub.las')
h_pramhus_b        <-readLAS('data/clipped_las/halvard_pramhus_b.las')
h_pramhus_ub       <-readLAS('data/clipped_las/halvard_pramhus_ub.las')
stangesk_aurskog_b <-readLAS('data/clipped_las/stangeskovene_aurskog_b.las')
stangesk_aurskog_ub<-readLAS('data/clipped_las/stangeskovene_aurskog_ub.las')
stangesk_eidskog_b <-readLAS('data/clipped_las/stangeskovene_eidskog_b.las')
stangesk_eidskog_ub<-readLAS('data/clipped_las/stangeskovene_eidskog_ub.las')
stig_dahlen_b      <-readLAS('data/clipped_las/stig_dahlen_b.las')
stig_dahlen_ub     <-readLAS('data/clipped_las/stig_dahlen_ub.las')
truls_holm_b      <-readLAS('data/clipped_las/truls_holm_b.las')
truls_holm_ub     <-readLAS('data/clipped_las/truls_holm_ub.las')
sorem_b            <-readLAS('data/clipped_las/sorem_b.las')
sorem_ub            <-readLAS('data/clipped_las/sorem_ub.las')
nes1_b            <-readLAS('data/clipped_las/nes1_b.las')
nes1_ub            <-readLAS('data/clipped_las/nes1_ub.las')
nes2_b            <-readLAS('data/clipped_las/nes2_b.las')
nes2_ub            <-readLAS('data/clipped_las/nes2_ub.las')
kongsvinger1_b    <-readLAS('data/clipped_las/kongsvinger1_b.las')
kongsvinger1_ub    <-readLAS('data/clipped_las/kongsvinger1_ub.las')
kongsvinger2_b    <-readLAS('data/clipped_las/kongsvinger2_b.las')
kongsvinger2_ub    <-readLAS('data/clipped_las/kongsvinger2_ub.las')
maarud1_b    <-readLAS('data/clipped_las/maarud1_b.las')
maarud1_ub    <-readLAS('data/clipped_las/maarud1_ub.las')
maarud2_b    <-readLAS('data/clipped_las/maarud2_b.las')
maarud2_ub    <-readLAS('data/clipped_las/maarud2_ub.las')
maarud3_b    <-readLAS('data/clipped_las/maarud3_b.las')
maarud3_ub    <-readLAS('data/clipped_las/maarud3_ub.las')




# Threshold ---------------------------------------------------------------


threshold <-7





# Trøndelag ---------------------------------------------------------------
#Making canopy models in different colours for poster
require(rasterVis)
require(sp)
levelplot(canopy_diff_bratsberg_b,margin=F,scales=list(draw=F))
mytheme<-custom.theme(region=(height.colors(50)))
mytheme$panel.background$col='black'

bratsberg_b_pl <- Polygons(list(bratsberg_b_poly),1)
bratsberg_b_sp <- SpatialPolygons(list(bratsberg_b_pl))
bratsberg_ub_pl <- Polygons(list(bratsberg_ub_poly),1)
bratsberg_ub_sp <- SpatialPolygons(list(bratsberg_ub_pl))

detach(package:ggplot2)
levelplot(canopy_diff_bratsberg_b,par.settings=mytheme,margin=F,scales=list(draw=F))+
  layer(sp.polygons(bratsberg_b_sp))+
  layer(sp.polygons(treeout_bratsberg_b,col='white',lwd=2,lty=2))

levelplot(canopy_diff_bratsberg_ub,par.settings=mytheme,margin=F,scales=list(draw=F))+
  layer(sp.polygons(bratsberg_ub_sp))+
  layer(sp.polygons(treeout_bratsberg_ub,col='white',lwd=2,lty=2))

levelplot(canopy_diff_bratsberg_b_20x20,par.settings=mytheme,margin=F,scales=list(draw=F))+
  layer(sp.polygons(bratsberg_ub_sp))
  #layer(sp.polygons(treeout_bratsberg_ub,col='white',lwd=2,lty=2))

levelplot(canopy_diff_bratsberg_ub_20x20,par.settings=mytheme,margin=F,scales=list(draw=F))
  #layer(sp.polygons(bratsberg_ub_sp))
#layer(sp.polygons(treeout_bratsberg_ub,col='white',lwd=2,lty=2))

# Bratsberg ---------------------------------------------------------------
 
#Bratsberg_b
terrainmod_bratsberg_b  <-grid_terrain(bratsberg_b, method='knnidw',res=1)
canopymod_bratsberg_b   <-grid_canopy(bratsberg_b,res=1)


#Resample so that they have equal extent, and plot difference
terrainmod_bratsberg_b_resampled <-resample(as.raster(terrainmod_bratsberg_b), as.raster(canopymod_bratsberg_b), method='bilinear')
canopy_diff_bratsberg_b<-(as.raster(canopymod_bratsberg_b)-terrainmod_bratsberg_b_resampled)
plot(canopy_diff_bratsberg_b)

#Remove large trees, first detect and create treeID
trees_bratsberg_b<-tree_detection(bratsberg_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_bratsberg_b<-extract(canopy_diff_bratsberg_b,trees_bratsberg_b[,1:2])

lastrees_dalponte(bratsberg_b,canopy_diff_bratsberg_b,trees_bratsberg_b[treeheight_bratsberg_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

#Make hulls around the trees
treeout_bratsberg_b<-tree_hulls(bratsberg_b,type='convex',field='treeID')
plot(canopy_diff_bratsberg_b)
plot(treeout_bratsberg_b,add=T) 

bigtrees_bratsberg_b<-which(extract(canopy_diff_bratsberg_b,treeout_bratsberg_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

bratsberg_b_clip<-lasclip(bratsberg_b,treeout_bratsberg_b@polygons[[bigtrees_bratsberg_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_bratsberg_b)){
  print(i)
  bratsberg_b_clip<-lasclip(bratsberg_b_clip,treeout_bratsberg_b@polygons[[bigtrees_bratsberg_b[i]]]@Polygons[[1]],inside=F)}
plot(bratsberg_b_clip) #point cloud without large trees

canopy_diff_bratsberg_b_clip <- (as.raster(grid_canopy(bratsberg_b_clip,res=0.5))-(crop(as.raster(grid_terrain(bratsberg_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(bratsberg_b_clip,res=0.5)))))
plot(canopy_diff_bratsberg_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
bratsberg_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Brb',4:5]))
bratsberg_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Brb',4:5][bratsberg_b_order,]))
bratsberg_b_cut<-lasclip(bratsberg_b_clip,bratsberg_b_poly)
plot(bratsberg_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_bratsberg_b_20x20 <-grid_terrain(bratsberg_b_cut,method='knnidw',res=1)
canopymod_bratsberg_b_20x20  <-grid_canopy(bratsberg_b_cut,res=1)

terrainmod_bratsberg_b_resampeled_20x20 <- resample(as.raster(terrainmod_bratsberg_b_20x20), as.raster(canopymod_bratsberg_b_20x20, method='bilinear'))
canopy_diff_bratsberg_b_20x20 <- (as.raster(canopymod_bratsberg_b_20x20)-terrainmod_bratsberg_b_resampeled_20x20)
plot(canopy_diff_bratsberg_b_20x20)

writeRaster(canopy_diff_bratsberg_b_20x20,'Trondelag/canopy_height_clipped_raster/bratsberg_b_canopyheight', overwrite=TRUE)


 #Bratsberg_ub
terrainmod_bratsberg_ub <-grid_terrain(bratsberg_ub,method='knnidw',res=1)
canopymod_bratsberg_ub   <-grid_canopy(bratsberg_ub,res=1)

terrainmod_bratsberg_ub_resampeled <- resample(as.raster(terrainmod_bratsberg_ub), as.raster(canopymod_bratsberg_ub, method='bilinear'))
canopy_diff_bratsberg_ub <- (as.raster(canopymod_bratsberg_ub)-terrainmod_bratsberg_ub_resampeled)
plot(canopy_diff_bratsberg_ub)

#Remove large trees, first detect and create treeID
trees_bratsberg_ub<-tree_detection(bratsberg_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_bratsberg_ub<-extract(canopy_diff_bratsberg_ub,trees_bratsberg_ub[,1:2])

lastrees_dalponte(bratsberg_ub,canopy_diff_bratsberg_ub,trees_bratsberg_ub[treeheight_bratsberg_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

#Make hulls around the trees
treeout_bratsberg_ub<-tree_hulls(bratsberg_ub,type='convex',field='treeID')
plot(canopy_diff_bratsberg_ub)
plot(treeout_bratsberg_ub,add=T) 

bigtrees_bratsberg_ub<-which(extract(canopy_diff_bratsberg_ub,treeout_bratsberg_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

bratsberg_ub_clip<-lasclip(bratsberg_ub,treeout_bratsberg_ub@polygons[[bigtrees_bratsberg_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_bratsberg_ub)){
  print(i)
  bratsberg_ub_clip<-lasclip(bratsberg_ub_clip,treeout_bratsberg_ub@polygons[[bigtrees_bratsberg_ub[i]]]@Polygons[[1]],inside=F)}
plot(bratsberg_ub_clip) #point cloud without large trees

canopy_diff_bratsberg_ub_clip <- (as.raster(grid_canopy(bratsberg_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(bratsberg_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(bratsberg_ub_clip,res=0.5)))))
plot(canopy_diff_bratsberg_ub_clip)


#Cutting the 32x32m square(with big trees removed) to 20x20 m
bratsberg_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Brub',4:5]))
bratsberg_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Brub',4:5][bratsberg_ub_order,]))
bratsberg_ub_cut<-lasclip(bratsberg_ub_clip,bratsberg_ub_poly)
plot(bratsberg_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_bratsberg_ub_20x20 <-grid_terrain(bratsberg_ub_cut,method='knnidw',res=1)
canopymod_bratsberg_ub_20x20  <-grid_canopy(bratsberg_ub_cut,res=1)

terrainmod_bratsberg_ub_resampeled_20x20 <- resample(as.raster(terrainmod_bratsberg_ub_20x20), as.raster(canopymod_bratsberg_ub_20x20, method='bilinear'))
canopy_diff_bratsberg_ub_20x20 <- (as.raster(canopymod_bratsberg_ub_20x20)-terrainmod_bratsberg_ub_resampeled_20x20)
plot(canopy_diff_bratsberg_ub_20x20)

writeRaster(canopy_diff_bratsberg_ub_20x20,'Trondelag/canopy_height_clipped_raster/bratsberg_ub_canopyheight', overwrite=TRUE)


#testub <- raster('Trondelag/canopy_height_clipped_raster/bratsberg_ub_canopyheight')
#testb <- raster('Trondelag/canopy_height_clipped_raster/bratsberg_b_canopyheight')

#summary(testub)

#histub<-graphics::hist(getValues(testub),plot=F)
#plot(histub$mids,histub$density,type='l')

#dub<-density(testub)
#db<-density(testb)
#plot(dub)
#lines(db,add=T)


# Hi_tydal ----------------------------------------------------------------

#Hi_tydal_b
terrainmod_hi_tydal_b  <-grid_terrain(hi_tydal_b, method='knnidw',res=1)
canopymod_hi_tydal_b   <-grid_canopy(hi_tydal_b,res=1)

terrainmod_hi_tydal_b_resampled <-resample(as.raster(terrainmod_hi_tydal_b), as.raster(canopymod_hi_tydal_b), method='bilinear')
canopy_diff_hi_tydal_b<-(as.raster(canopymod_hi_tydal_b)-terrainmod_hi_tydal_b_resampled)
plot(canopy_diff_hi_tydal_b) #maximum value 4,082 
#Siden det ikke er noen trær på 7 m å fjerne, kjører jeg ikke trefjerningsalgoritmen på denne 32x32m flaten

#Cutting the 32x32m square to 20x20 m
hi_tydal_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Trondelag/Hi_tydal.las')
hi_tydal_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Hib',4:5]))
hi_tydal_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Hib',4:5][hi_tydal_b_order,]))
hi_tydal_b_cut<-lasclip(hi_tydal_las,hi_tydal_b_poly)
plot(hi_tydal_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_hi_tydal_b_20x20 <-grid_terrain(hi_tydal_b_cut,method='knnidw',res=1)
canopymod_hi_tydal_b_20x20  <-grid_canopy(hi_tydal_b_cut,res=1)

terrainmod_hi_tydal_b_resampeled_20x20 <- resample(as.raster(terrainmod_hi_tydal_b_20x20), as.raster(canopymod_hi_tydal_b_20x20, method='bilinear'))
canopy_diff_hi_tydal_b_20x20 <- (as.raster(canopymod_hi_tydal_b_20x20)-terrainmod_hi_tydal_b_resampeled_20x20)
plot(canopy_diff_hi_tydal_b_20x20)

writeRaster(canopy_diff_hi_tydal_b_20x20,'Trondelag/canopy_height_clipped_raster/hi_tydal_b_canopyheight', overwrite=TRUE)


#Hi_tydal_ub
terrainmod_hi_tydal_ub <-grid_terrain(hi_tydal_ub,method='knnidw',res=1)
canopymod_hi_tydal_ub  <-grid_canopy(hi_tydal_ub,res=1)

terrainmod_hi_tydal_ub_resampled <-resample(as.raster(terrainmod_hi_tydal_ub), as.raster(canopymod_hi_tydal_ub), method='bilinear')
canopy_diff_hi_tydal_ub<-(as.raster(canopymod_hi_tydal_ub)-terrainmod_hi_tydal_ub_resampled)
plot(canopy_diff_hi_tydal_ub)

trees_hi_tydal_ub<-tree_detection(hi_tydal_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_hi_tydal_ub<-extract(canopy_diff_hi_tydal_ub,trees_hi_tydal_ub[,1:2])

lastrees_dalponte(hi_tydal_ub,canopy_diff_hi_tydal_ub,trees_hi_tydal_ub[treeheight_hi_tydal_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_hi_tydal_ub<-tree_hulls(hi_tydal_ub,type='convex',field='treeID')
plot(canopy_diff_hi_tydal_ub)
plot(treeout_hi_tydal_ub,add=T) 

bigtrees_hi_tydal_ub<-which(extract(canopy_diff_hi_tydal_ub,treeout_hi_tydal_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

hi_tydal_ub_clip<-lasclip(hi_tydal_ub,treeout_hi_tydal_ub@polygons[[bigtrees_hi_tydal_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_hi_tydal_ub)){
  print(i)
  hi_tydal_ub_clip<-lasclip(hi_tydal_ub_clip,treeout_hi_tydal_ub@polygons[[bigtrees_hi_tydal_ub[i]]]@Polygons[[1]],inside=F)}
plot(hi_tydal_ub_clip) #point cloud without large trees

canopy_diff_hi_tydal_ub_clip <- (as.raster(grid_canopy(hi_tydal_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(hi_tydal_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(hi_tydal_ub_clip,res=0.5)))))
plot(canopy_diff_hi_tydal_ub_clip)

#Cutting the 32x32m square to 20x20 m
hi_tydal_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Hiub',4:5]))
hi_tydal_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Hiub',4:5][hi_tydal_ub_order,]))
hi_tydal_ub_cut<-lasclip(hi_tydal_ub_clip,hi_tydal_ub_poly)
plot(hi_tydal_ub_cut) #20x20 m area as point cloud

terrainmod_hi_tydal_ub_20x20 <-grid_terrain(hi_tydal_ub_cut,method='knnidw',res=1)
canopymod_hi_tydal_ub_20x20  <-grid_canopy(hi_tydal_ub_cut,res=1)

terrainmod_hi_tydal_ub_resampeled_20x20 <- resample(as.raster(terrainmod_hi_tydal_ub_20x20), as.raster(canopymod_hi_tydal_ub_20x20, method='bilinear'))
canopy_diff_hi_tydal_ub_20x20 <- (as.raster(canopymod_hi_tydal_ub_20x20)-terrainmod_hi_tydal_ub_resampeled_20x20)
plot(canopy_diff_hi_tydal_ub_20x20)

writeRaster(canopy_diff_hi_tydal_ub_20x20,'Trondelag/canopy_height_clipped_raster/hi_tydal_ub_canopyheight', overwrite=TRUE)


# Malvik ------------------------------------------------------------------

#Malvik_b

terrainmod_malvik_b  <-grid_terrain(malvik_b, method='knnidw',res=1)
canopymod_malvik_b   <-grid_canopy(malvik_b,res=1)

terrainmod_malvik_b_resampled <-resample(as.raster(terrainmod_malvik_b), as.raster(canopymod_malvik_b), method='bilinear')
canopy_diff_malvik_b<-(as.raster(canopymod_malvik_b)-terrainmod_malvik_b_resampled)
plot(canopy_diff_malvik_b)


#Remove large trees, first detect and create treeID
trees_malvik_b<-tree_detection(malvik_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_malvik_b<-extract(canopy_diff_malvik_b,trees_malvik_b[,1:2])

lastrees_dalponte(malvik_b,canopy_diff_malvik_b,trees_malvik_b[treeheight_malvik_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

#Make hulls around the trees
treeout_malvik_b<-tree_hulls(malvik_b,type='convex',field='treeID')
plot(canopy_diff_malvik_b)
plot(treeout_malvik_b,add=T) 

bigtrees_malvik_b<-which(extract(canopy_diff_malvik_b,treeout_malvik_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

malvik_b_clip<-lasclip(malvik_b,treeout_malvik_b@polygons[[bigtrees_malvik_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_malvik_b)){
  print(i)
  malvik_b_clip<-lasclip(malvik_b_clip,treeout_malvik_b@polygons[[bigtrees_malvik_b[i]]]@Polygons[[1]],inside=F)}
plot(malvik_b_clip) #point cloud without large trees

canopy_diff_malvik_b_clip <- (as.raster(grid_canopy(malvik_b_clip,res=0.5))-(crop(as.raster(grid_terrain(malvik_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(malvik_b_clip,res=0.5)))))
plot(canopy_diff_malvik_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
malvik_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Mab',4:5]))
malvik_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Mab',4:5][malvik_b_order,]))
malvik_b_cut<-lasclip(malvik_b_clip,malvik_b_poly)
plot(malvik_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_malvik_b_20x20 <-grid_terrain(malvik_b_cut,method='knnidw',res=1)
canopymod_malvik_b_20x20  <-grid_canopy(malvik_b_cut,res=1)

terrainmod_malvik_b_resampeled_20x20 <- resample(as.raster(terrainmod_malvik_b_20x20), as.raster(canopymod_malvik_b_20x20, method='bilinear'))
canopy_diff_malvik_b_20x20 <- (as.raster(canopymod_malvik_b_20x20)-terrainmod_malvik_b_resampeled_20x20)
plot(canopy_diff_malvik_b_20x20)

writeRaster(canopy_diff_malvik_b_20x20,'Trondelag/canopy_height_clipped_raster/malvik_b_canopyheight', overwrite=TRUE)



#Malvik_ub
terrainmod_malvik_ub <-grid_terrain(malvik_ub,method='knnidw',res=1)
canopymod_malvik_ub  <-grid_canopy(malvik_ub,res=1)

terrainmod_malvik_ub_resampeled <- resample(as.raster(terrainmod_malvik_ub), as.raster(canopymod_malvik_ub, method='bilinear'))
canopy_diff_malvik_ub <- (as.raster(canopymod_malvik_ub)-terrainmod_malvik_ub_resampeled)
plot(canopy_diff_malvik_ub)

canopy_diff_malvik_ub # no trees over 7 m

#Cutting the 32x32m square to 20x20 m
malvik_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Trondelag/Malvik.las')
malvik_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Maub',4:5]))
malvik_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Maub',4:5][malvik_ub_order,]))
malvik_ub_cut<-lasclip(malvik_las,malvik_ub_poly)
plot(malvik_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_malvik_ub_20x20 <-grid_terrain(malvik_ub_cut,method='knnidw',res=1)
canopymod_malvik_ub_20x20  <-grid_canopy(malvik_ub_cut,res=1)

terrainmod_malvik_ub_resampeled_20x20 <- resample(as.raster(terrainmod_malvik_ub_20x20), as.raster(canopymod_malvik_ub_20x20, method='bilinear'))
canopy_diff_malvik_ub_20x20 <- (as.raster(canopymod_malvik_ub_20x20)-terrainmod_malvik_ub_resampeled_20x20)
plot(canopy_diff_malvik_ub_20x20)

writeRaster(canopy_diff_malvik_ub_20x20,'Trondelag/canopy_height_clipped_raster/malvik_ub_canopyheight', overwrite=TRUE)



# Namdalseid_1kub ---------------------------------------------------------

# Namdalseid_1kub_b
terrainmod_namdalseid_1kub_b  <-grid_terrain(namdalseid_1kub_b, method='knnidw',res=1)
canopymod_namdalseid_1kub_b   <-grid_canopy(namdalseid_1kub_b,res=1)

terrainmod_namdalseid_1kub_b_resampled <-resample(as.raster(terrainmod_namdalseid_1kub_b), as.raster(canopymod_namdalseid_1kub_b), method='bilinear')
canopy_diff_namdalseid_1kub_b<-(as.raster(canopymod_namdalseid_1kub_b)-terrainmod_namdalseid_1kub_b_resampled)
plot(canopy_diff_namdalseid_1kub_b)

trees_namdalseid_1kub_b<-tree_detection(namdalseid_1kub_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_namdalseid_1kub_b<-extract(canopy_diff_namdalseid_1kub_b,trees_namdalseid_1kub_b[,1:2])

lastrees_dalponte(namdalseid_1kub_b,canopy_diff_namdalseid_1kub_b,trees_namdalseid_1kub_b[treeheight_namdalseid_1kub_b>=threshold,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_namdalseid_1kub_b<-tree_hulls(namdalseid_1kub_b,type='convex',field='treeID')
plot(canopy_diff_namdalseid_1kub_b)
plot(treeout_namdalseid_1kub_b,add=T) 

bigtrees_namdalseid_1kub_b<-which(extract(canopy_diff_namdalseid_1kub_b,treeout_namdalseid_1kub_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

namdalseid_1kub_b_clip<-lasclip(namdalseid_1kub_b,treeout_namdalseid_1kub_b@polygons[[bigtrees_namdalseid_1kub_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_namdalseid_1kub_b)){
  print(i)
  namdalseid_1kub_b_clip<-lasclip(namdalseid_1kub_b_clip,treeout_namdalseid_1kub_b@polygons[[bigtrees_namdalseid_1kub_b[i]]]@Polygons[[1]],inside=F)}
plot(namdalseid_1kub_b_clip) 

canopy_diff_namdalseid_1kub_b_clip <- (as.raster(grid_canopy(namdalseid_1kub_b_clip,res=0.5))-(crop(as.raster(grid_terrain(namdalseid_1kub_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(namdalseid_1kub_b_clip,res=0.5)))))
plot(canopy_diff_namdalseid_1kub_b_clip)

#Cutting it so it is 20x20 m

namdalseid_1kub_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='1Kb',4:5]))
namdalseid_1kub_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='1Kb',4:5][namdalseid_1kub_b_order,]))
namdalseid_1kub_b_cut<-lasclip(namdalseid_1kub_b_clip,namdalseid_1kub_b_poly)
plot(namdalseid_1kub_b_cut) #20x20 m area as point cloud

terrainmod_namdalseid_1kub_b_20x20 <-grid_terrain(namdalseid_1kub_b_cut,method='knnidw',res=1)
canopymod_namdalseid_1kub_b_20x20  <-grid_canopy(namdalseid_1kub_b_cut,res=1)

terrainmod_namdalseid_1kub_b_resampeled_20x20 <- resample(as.raster(terrainmod_namdalseid_1kub_b_20x20), as.raster(canopymod_namdalseid_1kub_b_20x20, method='bilinear'))
canopy_diff_namdalseid_1kub_b_20x20 <- (as.raster(canopymod_namdalseid_1kub_b_20x20)-terrainmod_namdalseid_1kub_b_resampeled_20x20)
plot(canopy_diff_namdalseid_1kub_b_20x20)

writeRaster(canopy_diff_namdalseid_1kub_b_20x20,'Trondelag/canopy_height_clipped_raster/namdalseid_1kub_b_canopyheight', overwrite=TRUE)



writeRaster(canopy_diff_namdalseid_1kub_b_clip,'Trondelag/canopy_height_clipped_raster/namdalseid_1kub_b_canopyheight')




# Namdalseid_1kub_ub
terrainmod_namdalseid_1kub_ub <-grid_terrain(namdalseid_1kub_ub,method='knnidw',res=1)
canopymod_namdalseid_1kub_ub  <-grid_canopy(namdalseid_1kub_ub,res=1)


terrainmod_namdalseid_1kub_ub_resampeled <- resample(as.raster(terrainmod_namdalseid_1kub_ub), as.raster(canopymod_namdalseid_1kub_ub, method='bilinear'))
canopy_diff_namdalseid_1kub_ub <- (as.raster(canopymod_namdalseid_1kub_ub)-terrainmod_namdalseid_1kub_ub_resampeled)
plot(canopy_diff_namdalseid_1kub_ub)

trees_namdalseid_1kub_ub<-tree_detection(namdalseid_1kub_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_namdalseid_1kub_ub<-extract(canopy_diff_namdalseid_1kub_ub,trees_namdalseid_1kub_ub[,1:2])

lastrees_dalponte(namdalseid_1kub_ub,canopy_diff_namdalseid_1kub_ub,trees_namdalseid_1kub_ub[treeheight_namdalseid_1kub_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_namdalseid_1kub_ub<-tree_hulls(namdalseid_1kub_ub,type='convex',field='treeID')
plot(canopy_diff_namdalseid_1kub_ub)
plot(treeout_namdalseid_1kub_ub,add=T) 

bigtrees_namdalseid_1kub_ub<-which(extract(canopy_diff_namdalseid_1kub_ub,treeout_namdalseid_1kub_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

namdalseid_1kub_ub_clip<-lasclip(namdalseid_1kub_ub,treeout_namdalseid_1kub_ub@polygons[[bigtrees_namdalseid_1kub_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_namdalseid_1kub_ub)){
  print(i)
  namdalseid_1kub_ub_clip<-lasclip(namdalseid_1kub_ub_clip,treeout_namdalseid_1kub_ub@polygons[[bigtrees_namdalseid_1kub_ub[i]]]@Polygons[[1]],inside=F)}
plot(namdalseid_1kub_ub_clip) #32x32 m area as point cloud

canopy_diff_namdalseid_1kub_ub_clip <- (as.raster(grid_canopy(namdalseid_1kub_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(namdalseid_1kub_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(namdalseid_1kub_ub_clip,res=0.5)))))
plot(canopy_diff_namdalseid_1kub_ub_clip)

#Cutting it so it is 20x20 m
#Importing the big LAS file
namdalseid_1kub_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Trondelag/namdalseid_1kub.las')
#Import coordinates
plotcoords<-read.csv('Troendelag_20m_flater_pkt.csv',header=T,sep=';',dec=',')

namdalseid_1kub_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='1Kub',4:5]))
namdalseid_1kub_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='1Kub',4:5][namdalseid_1kub_ub_order,]))
namdalseid_1kub_ub_cut<-lasclip(namdalseid_1kub_ub_clip,namdalseid_1kub_ub_poly)
plot(namdalseid_1kub_ub_cut) #20x20 m area as point cloud

terrainmod_namdalseid_1kub_ub_20x20 <-grid_terrain(namdalseid_1kub_ub_cut,method='knnidw',res=1)
canopymod_namdalseid_1kub_ub_20x20  <-grid_canopy(namdalseid_1kub_ub_cut,res=1)

terrainmod_namdalseid_1kub_ub_resampeled_20x20 <- resample(as.raster(terrainmod_namdalseid_1kub_ub_20x20), as.raster(canopymod_namdalseid_1kub_ub_20x20, method='bilinear'))
canopy_diff_namdalseid_1kub_ub_20x20 <- (as.raster(canopymod_namdalseid_1kub_ub_20x20)-terrainmod_namdalseid_1kub_ub_resampeled_20x20)
plot(canopy_diff_namdalseid_1kub_ub_20x20)

writeRaster(canopy_diff_namdalseid_1kub_ub_20x20,'Trondelag/canopy_height_clipped_raster/namdalseid_1kub_ub_canopyheight', overwrite=TRUE)




# Nsb_verdal --------------------------------------------------------------


# Nsb Verdal_b
terrainmod_nsb_verdal_b  <-grid_terrain(nsb_verdal_b, method='knnidw',res=1)
canopymod_nsb_verdal_b   <-grid_canopy(nsb_verdal_b,res=1)

terrainmod_nsb_verdal_b_resampled <-resample(as.raster(terrainmod_nsb_verdal_b), as.raster(canopymod_nsb_verdal_b), method='bilinear')
canopy_diff_nsb_verdal_b<-(as.raster(canopymod_nsb_verdal_b)-terrainmod_nsb_verdal_b_resampled)
plot(canopy_diff_nsb_verdal_b)
canopy_diff_nsb_verdal_b #max value 6

#Cutting the 32x32m square to 20x20 m
nsb_verdal_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Trondelag/Nsb_Verdal.las')
nsb_verdal_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='1Nsb',4:5]))
nsb_verdal_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='1Nsb',4:5][nsb_verdal_b_order,]))
nsb_verdal_b_cut<-lasclip(nsb_verdal_las,nsb_verdal_b_poly)
plot(nsb_verdal_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_nsb_verdal_b_20x20 <-grid_terrain(nsb_verdal_b_cut,method='knnidw',res=1)
canopymod_nsb_verdal_b_20x20  <-grid_canopy(nsb_verdal_b_cut,res=1)

terrainmod_nsb_verdal_b_resampeled_20x20 <- resample(as.raster(terrainmod_nsb_verdal_b_20x20), as.raster(canopymod_nsb_verdal_b_20x20, method='bilinear'))
canopy_diff_nsb_verdal_b_20x20 <- (as.raster(canopymod_nsb_verdal_b_20x20)-terrainmod_nsb_verdal_b_resampeled_20x20)
plot(canopy_diff_nsb_verdal_b_20x20)

writeRaster(canopy_diff_nsb_verdal_b_20x20,'Trondelag/canopy_height_clipped_raster/nsb_verdal_b_canopyheight', overwrite=TRUE)


# Nsb Verdal_ub
terrainmod_nsb_verdal_ub <-grid_terrain(nsb_verdal_ub,method='knnidw',res=1)
canopymod_nsb_verdal_ub  <-grid_canopy(nsb_verdal_ub,res=1)

terrainmod_nsb_verdal_ub_resampeled <- resample(as.raster(terrainmod_nsb_verdal_ub), as.raster(canopymod_nsb_verdal_ub, method='bilinear'))
canopy_diff_nsb_verdal_ub <- (as.raster(canopymod_nsb_verdal_ub)-terrainmod_nsb_verdal_ub_resampeled)
plot(canopy_diff_nsb_verdal_ub)

trees_nsb_verdal_ub<-tree_detection(nsb_verdal_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_nsb_verdal_ub<-extract(canopy_diff_nsb_verdal_ub,trees_nsb_verdal_ub[,1:2])

lastrees_dalponte(nsb_verdal_ub,canopy_diff_nsb_verdal_ub,trees_nsb_verdal_ub[treeheight_nsb_verdal_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_nsb_verdal_ub<-tree_hulls(nsb_verdal_ub,type='convex',field='treeID')
plot(canopy_diff_nsb_verdal_ub)
plot(treeout_nsb_verdal_ub,add=T) 

bigtrees_nsb_verdal_ub<-which(extract(canopy_diff_nsb_verdal_ub,treeout_nsb_verdal_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

nsb_verdal_ub_clip<-lasclip(nsb_verdal_ub,treeout_nsb_verdal_ub@polygons[[bigtrees_nsb_verdal_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_nsb_verdal_ub)){
  print(i)
  nsb_verdal_ub_clip<-lasclip(nsb_verdal_ub_clip,treeout_nsb_verdal_ub@polygons[[bigtrees_nsb_verdal_ub[i]]]@Polygons[[1]],inside=F)}
plot(nsb_verdal_ub_clip) #point cloud without large trees

canopy_diff_nsb_verdal_ub_clip <- (as.raster(grid_canopy(nsb_verdal_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(nsb_verdal_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(nsb_verdal_ub_clip,res=0.5)))))
plot(canopy_diff_nsb_verdal_ub_clip)

#Cutting the 32x32m square to 20x20 m
nsb_verdal_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name==' 1Nsub',4:5]))
nsb_verdal_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name==' 1Nsub',4:5][nsb_verdal_ub_order,]))
nsb_verdal_ub_cut<-lasclip(nsb_verdal_ub_clip,nsb_verdal_ub_poly)
plot(nsb_verdal_ub_cut) #20x20 m area as point cloud

terrainmod_nsb_verdal_ub_20x20 <-grid_terrain(nsb_verdal_ub_cut,method='knnidw',res=1)
canopymod_nsb_verdal_ub_20x20  <-grid_canopy(nsb_verdal_ub_cut,res=1)

terrainmod_nsb_verdal_ub_resampeled_20x20 <- resample(as.raster(terrainmod_nsb_verdal_ub_20x20), as.raster(canopymod_nsb_verdal_ub_20x20, method='bilinear'))
canopy_diff_nsb_verdal_ub_20x20 <- (as.raster(canopymod_nsb_verdal_ub_20x20)-terrainmod_nsb_verdal_ub_resampeled_20x20)
plot(canopy_diff_nsb_verdal_ub_20x20)

writeRaster(canopy_diff_nsb_verdal_ub_20x20,'Trondelag/canopy_height_clipped_raster/nsb_verdal_ub_canopyheight', overwrite=TRUE)


# Selbu flub --------------------------------------------------------------


# Selbu flub_b

terrainmod_selbu_flub_b  <-grid_terrain(selbu_flub_b, method='knnidw',res=1)
canopymod_selbu_flub_b   <-grid_canopy(selbu_flub_b,res=1)

terrainmod_selbu_flub_b_resampled <-resample(as.raster(terrainmod_selbu_flub_b), as.raster(canopymod_selbu_flub_b), method='bilinear')
canopy_diff_selbu_flub_b<-(as.raster(canopymod_selbu_flub_b)-terrainmod_selbu_flub_b_resampled)
plot(canopy_diff_selbu_flub_b)
canopy_diff_selbu_flub_b #max value 5,9

#Cutting the 32x32m square to 20x20 m
selbu_flub_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Trondelag/Selbu_flub.las')
selbu_flub_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Flb',4:5]))
selbu_flub_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Flb',4:5][selbu_flub_b_order,]))
selbu_flub_b_cut<-lasclip(selbu_flub_las,selbu_flub_b_poly)
plot(selbu_flub_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_selbu_flub_b_20x20 <-grid_terrain(selbu_flub_b_cut,method='knnidw',res=1)
canopymod_selbu_flub_b_20x20  <-grid_canopy(selbu_flub_b_cut,res=1)

terrainmod_selbu_flub_b_resampeled_20x20 <- resample(as.raster(terrainmod_selbu_flub_b_20x20), as.raster(canopymod_selbu_flub_b_20x20, method='bilinear'))
canopy_diff_selbu_flub_b_20x20 <- (as.raster(canopymod_selbu_flub_b_20x20)-terrainmod_selbu_flub_b_resampeled_20x20)
plot(canopy_diff_selbu_flub_b_20x20)

writeRaster(canopy_diff_selbu_flub_b_20x20,'Trondelag/canopy_height_clipped_raster/selbu_flub_b_canopyheight', overwrite=TRUE)




# Selbu flub_ub
terrainmod_selbu_flub_ub <-grid_terrain(selbu_flub_ub,method='knnidw',res=1)
canopymod_selbu_flub_ub  <-grid_canopy(selbu_flub_ub,res=1)

terrainmod_selbu_flub_ub_resampeled <- resample(as.raster(terrainmod_selbu_flub_ub), as.raster(canopymod_selbu_flub_ub, method='bilinear'))
canopy_diff_selbu_flub_ub <- (as.raster(canopymod_selbu_flub_ub)-terrainmod_selbu_flub_ub_resampeled)
plot(canopy_diff_selbu_flub_ub)
canopy_diff_selbu_flub_ub # max value 5,5 m

#Cutting the 32x32m square to 20x20 m
selbu_flub_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Trondelag/Selbu_flub.las')
selbu_flub_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Flub',4:5]))
selbu_flub_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Flub',4:5][selbu_flub_ub_order,]))
selbu_flub_ub_cut<-lasclip(selbu_flub_las,selbu_flub_ub_poly)
plot(selbu_flub_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_selbu_flub_ub_20x20 <-grid_terrain(selbu_flub_ub_cut,method='knnidw',res=1)
canopymod_selbu_flub_ub_20x20  <-grid_canopy(selbu_flub_ub_cut,res=1)

terrainmod_selbu_flub_ub_resampeled_20x20 <- resample(as.raster(terrainmod_selbu_flub_ub_20x20), as.raster(canopymod_selbu_flub_ub_20x20, method='bilinear'))
canopy_diff_selbu_flub_ub_20x20 <- (as.raster(canopymod_selbu_flub_ub_20x20)-terrainmod_selbu_flub_ub_resampeled_20x20)
plot(canopy_diff_selbu_flub_ub_20x20)

writeRaster(canopy_diff_selbu_flub_ub_20x20,'Trondelag/canopy_height_clipped_raster/selbu_flub_ub_canopyheight', overwrite=TRUE)



# Selbu_kl ----------------------------------------------------------------


# Selbu_kl_b
terrainmod_selbu_kl_b  <-grid_terrain(selbu_kl_b, method='knnidw',res=1)
canopymod_selbu_kl_b   <-grid_canopy(selbu_kl_b,res=1)

terrainmod_selbu_kl_b_resampled <-resample(as.raster(terrainmod_selbu_kl_b), as.raster(canopymod_selbu_kl_b), method='bilinear')
canopy_diff_selbu_kl_b<-(as.raster(canopymod_selbu_kl_b)-terrainmod_selbu_kl_b_resampled)
plot(canopy_diff_selbu_kl_b)

trees_selbu_kl_b<-tree_detection(selbu_kl_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_selbu_kl_b<-extract(canopy_diff_selbu_kl_b,trees_selbu_kl_b[,1:2])

lastrees_dalponte(selbu_kl_b,canopy_diff_selbu_kl_b,trees_selbu_kl_b[treeheight_selbu_kl_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_selbu_kl_b<-tree_hulls(selbu_kl_b,type='convex',field='treeID')
plot(canopy_diff_selbu_kl_b)
plot(treeout_selbu_kl_b,add=T) 

bigtrees_selbu_kl_b<-which(extract(canopy_diff_selbu_kl_b,treeout_selbu_kl_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

selbu_kl_b_clip<-lasclip(selbu_kl_b,treeout_selbu_kl_b@polygons[[bigtrees_selbu_kl_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_selbu_kl_b)){
  print(i)
  selbu_kl_b_clip<-lasclip(selbu_kl_b_clip,treeout_selbu_kl_b@polygons[[bigtrees_selbu_kl_b[i]]]@Polygons[[1]],inside=F)}
plot(selbu_kl_b_clip) #point cloud without large trees, 32x32m

canopy_diff_selbu_kl_b_clip <- (as.raster(grid_canopy(selbu_kl_b_clip,res=0.5))-(crop(as.raster(grid_terrain(selbu_kl_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(selbu_kl_b_clip,res=0.5)))))
plot(canopy_diff_selbu_kl_b_clip)

#Cutting the 32x32m square to 20x20 m
selbu_kl_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Klb',4:5]))
selbu_kl_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Klb',4:5][selbu_kl_b_order,]))
selbu_kl_b_cut<-lasclip(selbu_kl_b_clip,selbu_kl_b_poly)
plot(selbu_kl_b_cut) #20x20 m area as point cloud

terrainmod_selbu_kl_b_20x20 <-grid_terrain(selbu_kl_b_cut,method='knnidw',res=1)
canopymod_selbu_kl_b_20x20  <-grid_canopy(selbu_kl_b_cut,res=1)

terrainmod_selbu_kl_b_resampeled_20x20 <- resample(as.raster(terrainmod_selbu_kl_b_20x20), as.raster(canopymod_selbu_kl_b_20x20, method='bilinear'))
canopy_diff_selbu_kl_b_20x20 <- (as.raster(canopymod_selbu_kl_b_20x20)-terrainmod_selbu_kl_b_resampeled_20x20)
plot(canopy_diff_selbu_kl_b_20x20)

writeRaster(canopy_diff_selbu_kl_b_20x20,'Trondelag/canopy_height_clipped_raster/selbu_kl_b_canopyheight', overwrite=TRUE)



# Selbu_kl_ub
terrainmod_selbu_kl_ub <-grid_terrain(selbu_kl_ub,method='knnidw',res=1)
canopymod_selbu_kl_ub  <-grid_canopy(selbu_kl_ub,res=1)

terrainmod_selbu_kl_ub_resampeled <- resample(as.raster(terrainmod_selbu_kl_ub), as.raster(canopymod_selbu_kl_ub, method='bilinear'))
canopy_diff_selbu_kl_ub <- (as.raster(canopymod_selbu_kl_ub)-terrainmod_selbu_kl_ub_resampeled)
plot(canopy_diff_selbu_kl_ub)

trees_selbu_kl_ub<-tree_detection(selbu_kl_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_selbu_kl_ub<-extract(canopy_diff_selbu_kl_ub,trees_selbu_kl_ub[,1:2])

lastrees_dalponte(selbu_kl_ub,canopy_diff_selbu_kl_ub,trees_selbu_kl_ub[treeheight_selbu_kl_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_selbu_kl_ub<-tree_hulls(selbu_kl_ub,type='convex',field='treeID')
plot(canopy_diff_selbu_kl_ub)
plot(treeout_selbu_kl_ub,add=T) 

bigtrees_selbu_kl_ub<-which(extract(canopy_diff_selbu_kl_ub,treeout_selbu_kl_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

selbu_kl_ub_clip<-lasclip(selbu_kl_ub,treeout_selbu_kl_ub@polygons[[bigtrees_selbu_kl_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_selbu_kl_ub)){
  print(i)
  selbu_kl_ub_clip<-lasclip(selbu_kl_ub_clip,treeout_selbu_kl_ub@polygons[[bigtrees_selbu_kl_ub[i]]]@Polygons[[1]],inside=F)}
plot(selbu_kl_ub_clip) #point cloud without large trees

canopy_diff_selbu_kl_ub_clip <- (as.raster(grid_canopy(selbu_kl_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(selbu_kl_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(selbu_kl_ub_clip,res=0.5)))))
plot(canopy_diff_selbu_kl_ub_clip)

#Cutting the 32x32m square to 20x20 m
selbu_kl_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Klub',4:5]))
selbu_kl_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Klub',4:5][selbu_kl_ub_order,]))
selbu_kl_ub_cut<-lasclip(selbu_kl_ub_clip,selbu_kl_ub_poly)
plot(selbu_kl_ub_cut) #20x20 m area as point cloud

terrainmod_selbu_kl_ub_20x20 <-grid_terrain(selbu_kl_ub_cut,method='knnidw',res=1)
canopymod_selbu_kl_ub_20x20  <-grid_canopy(selbu_kl_ub_cut,res=1)

terrainmod_selbu_kl_ub_resampeled_20x20 <- resample(as.raster(terrainmod_selbu_kl_ub_20x20), as.raster(canopymod_selbu_kl_ub_20x20, method='bilinear'))
canopy_diff_selbu_kl_ub_20x20 <- (as.raster(canopymod_selbu_kl_ub_20x20)-terrainmod_selbu_kl_ub_resampeled_20x20)
plot(canopy_diff_selbu_kl_ub_20x20)

writeRaster(canopy_diff_selbu_kl_ub_20x20,'Trondelag/canopy_height_clipped_raster/selbu_kl_ub_canopyheight', overwrite=TRUE)




# Selbu_sl ----------------------------------------------------------------


# Selbu_sl_b
terrainmod_selbu_sl_b  <-grid_terrain(selbu_sl_b, method='knnidw',res=1)
canopymod_selbu_sl_b   <-grid_canopy(selbu_sl_b,res=1)

terrainmod_selbu_sl_b_resampled <-resample(as.raster(terrainmod_selbu_sl_b), as.raster(canopymod_selbu_sl_b), method='bilinear')
canopy_diff_selbu_sl_b<-(as.raster(canopymod_selbu_sl_b)-terrainmod_selbu_sl_b_resampled)
plot(canopy_diff_selbu_sl_b)

trees_selbu_sl_b<-tree_detection(selbu_sl_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_selbu_sl_b<-extract(canopy_diff_selbu_sl_b,trees_selbu_sl_b[,1:2])

lastrees_dalponte(selbu_sl_b,canopy_diff_selbu_sl_b,trees_selbu_sl_b[treeheight_selbu_sl_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_selbu_sl_b<-tree_hulls(selbu_sl_b,type='convex',field='treeID')
plot(canopy_diff_selbu_sl_b)
plot(treeout_selbu_sl_b,add=T) 

bigtrees_selbu_sl_b<-which(extract(canopy_diff_selbu_sl_b,treeout_selbu_sl_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

selbu_sl_b_clip<-lasclip(selbu_sl_b,treeout_selbu_sl_b@polygons[[bigtrees_selbu_sl_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_selbu_sl_b)){
  print(i)
  selbu_sl_b_clip<-lasclip(selbu_sl_b_clip,treeout_selbu_sl_b@polygons[[bigtrees_selbu_sl_b[i]]]@Polygons[[1]],inside=F)}
plot(selbu_sl_b_clip) #point cloud without large trees

canopy_diff_selbu_sl_b_clip <- (as.raster(grid_canopy(selbu_sl_b_clip,res=0.5))-(crop(as.raster(grid_terrain(selbu_sl_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(selbu_sl_b_clip,res=0.5)))))
plot(canopy_diff_selbu_sl_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
selbu_sl_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Slb',4:5]))
selbu_sl_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Slb',4:5][selbu_sl_b_order,]))
selbu_sl_b_cut<-lasclip(selbu_sl_b_clip,selbu_sl_b_poly)
plot(selbu_sl_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_selbu_sl_b_20x20 <-grid_terrain(selbu_sl_b_cut,method='knnidw',res=1)
canopymod_selbu_sl_b_20x20  <-grid_canopy(selbu_sl_b_cut,res=1)

terrainmod_selbu_sl_b_resampeled_20x20 <- resample(as.raster(terrainmod_selbu_sl_b_20x20), as.raster(canopymod_selbu_sl_b_20x20, method='bilinear'))
canopy_diff_selbu_sl_b_20x20 <- (as.raster(canopymod_selbu_sl_b_20x20)-terrainmod_selbu_sl_b_resampeled_20x20)
plot(canopy_diff_selbu_sl_b_20x20)

writeRaster(canopy_diff_selbu_sl_b_20x20,'Trondelag/canopy_height_clipped_raster/selbu_sl_b_canopyheight', overwrite=TRUE)



# Selbu_sl_ub
terrainmod_selbu_sl_ub <-grid_terrain(selbu_sl_ub,method='knnidw',res=1)
canopymod_selbu_sl_ub  <-grid_canopy(selbu_sl_ub,res=1)

terrainmod_selbu_sl_ub_resampeled <- resample(as.raster(terrainmod_selbu_sl_ub), as.raster(canopymod_selbu_sl_ub, method='bilinear'))
canopy_diff_selbu_sl_ub <- (as.raster(canopymod_selbu_sl_ub)-terrainmod_selbu_sl_ub_resampeled)
plot(canopy_diff_selbu_sl_ub)
canopy_diff_selbu_sl_ub 

trees_selbu_sl_ub<-tree_detection(selbu_sl_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_selbu_sl_ub<-extract(canopy_diff_selbu_sl_ub,trees_selbu_sl_ub[,1:2])

lastrees_dalponte(selbu_sl_ub,canopy_diff_selbu_sl_ub,trees_selbu_sl_ub[treeheight_selbu_sl_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_selbu_sl_ub<-tree_hulls(selbu_sl_ub,type='convex',field='treeID')
plot(canopy_diff_selbu_sl_ub)
plot(treeout_selbu_sl_ub,add=T) 

bigtrees_selbu_sl_ub<-which(extract(canopy_diff_selbu_sl_ub,treeout_selbu_sl_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

selbu_sl_ub_clip<-lasclip(selbu_sl_ub,treeout_selbu_sl_ub@polygons[[bigtrees_selbu_sl_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_selbu_sl_ub)){
  print(i)
  selbu_sl_ub_clip<-lasclip(selbu_sl_ub_clip,treeout_selbu_sl_ub@polygons[[bigtrees_selbu_sl_ub[i]]]@Polygons[[1]],inside=F)}
plot(selbu_sl_ub_clip) #point cloud without large trees

canopy_diff_selbu_sl_ub_clip <- (as.raster(grid_canopy(selbu_sl_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(selbu_sl_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(selbu_sl_ub_clip,res=0.5)))))
plot(canopy_diff_selbu_sl_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
selbu_sl_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Slub',4:5]))
selbu_sl_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Slub',4:5][selbu_sl_ub_order,]))
selbu_sl_ub_cut<-lasclip(selbu_sl_ub_clip,selbu_sl_ub_poly)
plot(selbu_sl_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_selbu_sl_ub_20x20 <-grid_terrain(selbu_sl_ub_cut,method='knnidw',res=1)
canopymod_selbu_sl_ub_20x20  <-grid_canopy(selbu_sl_ub_cut,res=1)

terrainmod_selbu_sl_ub_resampeled_20x20 <- resample(as.raster(terrainmod_selbu_sl_ub_20x20), as.raster(canopymod_selbu_sl_ub_20x20, method='bilinear'))
canopy_diff_selbu_sl_ub_20x20 <- (as.raster(canopymod_selbu_sl_ub_20x20)-terrainmod_selbu_sl_ub_resampeled_20x20)
plot(canopy_diff_selbu_sl_ub_20x20)

writeRaster(canopy_diff_selbu_sl_ub_20x20,'Trondelag/canopy_height_clipped_raster/selbu_sl_ub_canopyheight', overwrite=TRUE)



# Singsaas ----------------------------------------------------------------


# Singsaas_b
#Make canopyheight model for 32x32m area, remove big trees.
terrainmod_singsaas_b  <-grid_terrain(singsaas_b, method='knnidw',res=1)
canopymod_singsaas_b   <-grid_canopy(singsaas_b,res=1)

terrainmod_singsaas_b_resampled <-resample(as.raster(terrainmod_singsaas_b), as.raster(canopymod_singsaas_b), method='bilinear')
canopy_diff_singsaas_b<-(as.raster(canopymod_singsaas_b)-terrainmod_singsaas_b_resampled)
plot(canopy_diff_singsaas_b)

trees_singsaas_b<-tree_detection(singsaas_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_singsaas_b<-extract(canopy_diff_singsaas_b,trees_singsaas_b[,1:2])

lastrees_dalponte(singsaas_b,canopy_diff_singsaas_b,trees_singsaas_b[treeheight_singsaas_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_singsaas_b<-tree_hulls(singsaas_b,type='convex',field='treeID')
plot(canopy_diff_singsaas_b)
plot(treeout_singsaas_b,add=T) 

bigtrees_singsaas_b<-which(extract(canopy_diff_singsaas_b,treeout_singsaas_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

singsaas_b_clip<-lasclip(singsaas_b,treeout_singsaas_b@polygons[[bigtrees_singsaas_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_singsaas_b)){
  print(i)
  singsaas_b_clip<-lasclip(singsaas_b_clip,treeout_singsaas_b@polygons[[bigtrees_singsaas_b[i]]]@Polygons[[1]],inside=F)}
plot(singsaas_b_clip) 

canopy_diff_singsaas_b_clip <- (as.raster(grid_canopy(singsaas_b_clip,res=0.5))-(crop(as.raster(grid_terrain(singsaas_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(singsaas_b_clip,res=0.5)))))
plot(canopy_diff_singsaas_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
singsaas_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Lab',4:5]))
singsaas_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Lab',4:5][singsaas_b_order,]))
singsaas_b_cut<-lasclip(singsaas_b_clip,singsaas_b_poly)
plot(singsaas_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_singsaas_b_20x20 <-grid_terrain(singsaas_b_cut,method='knnidw',res=1)
canopymod_singsaas_b_20x20  <-grid_canopy(singsaas_b_cut,res=1)

terrainmod_singsaas_b_resampeled_20x20 <- resample(as.raster(terrainmod_singsaas_b_20x20), as.raster(canopymod_singsaas_b_20x20, method='bilinear'))
canopy_diff_singsaas_b_20x20 <- (as.raster(canopymod_singsaas_b_20x20)-terrainmod_singsaas_b_resampeled_20x20)
plot(canopy_diff_singsaas_b_20x20)

writeRaster(canopy_diff_singsaas_b_20x20,'Trondelag/canopy_height_clipped_raster/singsaas_b_canopyheight', overwrite=TRUE)




# Singsaas_ub
terrainmod_singsaas_ub <-grid_terrain(singsaas_ub,method='knnidw',res=1)
canopymod_singsaas_ub  <-grid_canopy(singsaas_ub,res=1)

terrainmod_singsaas_ub_resampeled <- resample(as.raster(terrainmod_singsaas_ub), as.raster(canopymod_singsaas_ub, method='bilinear'))
canopy_diff_singsaas_ub <- (as.raster(canopymod_singsaas_ub)-terrainmod_singsaas_ub_resampeled)
plot(canopy_diff_singsaas_ub)

trees_singsaas_ub<-tree_detection(singsaas_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_singsaas_ub<-extract(canopy_diff_singsaas_ub,trees_singsaas_ub[,1:2])

lastrees_dalponte(singsaas_ub,canopy_diff_singsaas_ub,trees_singsaas_ub[treeheight_singsaas_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_singsaas_ub<-tree_hulls(singsaas_ub,type='convex',field='treeID')
plot(canopy_diff_singsaas_ub)
plot(treeout_singsaas_ub,add=T) 

bigtrees_singsaas_ub<-which(extract(canopy_diff_singsaas_ub,treeout_singsaas_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

singsaas_ub_clip<-lasclip(singsaas_ub,treeout_singsaas_ub@polygons[[bigtrees_singsaas_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_singsaas_ub)){
  print(i)
  singsaas_ub_clip<-lasclip(singsaas_ub_clip,treeout_singsaas_ub@polygons[[bigtrees_singsaas_ub[i]]]@Polygons[[1]],inside=F)}
plot(singsaas_ub_clip) 

canopy_diff_singsaas_ub_clip <- (as.raster(grid_canopy(singsaas_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(singsaas_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(singsaas_ub_clip,res=0.5)))))
plot(canopy_diff_singsaas_ub_clip)

#Cutting the 32x32m square to 20x20 m
singsaas_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Laub',4:5]))
singsaas_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Laub',4:5][singsaas_ub_order,]))
singsaas_ub_cut<-lasclip(singsaas_ub_clip,singsaas_ub_poly)
plot(singsaas_ub_cut) #20x20 m area as point cloud

terrainmod_singsaas_ub_20x20 <-grid_terrain(singsaas_ub_cut,method='knnidw',res=1)
canopymod_singsaas_ub_20x20  <-grid_canopy(singsaas_ub_cut,res=1)

terrainmod_singsaas_ub_resampeled_20x20 <- resample(as.raster(terrainmod_singsaas_ub_20x20), as.raster(canopymod_singsaas_ub_20x20, method='bilinear'))
canopy_diff_singsaas_ub_20x20 <- (as.raster(canopymod_singsaas_ub_20x20)-terrainmod_singsaas_ub_resampeled_20x20)
plot(canopy_diff_singsaas_ub_20x20)

writeRaster(canopy_diff_singsaas_ub_20x20,'Trondelag/canopy_height_clipped_raster/singsaas_ub_canopyheight', overwrite=TRUE)



# sl_tydal ----------------------------------------------------------------


# sl_tydal_b
terrainmod_sl_tydal_b  <-grid_terrain(sl_tydal_b, method='knnidw',res=1)
canopymod_sl_tydal_b   <-grid_canopy(sl_tydal_b,res=1)

terrainmod_sl_tydal_b_resampled <-resample(as.raster(terrainmod_sl_tydal_b), as.raster(canopymod_sl_tydal_b), method='bilinear')
canopy_diff_sl_tydal_b<-(as.raster(canopymod_sl_tydal_b)-terrainmod_sl_tydal_b_resampled)
plot(canopy_diff_sl_tydal_b)

trees_sl_tydal_b<-tree_detection(sl_tydal_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_sl_tydal_b<-extract(canopy_diff_sl_tydal_b,trees_sl_tydal_b[,1:2])

lastrees_dalponte(sl_tydal_b,canopy_diff_sl_tydal_b,trees_sl_tydal_b[treeheight_sl_tydal_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_sl_tydal_b<-tree_hulls(sl_tydal_b,type='convex',field='treeID')
plot(canopy_diff_sl_tydal_b)
plot(treeout_sl_tydal_b,add=T) 

bigtrees_sl_tydal_b<-which(extract(canopy_diff_sl_tydal_b,treeout_sl_tydal_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

sl_tydal_b_clip<-lasclip(sl_tydal_b,treeout_sl_tydal_b@polygons[[bigtrees_sl_tydal_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_sl_tydal_b)){
  print(i)
  sl_tydal_b_clip<-lasclip(sl_tydal_b_clip,treeout_sl_tydal_b@polygons[[bigtrees_sl_tydal_b[i]]]@Polygons[[1]],inside=F)}
plot(sl_tydal_b_clip) 

canopy_diff_sl_tydal_b_clip <- (as.raster(grid_canopy(sl_tydal_b_clip,res=0.5))-(crop(as.raster(grid_terrain(sl_tydal_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(sl_tydal_b_clip,res=0.5)))))
plot(canopy_diff_sl_tydal_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
sl_tydal_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Seb',4:5]))
sl_tydal_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Seb',4:5][sl_tydal_b_order,]))
sl_tydal_b_cut<-lasclip(sl_tydal_b_clip,sl_tydal_b_poly)
plot(sl_tydal_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_sl_tydal_b_20x20 <-grid_terrain(sl_tydal_b_cut,method='knnidw',res=1)
canopymod_sl_tydal_b_20x20  <-grid_canopy(sl_tydal_b_cut,res=1)

terrainmod_sl_tydal_b_resampeled_20x20 <- resample(as.raster(terrainmod_sl_tydal_b_20x20), as.raster(canopymod_sl_tydal_b_20x20, method='bilinear'))
canopy_diff_sl_tydal_b_20x20 <- (as.raster(canopymod_sl_tydal_b_20x20)-terrainmod_sl_tydal_b_resampeled_20x20)
plot(canopy_diff_sl_tydal_b_20x20)

writeRaster(canopy_diff_sl_tydal_b_20x20,'Trondelag/canopy_height_clipped_raster/sl_tydal_b_canopyheight', overwrite=TRUE)



# sl_tydal_ub
terrainmod_sl_tydal_ub <-grid_terrain(sl_tydal_ub,method='knnidw',res=1)
canopymod_sl_tydal_ub  <-grid_canopy(sl_tydal_ub,res=1)

terrainmod_sl_tydal_ub_resampeled <- resample(as.raster(terrainmod_sl_tydal_ub), as.raster(canopymod_sl_tydal_ub, method='bilinear'))
canopy_diff_sl_tydal_ub <- (as.raster(canopymod_sl_tydal_ub)-terrainmod_sl_tydal_ub_resampeled)
plot(canopy_diff_sl_tydal_ub)
canopy_diff_sl_tydal_ub


trees_sl_tydal_ub<-tree_detection(sl_tydal_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_sl_tydal_ub<-extract(canopy_diff_sl_tydal_ub,trees_sl_tydal_ub[,1:2])

lastrees_dalponte(sl_tydal_ub,canopy_diff_sl_tydal_ub,trees_sl_tydal_ub[treeheight_sl_tydal_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_sl_tydal_ub<-tree_hulls(sl_tydal_ub,type='convex',field='treeID')
plot(canopy_diff_sl_tydal_ub)
plot(treeout_sl_tydal_ub,add=T) 

bigtrees_sl_tydal_ub<-which(extract(canopy_diff_sl_tydal_ub,treeout_sl_tydal_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

sl_tydal_ub_clip<-lasclip(sl_tydal_ub,treeout_sl_tydal_ub@polygons[[bigtrees_sl_tydal_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_sl_tydal_ub)){
  print(i)
  sl_tydal_ub_clip<-lasclip(sl_tydal_ub_clip,treeout_sl_tydal_ub@polygons[[bigtrees_sl_tydal_ub[i]]]@Polygons[[1]],inside=F)}
plot(sl_tydal_ub_clip) 

canopy_diff_sl_tydal_ub_clip <- (as.raster(grid_canopy(sl_tydal_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(sl_tydal_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(sl_tydal_ub_clip,res=0.5)))))
plot(canopy_diff_sl_tydal_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
sl_tydal_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='Seub',4:5]))
sl_tydal_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='Seub',4:5][sl_tydal_ub_order,]))
sl_tydal_ub_cut<-lasclip(sl_tydal_ub_clip,sl_tydal_ub_poly)
plot(sl_tydal_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_sl_tydal_ub_20x20 <-grid_terrain(sl_tydal_ub_cut,method='knnidw',res=1)
canopymod_sl_tydal_ub_20x20  <-grid_canopy(sl_tydal_ub_cut,res=1)

terrainmod_sl_tydal_ub_resampeled_20x20 <- resample(as.raster(terrainmod_sl_tydal_ub_20x20), as.raster(canopymod_sl_tydal_ub_20x20, method='bilinear'))
canopy_diff_sl_tydal_ub_20x20 <- (as.raster(canopymod_sl_tydal_ub_20x20)-terrainmod_sl_tydal_ub_resampeled_20x20)
plot(canopy_diff_sl_tydal_ub_20x20)

writeRaster(canopy_diff_sl_tydal_ub_20x20,'Trondelag/canopy_height_clipped_raster/sl_tydal_ub_canopyheight', overwrite=TRUE)


# steinkjer_1BBb ----------------------------------------------------------


# Steinkjer_1BBb_b
terrainmod_steinkjer_1BBb_b  <-grid_terrain(steinkjer_1BBb_b, method='knnidw',res=1)
canopymod_steinkjer_1BBb_b   <-grid_canopy(steinkjer_1BBb_b,res=1)

terrainmod_steinkjer_1BBb_b_resampled <-resample(as.raster(terrainmod_steinkjer_1BBb_b), as.raster(canopymod_steinkjer_1BBb_b), method='bilinear')
canopy_diff_steinkjer_1BBb_b<-(as.raster(canopymod_steinkjer_1BBb_b)-terrainmod_steinkjer_1BBb_b_resampled)
plot(canopy_diff_steinkjer_1BBb_b)
canopy_diff_steinkjer_1BBb_b 

trees_steinkjer_1BBb_b<-tree_detection(steinkjer_1BBb_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_steinkjer_1BBb_b<-extract(canopy_diff_steinkjer_1BBb_b,trees_steinkjer_1BBb_b[,1:2])

lastrees_dalponte(steinkjer_1BBb_b,canopy_diff_steinkjer_1BBb_b,trees_steinkjer_1BBb_b[treeheight_steinkjer_1BBb_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_steinkjer_1BBb_b<-tree_hulls(steinkjer_1BBb_b,type='convex',field='treeID')
plot(canopy_diff_steinkjer_1BBb_b)
plot(treeout_steinkjer_1BBb_b,add=T) 

bigtrees_steinkjer_1BBb_b<-which(extract(canopy_diff_steinkjer_1BBb_b,treeout_steinkjer_1BBb_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

steinkjer_1BBb_b_clip<-lasclip(steinkjer_1BBb_b,treeout_steinkjer_1BBb_b@polygons[[bigtrees_steinkjer_1BBb_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_steinkjer_1BBb_b)){
  print(i)
  steinkjer_1BBb_b_clip<-lasclip(steinkjer_1BBb_b_clip,treeout_steinkjer_1BBb_b@polygons[[bigtrees_steinkjer_1BBb_b[i]]]@Polygons[[1]],inside=F)}
plot(steinkjer_1BBb_b_clip) 

canopy_diff_steinkjer_1BBb_b_clip <- (as.raster(grid_canopy(steinkjer_1BBb_b_clip,res=0.5))-(crop(as.raster(grid_terrain(steinkjer_1BBb_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(steinkjer_1BBb_b_clip,res=0.5)))))
plot(canopy_diff_steinkjer_1BBb_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
steinkjer_1BBb_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='1Bbb',4:5]))
steinkjer_1BBb_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='1Bbb',4:5][steinkjer_1BBb_b_order,]))
steinkjer_1BBb_b_cut<-lasclip(steinkjer_1BBb_b_clip,steinkjer_1BBb_b_poly)
plot(steinkjer_1BBb_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_steinkjer_1BBb_b_20x20 <-grid_terrain(steinkjer_1BBb_b_cut,method='knnidw',res=1)
canopymod_steinkjer_1BBb_b_20x20  <-grid_canopy(steinkjer_1BBb_b_cut,res=1)

terrainmod_steinkjer_1BBb_b_resampeled_20x20 <- resample(as.raster(terrainmod_steinkjer_1BBb_b_20x20), as.raster(canopymod_steinkjer_1BBb_b_20x20, method='bilinear'))
canopy_diff_steinkjer_1BBb_b_20x20 <- (as.raster(canopymod_steinkjer_1BBb_b_20x20)-terrainmod_steinkjer_1BBb_b_resampeled_20x20)
plot(canopy_diff_steinkjer_1BBb_b_20x20)

writeRaster(canopy_diff_steinkjer_1BBb_b_20x20,'Trondelag/canopy_height_clipped_raster/steinkjer_1BBb_b_canopyheight', overwrite=TRUE)

# Steinkjer_1BBb_ub
terrainmod_steinkjer_1BBb_ub <-grid_terrain(steinkjer_1BBb_ub,method='knnidw',res=1)
canopymod_steinkjer_1BBb_ub  <-grid_canopy(steinkjer_1BBb_ub,res=1)

terrainmod_steinkjer_1BBb_ub_resampeled <- resample(as.raster(terrainmod_steinkjer_1BBb_ub), as.raster(canopymod_steinkjer_1BBb_ub, method='bilinear'))
canopy_diff_steinkjer_1BBb_ub <- (as.raster(canopymod_steinkjer_1BBb_ub)-terrainmod_steinkjer_1BBb_ub_resampeled)
plot(canopy_diff_steinkjer_1BBb_ub)
canopy_diff_steinkjer_1BBb_ub # max 8,395, but it is only one pixel that will not be included in the 20x20 m plot, and it will not be identified as a tree and cut away
#no use in running tree identification and cutting

#Cutting the 32x32m square to 20x20 m
steinkjer_1BBb_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='1Bbub',4:5]))
steinkjer_1BBb_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='1Bbub',4:5][steinkjer_1BBb_ub_order,]))
steinkjer_1BBb_ub_cut<-lasclip(steinkjer_1BBb_las,steinkjer_1BBb_ub_poly)
plot(steinkjer_1BBb_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_steinkjer_1BBb_ub_20x20 <-grid_terrain(steinkjer_1BBb_ub_cut,method='knnidw',res=1)
canopymod_steinkjer_1BBb_ub_20x20  <-grid_canopy(steinkjer_1BBb_ub_cut,res=1)

terrainmod_steinkjer_1BBb_ub_resampeled_20x20 <- resample(as.raster(terrainmod_steinkjer_1BBb_ub_20x20), as.raster(canopymod_steinkjer_1BBb_ub_20x20, method='bilinear'))
canopy_diff_steinkjer_1BBb_ub_20x20 <- (as.raster(canopymod_steinkjer_1BBb_ub_20x20)-terrainmod_steinkjer_1BBb_ub_resampeled_20x20)
plot(canopy_diff_steinkjer_1BBb_ub_20x20)

writeRaster(canopy_diff_steinkjer_1BBb_ub_20x20,'Trondelag/canopy_height_clipped_raster/steinkjer_1BBb_ub_canopyheight', overwrite=TRUE)



# Steinkjer_2BBb ----------------------------------------------------------


# Steinkjer_2BBb_b
terrainmod_steinkjer_2BBb_b  <-grid_terrain(steinkjer_2BBb_b, method='knnidw',res=1)
canopymod_steinkjer_2BBb_b   <-grid_canopy(steinkjer_2BBb_b,res=1)

terrainmod_steinkjer_2BBb_b_resampled <-resample(as.raster(terrainmod_steinkjer_2BBb_b), as.raster(canopymod_steinkjer_2BBb_b), method='bilinear')
canopy_diff_steinkjer_2BBb_b<-(as.raster(canopymod_steinkjer_2BBb_b)-terrainmod_steinkjer_2BBb_b_resampled)
plot(canopy_diff_steinkjer_2BBb_b)

trees_steinkjer_2BBb_b<-tree_detection(steinkjer_2BBb_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_steinkjer_2BBb_b<-extract(canopy_diff_steinkjer_2BBb_b,trees_steinkjer_2BBb_b[,1:2])

lastrees_dalponte(steinkjer_2BBb_b,canopy_diff_steinkjer_2BBb_b,trees_steinkjer_2BBb_b[treeheight_steinkjer_2BBb_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_steinkjer_2BBb_b<-tree_hulls(steinkjer_2BBb_b,type='convex',field='treeID')
plot(canopy_diff_steinkjer_2BBb_b)
plot(treeout_steinkjer_2BBb_b,add=T) 

bigtrees_steinkjer_2BBb_b<-which(extract(canopy_diff_steinkjer_2BBb_b,treeout_steinkjer_2BBb_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

steinkjer_2BBb_b_clip<-lasclip(steinkjer_2BBb_b,treeout_steinkjer_2BBb_b@polygons[[bigtrees_steinkjer_2BBb_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_steinkjer_2BBb_b)){
  print(i)
  steinkjer_2BBb_b_clip<-lasclip(steinkjer_2BBb_b_clip,treeout_steinkjer_2BBb_b@polygons[[bigtrees_steinkjer_2BBb_b[i]]]@Polygons[[1]],inside=F)}
plot(steinkjer_2BBb_b_clip) 

canopy_diff_steinkjer_2BBb_b_clip <- (as.raster(grid_canopy(steinkjer_2BBb_b_clip,res=0.5))-(crop(as.raster(grid_terrain(steinkjer_2BBb_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(steinkjer_2BBb_b_clip,res=0.5)))))
plot(canopy_diff_steinkjer_2BBb_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
steinkjer_2BBb_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='2Bbb',4:5]))
steinkjer_2BBb_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='2Bbb',4:5][steinkjer_2BBb_b_order,]))
steinkjer_2BBb_b_cut<-lasclip(steinkjer_2BBb_b_clip,steinkjer_2BBb_b_poly)
plot(steinkjer_2BBb_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_steinkjer_2BBb_b_20x20 <-grid_terrain(steinkjer_2BBb_b_cut,method='knnidw',res=1)
canopymod_steinkjer_2BBb_b_20x20  <-grid_canopy(steinkjer_2BBb_b_cut,res=1)

terrainmod_steinkjer_2BBb_b_resampeled_20x20 <- resample(as.raster(terrainmod_steinkjer_2BBb_b_20x20), as.raster(canopymod_steinkjer_2BBb_b_20x20, method='bilinear'))
canopy_diff_steinkjer_2BBb_b_20x20 <- (as.raster(canopymod_steinkjer_2BBb_b_20x20)-terrainmod_steinkjer_2BBb_b_resampeled_20x20)
plot(canopy_diff_steinkjer_2BBb_b_20x20)

writeRaster(canopy_diff_steinkjer_2BBb_b_20x20,'Trondelag/canopy_height_clipped_raster/steinkjer_2BBb_b_canopyheight', overwrite=TRUE)


# Steinkjer_2BBb_ub
terrainmod_steinkjer_2BBb_ub <-grid_terrain(steinkjer_2BBb_ub,method='knnidw',res=1)
canopymod_steinkjer_2BBb_ub  <-grid_canopy(steinkjer_2BBb_ub,res=1)

terrainmod_steinkjer_2BBb_ub_resampeled <- resample(as.raster(terrainmod_steinkjer_2BBb_ub), as.raster(canopymod_steinkjer_2BBb_ub, method='bilinear'))
canopy_diff_steinkjer_2BBb_ub <- (as.raster(canopymod_steinkjer_2BBb_ub)-terrainmod_steinkjer_2BBb_ub_resampeled)
plot(canopy_diff_steinkjer_2BBb_ub)

trees_steinkjer_2BBb_ub<-tree_detection(steinkjer_2BBb_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_steinkjer_2BBb_ub<-extract(canopy_diff_steinkjer_2BBb_ub,trees_steinkjer_2BBb_ub[,1:2])

lastrees_dalponte(steinkjer_2BBb_ub,canopy_diff_steinkjer_2BBb_ub,trees_steinkjer_2BBb_ub[treeheight_steinkjer_2BBb_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_steinkjer_2BBb_ub<-tree_hulls(steinkjer_2BBb_ub,type='convex',field='treeID')
plot(canopy_diff_steinkjer_2BBb_ub)
plot(treeout_steinkjer_2BBb_ub,add=T) 

bigtrees_steinkjer_2BBb_ub<-which(extract(canopy_diff_steinkjer_2BBb_ub,treeout_steinkjer_2BBb_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

steinkjer_2BBb_ub_clip<-lasclip(steinkjer_2BBb_ub,treeout_steinkjer_2BBb_ub@polygons[[bigtrees_steinkjer_2BBb_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_steinkjer_2BBb_ub)){
  print(i)
  steinkjer_2BBb_ub_clip<-lasclip(steinkjer_2BBb_ub_clip,treeout_steinkjer_2BBb_ub@polygons[[bigtrees_steinkjer_2BBb_ub[i]]]@Polygons[[1]],inside=F)}
plot(steinkjer_2BBb_ub_clip) 

canopy_diff_steinkjer_2BBb_ub_clip <- (as.raster(grid_canopy(steinkjer_2BBb_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(steinkjer_2BBb_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(steinkjer_2BBb_ub_clip,res=0.5)))))
plot(canopy_diff_steinkjer_2BBb_ub_clip)

#Cutting the 32x32m square to 20x20 m
steinkjer_2BBb_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='2Bbub',4:5]))
steinkjer_2BBb_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='2Bbub',4:5][steinkjer_2BBb_ub_order,]))
steinkjer_2BBb_ub_cut<-lasclip(steinkjer_2BBb_ub_clip,steinkjer_2BBb_ub_poly)
plot(steinkjer_2BBb_ub_cut) #20x20 m area as point cloud

terrainmod_steinkjer_2BBb_ub_20x20 <-grid_terrain(steinkjer_2BBb_ub_cut,method='knnidw',res=1)
canopymod_steinkjer_2BBb_ub_20x20  <-grid_canopy(steinkjer_2BBb_ub_cut,res=1)

terrainmod_steinkjer_2BBb_ub_resampeled_20x20 <- resample(as.raster(terrainmod_steinkjer_2BBb_ub_20x20), as.raster(canopymod_steinkjer_2BBb_ub_20x20, method='bilinear'))
canopy_diff_steinkjer_2BBb_ub_20x20 <- (as.raster(canopymod_steinkjer_2BBb_ub_20x20)-terrainmod_steinkjer_2BBb_ub_resampeled_20x20)
plot(canopy_diff_steinkjer_2BBb_ub_20x20)

writeRaster(canopy_diff_steinkjer_2BBb_ub_20x20,'Trondelag/canopy_height_clipped_raster/steinkjer_2BBb_ub_canopyheight', overwrite=TRUE)




# Sub_namdalseid ----------------------------------------------------------


# sub_namdalseid_b
terrainmod_sub_namdalseid_b  <-grid_terrain(sub_namdalseid_b, method='knnidw',res=1)
canopymod_sub_namdalseid_b   <-grid_canopy(sub_namdalseid_b,res=1)

terrainmod_sub_namdalseid_b_resampled <-resample(as.raster(terrainmod_sub_namdalseid_b), as.raster(canopymod_sub_namdalseid_b), method='bilinear')
canopy_diff_sub_namdalseid_b<-(as.raster(canopymod_sub_namdalseid_b)-terrainmod_sub_namdalseid_b_resampled)
plot(canopy_diff_sub_namdalseid_b)

trees_sub_namdalseid_b<-tree_detection(sub_namdalseid_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_sub_namdalseid_b<-extract(canopy_diff_sub_namdalseid_b,trees_sub_namdalseid_b[,1:2])

lastrees_dalponte(sub_namdalseid_b,canopy_diff_sub_namdalseid_b,trees_sub_namdalseid_b[treeheight_sub_namdalseid_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_sub_namdalseid_b<-tree_hulls(sub_namdalseid_b,type='convex',field='treeID')
plot(canopy_diff_sub_namdalseid_b)
plot(treeout_sub_namdalseid_b,add=T) 

bigtrees_sub_namdalseid_b<-which(extract(canopy_diff_sub_namdalseid_b,treeout_sub_namdalseid_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

sub_namdalseid_b_clip<-lasclip(sub_namdalseid_b,treeout_sub_namdalseid_b@polygons[[bigtrees_sub_namdalseid_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_sub_namdalseid_b)){
  print(i)
  sub_namdalseid_b_clip<-lasclip(sub_namdalseid_b_clip,treeout_sub_namdalseid_b@polygons[[bigtrees_sub_namdalseid_b[i]]]@Polygons[[1]],inside=F)}
plot(sub_namdalseid_b_clip) 

canopy_diff_sub_namdalseid_b_clip <- (as.raster(grid_canopy(sub_namdalseid_b_clip,res=0.5))-(crop(as.raster(grid_terrain(sub_namdalseid_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(sub_namdalseid_b_clip,res=0.5)))))
plot(canopy_diff_sub_namdalseid_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
sub_namdalseid_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='1Sb',4:5]))
sub_namdalseid_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='1Sb',4:5][sub_namdalseid_b_order,]))
sub_namdalseid_b_cut<-lasclip(sub_namdalseid_b_clip,sub_namdalseid_b_poly)
plot(sub_namdalseid_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_sub_namdalseid_b_20x20 <-grid_terrain(sub_namdalseid_b_cut,method='knnidw',res=1)
canopymod_sub_namdalseid_b_20x20  <-grid_canopy(sub_namdalseid_b_cut,res=1)

terrainmod_sub_namdalseid_b_resampeled_20x20 <- resample(as.raster(terrainmod_sub_namdalseid_b_20x20), as.raster(canopymod_sub_namdalseid_b_20x20, method='bilinear'))
canopy_diff_sub_namdalseid_b_20x20 <- (as.raster(canopymod_sub_namdalseid_b_20x20)-terrainmod_sub_namdalseid_b_resampeled_20x20)
plot(canopy_diff_sub_namdalseid_b_20x20)

writeRaster(canopy_diff_sub_namdalseid_b_20x20,'Trondelag/canopy_height_clipped_raster/sub_namdalseid_b_canopyheight', overwrite=TRUE)


# sub_namdalseid_ub
terrainmod_sub_namdalseid_ub <-grid_terrain(sub_namdalseid_ub,method='knnidw',res=1)
canopymod_sub_namdalseid_ub  <-grid_canopy(sub_namdalseid_ub,res=1)


terrainmod_sub_namdalseid_ub_resampeled <- resample(as.raster(terrainmod_sub_namdalseid_ub), as.raster(canopymod_sub_namdalseid_ub, method='bilinear'))
canopy_diff_sub_namdalseid_ub <- (as.raster(canopymod_sub_namdalseid_ub)-terrainmod_sub_namdalseid_ub_resampeled)
plot(canopy_diff_sub_namdalseid_ub)

trees_sub_namdalseid_ub<-tree_detection(sub_namdalseid_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_sub_namdalseid_ub<-extract(canopy_diff_sub_namdalseid_ub,trees_sub_namdalseid_ub[,1:2])

lastrees_dalponte(sub_namdalseid_ub,canopy_diff_sub_namdalseid_ub,trees_sub_namdalseid_ub[treeheight_sub_namdalseid_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_sub_namdalseid_ub<-tree_hulls(sub_namdalseid_ub,type='convex',field='treeID')
plot(canopy_diff_sub_namdalseid_ub)
plot(treeout_sub_namdalseid_ub,add=T) 

bigtrees_sub_namdalseid_ub<-which(extract(canopy_diff_sub_namdalseid_ub,treeout_sub_namdalseid_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

sub_namdalseid_ub_clip<-lasclip(sub_namdalseid_ub,treeout_sub_namdalseid_ub@polygons[[bigtrees_sub_namdalseid_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_sub_namdalseid_ub)){
  print(i)
  sub_namdalseid_ub_clip<-lasclip(sub_namdalseid_ub_clip,treeout_sub_namdalseid_ub@polygons[[bigtrees_sub_namdalseid_ub[i]]]@Polygons[[1]],inside=F)}
plot(sub_namdalseid_ub_clip) 

canopy_diff_sub_namdalseid_ub_clip <- (as.raster(grid_canopy(sub_namdalseid_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(sub_namdalseid_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(sub_namdalseid_ub_clip,res=0.5)))))
plot(canopy_diff_sub_namdalseid_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
sub_namdalseid_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='1Sub',4:5]))
sub_namdalseid_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='1Sub',4:5][sub_namdalseid_ub_order,]))
sub_namdalseid_ub_cut<-lasclip(sub_namdalseid_ub_clip,sub_namdalseid_ub_poly)
plot(sub_namdalseid_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_sub_namdalseid_ub_20x20 <-grid_terrain(sub_namdalseid_ub_cut,method='knnidw',res=1)
canopymod_sub_namdalseid_ub_20x20  <-grid_canopy(sub_namdalseid_ub_cut,res=1)

terrainmod_sub_namdalseid_ub_resampeled_20x20 <- resample(as.raster(terrainmod_sub_namdalseid_ub_20x20), as.raster(canopymod_sub_namdalseid_ub_20x20, method='bilinear'))
canopy_diff_sub_namdalseid_ub_20x20 <- (as.raster(canopymod_sub_namdalseid_ub_20x20)-terrainmod_sub_namdalseid_ub_resampeled_20x20)
plot(canopy_diff_sub_namdalseid_ub_20x20)

writeRaster(canopy_diff_sub_namdalseid_ub_20x20,'Trondelag/canopy_height_clipped_raster/sub_namdalseid_ub_canopyheight', overwrite=TRUE)



# Verdal_1vb --------------------------------------------------------------


# verdal_1vb_b
terrainmod_verdal_1vb_b  <-grid_terrain(verdal_1vb_b, method='knnidw',res=1)
canopymod_verdal_1vb_b   <-grid_canopy(verdal_1vb_b,res=1)

terrainmod_verdal_1vb_b_resampled <-resample(as.raster(terrainmod_verdal_1vb_b), as.raster(canopymod_verdal_1vb_b), method='bilinear')
canopy_diff_verdal_1vb_b<-(as.raster(canopymod_verdal_1vb_b)-terrainmod_verdal_1vb_b_resampled)
plot(canopy_diff_verdal_1vb_b)

trees_verdal_1vb_b<-tree_detection(verdal_1vb_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_verdal_1vb_b<-extract(canopy_diff_verdal_1vb_b,trees_verdal_1vb_b[,1:2])

lastrees_dalponte(verdal_1vb_b,canopy_diff_verdal_1vb_b,trees_verdal_1vb_b[treeheight_verdal_1vb_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_verdal_1vb_b<-tree_hulls(verdal_1vb_b,type='convex',field='treeID')
plot(canopy_diff_verdal_1vb_b)
plot(treeout_verdal_1vb_b,add=T) 

bigtrees_verdal_1vb_b<-which(extract(canopy_diff_verdal_1vb_b,treeout_verdal_1vb_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

verdal_1vb_b_clip<-lasclip(verdal_1vb_b,treeout_verdal_1vb_b@polygons[[bigtrees_verdal_1vb_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_verdal_1vb_b)){
  print(i)
  verdal_1vb_b_clip<-lasclip(verdal_1vb_b_clip,treeout_verdal_1vb_b@polygons[[bigtrees_verdal_1vb_b[i]]]@Polygons[[1]],inside=F)}
plot(verdal_1vb_b_clip) 

canopy_diff_verdal_1vb_b_clip <- (as.raster(grid_canopy(verdal_1vb_b_clip,res=0.5))-(crop(as.raster(grid_terrain(verdal_1vb_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(verdal_1vb_b_clip,res=0.5)))))
plot(canopy_diff_verdal_1vb_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
verdal_1vb_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='1Vbb',4:5]))
verdal_1vb_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='1Vbb',4:5][verdal_1vb_b_order,]))
verdal_1vb_b_cut<-lasclip(verdal_1vb_b_clip,verdal_1vb_b_poly)
plot(verdal_1vb_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_verdal_1vb_b_20x20 <-grid_terrain(verdal_1vb_b_cut,method='knnidw',res=1)
canopymod_verdal_1vb_b_20x20  <-grid_canopy(verdal_1vb_b_cut,res=1)

terrainmod_verdal_1vb_b_resampeled_20x20 <- resample(as.raster(terrainmod_verdal_1vb_b_20x20), as.raster(canopymod_verdal_1vb_b_20x20, method='bilinear'))
canopy_diff_verdal_1vb_b_20x20 <- (as.raster(canopymod_verdal_1vb_b_20x20)-terrainmod_verdal_1vb_b_resampeled_20x20)
plot(canopy_diff_verdal_1vb_b_20x20)

writeRaster(canopy_diff_verdal_1vb_b_20x20,'Trondelag/canopy_height_clipped_raster/verdal_1vb_b_canopyheight', overwrite=TRUE)



# verdal_1vb_ub
terrainmod_verdal_1vb_ub <-grid_terrain(verdal_1vb_ub,method='knnidw',res=1)
canopymod_verdal_1vb_ub  <-grid_canopy(verdal_1vb_ub,res=1)

terrainmod_verdal_1vb_ub_resampeled <- resample(as.raster(terrainmod_verdal_1vb_ub), as.raster(canopymod_verdal_1vb_ub, method='bilinear'))
canopy_diff_verdal_1vb_ub <- (as.raster(canopymod_verdal_1vb_ub)-terrainmod_verdal_1vb_ub_resampeled)
plot(canopy_diff_verdal_1vb_ub)


trees_verdal_1vb_ub<-tree_detection(verdal_1vb_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_verdal_1vb_ub<-extract(canopy_diff_verdal_1vb_ub,trees_verdal_1vb_ub[,1:2])

lastrees_dalponte(verdal_1vb_ub,canopy_diff_verdal_1vb_ub,trees_verdal_1vb_ub[treeheight_verdal_1vb_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_verdal_1vb_ub<-tree_hulls(verdal_1vb_ub,type='convex',field='treeID')
plot(canopy_diff_verdal_1vb_ub)
plot(treeout_verdal_1vb_ub,add=T) 

bigtrees_verdal_1vb_ub<-which(extract(canopy_diff_verdal_1vb_ub,treeout_verdal_1vb_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

verdal_1vb_ub_clip<-lasclip(verdal_1vb_ub,treeout_verdal_1vb_ub@polygons[[bigtrees_verdal_1vb_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_verdal_1vb_ub)){
  print(i)
  verdal_1vb_ub_clip<-lasclip(verdal_1vb_ub_clip,treeout_verdal_1vb_ub@polygons[[bigtrees_verdal_1vb_ub[i]]]@Polygons[[1]],inside=F)}
plot(verdal_1vb_ub_clip) 

canopy_diff_verdal_1vb_ub_clip <- (as.raster(grid_canopy(verdal_1vb_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(verdal_1vb_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(verdal_1vb_ub_clip,res=0.5)))))
plot(canopy_diff_verdal_1vb_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
verdal_1vb_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='1Vbub',4:5]))
verdal_1vb_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='1Vbub',4:5][verdal_1vb_ub_order,]))
verdal_1vb_ub_cut<-lasclip(verdal_1vb_ub_clip,verdal_1vb_ub_poly)
plot(verdal_1vb_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_verdal_1vb_ub_20x20 <-grid_terrain(verdal_1vb_ub_cut,method='knnidw',res=1)
canopymod_verdal_1vb_ub_20x20  <-grid_canopy(verdal_1vb_ub_cut,res=1)

terrainmod_verdal_1vb_ub_resampeled_20x20 <- resample(as.raster(terrainmod_verdal_1vb_ub_20x20), as.raster(canopymod_verdal_1vb_ub_20x20, method='bilinear'))
canopy_diff_verdal_1vb_ub_20x20 <- (as.raster(canopymod_verdal_1vb_ub_20x20)-terrainmod_verdal_1vb_ub_resampeled_20x20)
plot(canopy_diff_verdal_1vb_ub_20x20)

writeRaster(canopy_diff_verdal_1vb_ub_20x20,'Trondelag/canopy_height_clipped_raster/verdal_1vb_ub_canopyheight', overwrite=TRUE)




# Verdal_2vb --------------------------------------------------------------



# Verdal_2vb_b
terrainmod_verdal_2vb_b  <-grid_terrain(verdal_2vb_b, method='knnidw',res=1)
canopymod_verdal_2vb_b   <-grid_canopy(verdal_2vb_b,res=1)

terrainmod_verdal_2vb_b_resampled <-resample(as.raster(terrainmod_verdal_2vb_b), as.raster(canopymod_verdal_2vb_b), method='bilinear')
canopy_diff_verdal_2vb_b<-(as.raster(canopymod_verdal_2vb_b)-terrainmod_verdal_2vb_b_resampled)
plot(canopy_diff_verdal_2vb_b)
canopy_diff_verdal_2vb_b #max 3,257

#Cutting the 32x32m square to 20x20 m
verdal_2vb_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Trondelag/Verdal_2vb.las')
verdal_2vb_b_order<-chull(as.matrix(plotcoords[plotcoords$Name=='2Vbb',4:5]))
verdal_2vb_b_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='2Vbb',4:5][verdal_2vb_b_order,]))
verdal_2vb_b_cut<-lasclip(verdal_2vb_las,verdal_2vb_b_poly)
plot(verdal_2vb_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_verdal_2vb_b_20x20 <-grid_terrain(verdal_2vb_b_cut,method='knnidw',res=1)
canopymod_verdal_2vb_b_20x20  <-grid_canopy(verdal_2vb_b_cut,res=1)

terrainmod_verdal_2vb_b_resampeled_20x20 <- resample(as.raster(terrainmod_verdal_2vb_b_20x20), as.raster(canopymod_verdal_2vb_b_20x20, method='bilinear'))
canopy_diff_verdal_2vb_b_20x20 <- (as.raster(canopymod_verdal_2vb_b_20x20)-terrainmod_verdal_2vb_b_resampeled_20x20)
plot(canopy_diff_verdal_2vb_b_20x20)

writeRaster(canopy_diff_verdal_2vb_b_20x20,'Trondelag/canopy_height_clipped_raster/verdal_2vb_b_canopyheight', overwrite=TRUE)

# Verdal_2vb_ub
terrainmod_verdal_2vb_ub <-grid_terrain(verdal_2vb_ub,method='knnidw',res=1)
canopymod_verdal_2vb_ub  <-grid_canopy(verdal_2vb_ub,res=1)

terrainmod_verdal_2vb_ub_resampeled <- resample(as.raster(terrainmod_verdal_2vb_ub), as.raster(canopymod_verdal_2vb_ub, method='bilinear'))
canopy_diff_verdal_2vb_ub <- (as.raster(canopymod_verdal_2vb_ub)-terrainmod_verdal_2vb_ub_resampeled)
plot(canopy_diff_verdal_2vb_ub)

trees_verdal_2vb_ub<-tree_detection(verdal_2vb_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_verdal_2vb_ub<-extract(canopy_diff_verdal_2vb_ub,trees_verdal_2vb_ub[,1:2])

lastrees_dalponte(verdal_2vb_ub,canopy_diff_verdal_2vb_ub,trees_verdal_2vb_ub[treeheight_verdal_2vb_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_verdal_2vb_ub<-tree_hulls(verdal_2vb_ub,type='convex',field='treeID')
plot(canopy_diff_verdal_2vb_ub)
plot(treeout_verdal_2vb_ub,add=T) 

bigtrees_verdal_2vb_ub<-which(extract(canopy_diff_verdal_2vb_ub,treeout_verdal_2vb_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

verdal_2vb_ub_clip<-lasclip(verdal_2vb_ub,treeout_verdal_2vb_ub@polygons[[bigtrees_verdal_2vb_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_verdal_2vb_ub)){
  print(i)
  verdal_2vb_ub_clip<-lasclip(verdal_2vb_ub_clip,treeout_verdal_2vb_ub@polygons[[bigtrees_verdal_2vb_ub[i]]]@Polygons[[1]],inside=F)}
plot(verdal_2vb_ub_clip) 

canopy_diff_verdal_2vb_ub_clip <- (as.raster(grid_canopy(verdal_2vb_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(verdal_2vb_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(verdal_2vb_ub_clip,res=0.5)))))
plot(canopy_diff_verdal_2vb_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
verdal_2vb_ub_order<-chull(as.matrix(plotcoords[plotcoords$Name=='2Vbub',4:5]))
verdal_2vb_ub_poly<-Polygon(as.matrix(plotcoords[plotcoords$Name=='2Vbub',4:5][verdal_2vb_ub_order,]))
verdal_2vb_ub_cut<-lasclip(verdal_2vb_ub_clip,verdal_2vb_ub_poly)
plot(verdal_2vb_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_verdal_2vb_ub_20x20 <-grid_terrain(verdal_2vb_ub_cut,method='knnidw',res=1)
canopymod_verdal_2vb_ub_20x20  <-grid_canopy(verdal_2vb_ub_cut,res=1)

terrainmod_verdal_2vb_ub_resampeled_20x20 <- resample(as.raster(terrainmod_verdal_2vb_ub_20x20), as.raster(canopymod_verdal_2vb_ub_20x20, method='bilinear'))
canopy_diff_verdal_2vb_ub_20x20 <- (as.raster(canopymod_verdal_2vb_ub_20x20)-terrainmod_verdal_2vb_ub_resampeled_20x20)
plot(canopy_diff_verdal_2vb_ub_20x20)

writeRaster(canopy_diff_verdal_2vb_ub_20x20,'Trondelag/canopy_height_clipped_raster/verdal_2vb_ub_canopyheight', overwrite=TRUE)










# Telemark ----------------------------------------------------------------


# Drangedal1 --------------------------------------------------------------


#Drangedal1_b
terrainmod_drangedal1_b  <-grid_terrain(drangedal1_b, method='knnidw',res=1)
canopymod_drangedal1_b   <-grid_canopy(drangedal1_b,res=1)

terrainmod_drangedal1_b_resampled <-resample(as.raster(terrainmod_drangedal1_b), as.raster(canopymod_drangedal1_b), method='bilinear')
canopy_diff_drangedal1_b<-(as.raster(canopymod_drangedal1_b)-terrainmod_drangedal1_b_resampled)
plot(canopy_diff_drangedal1_b)


trees_drangedal1_b<-tree_detection(drangedal1_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_drangedal1_b<-extract(canopy_diff_drangedal1_b,trees_drangedal1_b[,1:2])

lastrees_dalponte(drangedal1_b,canopy_diff_drangedal1_b,trees_drangedal1_b[treeheight_drangedal1_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_drangedal1_b<-tree_hulls(drangedal1_b,type='convex',field='treeID')
plot(canopy_diff_drangedal1_b)
plot(treeout_drangedal1_b,add=T) 

bigtrees_drangedal1_b<-which(extract(canopy_diff_drangedal1_b,treeout_drangedal1_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

drangedal1_b_clip<-lasclip(drangedal1_b,treeout_drangedal1_b@polygons[[bigtrees_drangedal1_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_drangedal1_b)){
  print(i)
  drangedal1_b_clip<-lasclip(drangedal1_b_clip,treeout_drangedal1_b@polygons[[bigtrees_drangedal1_b[i]]]@Polygons[[1]],inside=F)}
plot(drangedal1_b_clip) 

canopy_diff_drangedal1_b_clip <- (as.raster(grid_canopy(drangedal1_b_clip,res=0.5))-(crop(as.raster(grid_terrain(drangedal1_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(drangedal1_b_clip,res=0.5)))))
plot(canopy_diff_drangedal1_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
drangedal1_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 1 B',10:9]))
drangedal1_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 1 B',10:9][drangedal1_b_order,]))
drangedal1_b_cut<-lasclip(drangedal1_b_clip,drangedal1_b_poly)
plot(drangedal1_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_drangedal1_b_20x20 <-grid_terrain(drangedal1_b_cut,method='knnidw',res=1)
canopymod_drangedal1_b_20x20  <-grid_canopy(drangedal1_b_cut,res=1)

terrainmod_drangedal1_b_resampeled_20x20 <- resample(as.raster(terrainmod_drangedal1_b_20x20), as.raster(canopymod_drangedal1_b_20x20, method='bilinear'))
canopy_diff_drangedal1_b_20x20 <- (as.raster(canopymod_drangedal1_b_20x20)-terrainmod_drangedal1_b_resampeled_20x20)
plot(canopy_diff_drangedal1_b_20x20)

writeRaster(canopy_diff_drangedal1_b_20x20,'Telemark/canopy_height_clipped_raster/drangedal1_b_canopyheight', overwrite=TRUE)



#Drangedal1_ub
terrainmod_drangedal1_ub <-grid_terrain(drangedal1_ub,method='knnidw',res=1)
canopymod_drangedal1_ub  <-grid_canopy(drangedal1_ub,res=1)

terrainmod_drangedal1_ub_resampeled <- resample(as.raster(terrainmod_drangedal1_ub), as.raster(canopymod_drangedal1_ub, method='bilinear'))
canopy_diff_drangedal1_ub <- (as.raster(canopymod_drangedal1_ub)-terrainmod_drangedal1_ub_resampeled)
plot(canopy_diff_drangedal1_ub)

trees_drangedal1_ub<-tree_detection(drangedal1_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_drangedal1_ub<-extract(canopy_diff_drangedal1_ub,trees_drangedal1_ub[,1:2])

lastrees_dalponte(drangedal1_ub,canopy_diff_drangedal1_ub,trees_drangedal1_ub[treeheight_drangedal1_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_drangedal1_ub<-tree_hulls(drangedal1_ub,type='convex',field='treeID')
plot(canopy_diff_drangedal1_ub)
plot(treeout_drangedal1_ub,add=T) 

bigtrees_drangedal1_ub<-which(extract(canopy_diff_drangedal1_ub,treeout_drangedal1_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

drangedal1_ub_clip<-lasclip(drangedal1_ub,treeout_drangedal1_ub@polygons[[bigtrees_drangedal1_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_drangedal1_ub)){
  print(i)
  drangedal1_ub_clip<-lasclip(drangedal1_ub_clip,treeout_drangedal1_ub@polygons[[bigtrees_drangedal1_ub[i]]]@Polygons[[1]],inside=F)}
plot(drangedal1_ub_clip) 

canopy_diff_drangedal1_ub_clip <- (as.raster(grid_canopy(drangedal1_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(drangedal1_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(drangedal1_ub_clip,res=0.5)))))
plot(canopy_diff_drangedal1_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
drangedal1_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 1 UB',10:9]))
drangedal1_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 1 UB',10:9][drangedal1_ub_order,]))
drangedal1_ub_cut<-lasclip(drangedal1_ub_clip,drangedal1_ub_poly)
plot(drangedal1_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_drangedal1_ub_20x20 <-grid_terrain(drangedal1_ub_cut,method='knnidw',res=1)
canopymod_drangedal1_ub_20x20  <-grid_canopy(drangedal1_ub_cut,res=1)

terrainmod_drangedal1_ub_resampeled_20x20 <- resample(as.raster(terrainmod_drangedal1_ub_20x20), as.raster(canopymod_drangedal1_ub_20x20, method='bilinear'))
canopy_diff_drangedal1_ub_20x20 <- (as.raster(canopymod_drangedal1_ub_20x20)-terrainmod_drangedal1_ub_resampeled_20x20)
plot(canopy_diff_drangedal1_ub_20x20)

writeRaster(canopy_diff_drangedal1_ub_20x20,'Telemark/canopy_height_clipped_raster/drangedal1_ub_canopyheight', overwrite=TRUE)



# Drangedal3 --------------------------------------------------------------


#Drangedal3_b
terrainmod_drangedal3_b  <-grid_terrain(drangedal3_b, method='knnidw',res=1)
canopymod_drangedal3_b   <-grid_canopy(drangedal3_b,res=1)

terrainmod_drangedal3_b_resampled <-resample(as.raster(terrainmod_drangedal3_b), as.raster(canopymod_drangedal3_b), method='bilinear')
canopy_diff_drangedal3_b<-(as.raster(canopymod_drangedal3_b)-terrainmod_drangedal3_b_resampled)
plot(canopy_diff_drangedal3_b)

trees_drangedal3_b<-tree_detection(drangedal3_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_drangedal3_b<-extract(canopy_diff_drangedal3_b,trees_drangedal3_b[,1:2])

lastrees_dalponte(drangedal3_b,canopy_diff_drangedal3_b,trees_drangedal3_b[treeheight_drangedal3_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_drangedal3_b<-tree_hulls(drangedal3_b,type='convex',field='treeID')
plot(canopy_diff_drangedal3_b)
plot(treeout_drangedal3_b,add=T) 

bigtrees_drangedal3_b<-which(extract(canopy_diff_drangedal3_b,treeout_drangedal3_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

drangedal3_b_clip<-lasclip(drangedal3_b,treeout_drangedal3_b@polygons[[bigtrees_drangedal3_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_drangedal3_b)){
  print(i)
  drangedal3_b_clip<-lasclip(drangedal3_b_clip,treeout_drangedal3_b@polygons[[bigtrees_drangedal3_b[i]]]@Polygons[[1]],inside=F)}
plot(drangedal3_b_clip) 

canopy_diff_drangedal3_b_clip <- (as.raster(grid_canopy(drangedal3_b_clip,res=0.5))-(crop(as.raster(grid_terrain(drangedal3_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(drangedal3_b_clip,res=0.5)))))
plot(canopy_diff_drangedal3_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
drangedal3_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 3 B',10:9]))
drangedal3_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 3 B',10:9][drangedal3_b_order,]))
drangedal3_b_cut<-lasclip(drangedal3_b_clip,drangedal3_b_poly)
plot(drangedal3_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_drangedal3_b_20x20 <-grid_terrain(drangedal3_b_cut,method='knnidw',res=1)
canopymod_drangedal3_b_20x20  <-grid_canopy(drangedal3_b_cut,res=1)

terrainmod_drangedal3_b_resampeled_20x20 <- resample(as.raster(terrainmod_drangedal3_b_20x20), as.raster(canopymod_drangedal3_b_20x20, method='bilinear'))
canopy_diff_drangedal3_b_20x20 <- (as.raster(canopymod_drangedal3_b_20x20)-terrainmod_drangedal3_b_resampeled_20x20)
plot(canopy_diff_drangedal3_b_20x20)

writeRaster(canopy_diff_drangedal3_b_20x20,'Telemark/canopy_height_clipped_raster/drangedal3_b_canopyheight', overwrite=TRUE)



#Drangedal3_ub
terrainmod_drangedal3_ub <-grid_terrain(drangedal3_ub,method='knnidw',res=1)
canopymod_drangedal3_ub  <-grid_canopy(drangedal3_ub,res=1)

terrainmod_drangedal3_ub_resampeled <- resample(as.raster(terrainmod_drangedal3_ub), as.raster(canopymod_drangedal3_ub, method='bilinear'))
canopy_diff_drangedal3_ub <- (as.raster(canopymod_drangedal3_ub)-terrainmod_drangedal3_ub_resampeled)
plot(canopy_diff_drangedal3_ub)

trees_drangedal3_ub<-tree_detection(drangedal3_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_drangedal3_ub<-extract(canopy_diff_drangedal3_ub,trees_drangedal3_ub[,1:2])

lastrees_dalponte(drangedal3_ub,canopy_diff_drangedal3_ub,trees_drangedal3_ub[treeheight_drangedal3_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_drangedal3_ub<-tree_hulls(drangedal3_ub,type='convex',field='treeID')
plot(canopy_diff_drangedal3_ub)
plot(treeout_drangedal3_ub,add=T) 

bigtrees_drangedal3_ub<-which(extract(canopy_diff_drangedal3_ub,treeout_drangedal3_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

drangedal3_ub_clip<-lasclip(drangedal3_ub,treeout_drangedal3_ub@polygons[[bigtrees_drangedal3_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_drangedal3_ub)){
  print(i)
  drangedal3_ub_clip<-lasclip(drangedal3_ub_clip,treeout_drangedal3_ub@polygons[[bigtrees_drangedal3_ub[i]]]@Polygons[[1]],inside=F)}
plot(drangedal3_ub_clip) 

canopy_diff_drangedal3_ub_clip <- (as.raster(grid_canopy(drangedal3_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(drangedal3_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(drangedal3_ub_clip,res=0.5)))))
plot(canopy_diff_drangedal3_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
drangedal3_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 3 UB',10:9]))
drangedal3_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 3 UB',10:9][drangedal3_ub_order,]))
drangedal3_ub_cut<-lasclip(drangedal3_ub_clip,drangedal3_ub_poly)
plot(drangedal3_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_drangedal3_ub_20x20 <-grid_terrain(drangedal3_ub_cut,method='knnidw',res=1)
canopymod_drangedal3_ub_20x20  <-grid_canopy(drangedal3_ub_cut,res=1)

terrainmod_drangedal3_ub_resampeled_20x20 <- resample(as.raster(terrainmod_drangedal3_ub_20x20), as.raster(canopymod_drangedal3_ub_20x20, method='bilinear'))
canopy_diff_drangedal3_ub_20x20 <- (as.raster(canopymod_drangedal3_ub_20x20)-terrainmod_drangedal3_ub_resampeled_20x20)
plot(canopy_diff_drangedal3_ub_20x20)

writeRaster(canopy_diff_drangedal3_ub_20x20,'Telemark/canopy_height_clipped_raster/drangedal3_ub_canopyheight', overwrite=TRUE)



# Drangedal4 --------------------------------------------------------------


#Drangedal4_b
terrainmod_drangedal4_b  <-grid_terrain(drangedal4_b, method='knnidw',res=1)
canopymod_drangedal4_b   <-grid_canopy(drangedal4_b,res=1)

terrainmod_drangedal4_b_resampled <-resample(as.raster(terrainmod_drangedal4_b), as.raster(canopymod_drangedal4_b), method='bilinear')
canopy_diff_drangedal4_b<-(as.raster(canopymod_drangedal4_b)-terrainmod_drangedal4_b_resampled)
plot(canopy_diff_drangedal4_b)

trees_drangedal4_b<-tree_detection(drangedal4_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_drangedal4_b<-extract(canopy_diff_drangedal4_b,trees_drangedal4_b[,1:2])

lastrees_dalponte(drangedal4_b,canopy_diff_drangedal4_b,trees_drangedal4_b[treeheight_drangedal4_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_drangedal4_b<-tree_hulls(drangedal4_b,type='convex',field='treeID')
plot(canopy_diff_drangedal4_b)
plot(treeout_drangedal4_b,add=T) 

bigtrees_drangedal4_b<-which(extract(canopy_diff_drangedal4_b,treeout_drangedal4_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

drangedal4_b_clip<-lasclip(drangedal4_b,treeout_drangedal4_b@polygons[[bigtrees_drangedal4_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_drangedal4_b)){
  print(i)
  drangedal4_b_clip<-lasclip(drangedal4_b_clip,treeout_drangedal4_b@polygons[[bigtrees_drangedal4_b[i]]]@Polygons[[1]],inside=F)}
plot(drangedal4_b_clip) 

canopy_diff_drangedal4_b_clip <- (as.raster(grid_canopy(drangedal4_b_clip,res=0.5))-(crop(as.raster(grid_terrain(drangedal4_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(drangedal4_b_clip,res=0.5)))))
plot(canopy_diff_drangedal4_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
drangedal4_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 4 B',10:9]))
drangedal4_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 4 B',10:9][drangedal4_b_order,]))
drangedal4_b_cut<-lasclip(drangedal4_b_clip,drangedal4_b_poly)
plot(drangedal4_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_drangedal4_b_20x20 <-grid_terrain(drangedal4_b_cut,method='knnidw',res=1)
canopymod_drangedal4_b_20x20  <-grid_canopy(drangedal4_b_cut,res=1)

terrainmod_drangedal4_b_resampeled_20x20 <- resample(as.raster(terrainmod_drangedal4_b_20x20), as.raster(canopymod_drangedal4_b_20x20, method='bilinear'))
canopy_diff_drangedal4_b_20x20 <- (as.raster(canopymod_drangedal4_b_20x20)-terrainmod_drangedal4_b_resampeled_20x20)
plot(canopy_diff_drangedal4_b_20x20)

writeRaster(canopy_diff_drangedal4_b_20x20,'Telemark/canopy_height_clipped_raster/drangedal4_b_canopyheight', overwrite=TRUE)



#Drangedal4_ub
terrainmod_drangedal4_ub <-grid_terrain(drangedal4_ub,method='knnidw',res=1)
canopymod_drangedal4_ub  <-grid_canopy(drangedal4_ub,res=1)

terrainmod_drangedal4_ub_resampeled <- resample(as.raster(terrainmod_drangedal4_ub), as.raster(canopymod_drangedal4_ub, method='bilinear'))
canopy_diff_drangedal4_ub <- (as.raster(canopymod_drangedal4_ub)-terrainmod_drangedal4_ub_resampeled)
plot(canopy_diff_drangedal4_ub)

trees_drangedal4_ub<-tree_detection(drangedal4_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_drangedal4_ub<-extract(canopy_diff_drangedal4_ub,trees_drangedal4_ub[,1:2])

lastrees_dalponte(drangedal4_ub,canopy_diff_drangedal4_ub,trees_drangedal4_ub[treeheight_drangedal4_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_drangedal4_ub<-tree_hulls(drangedal4_ub,type='convex',field='treeID')
plot(canopy_diff_drangedal4_ub)
plot(treeout_drangedal4_ub,add=T) 

bigtrees_drangedal4_ub<-which(extract(canopy_diff_drangedal4_ub,treeout_drangedal4_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

drangedal4_ub_clip<-lasclip(drangedal4_ub,treeout_drangedal4_ub@polygons[[bigtrees_drangedal4_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_drangedal4_ub)){
  print(i)
  drangedal4_ub_clip<-lasclip(drangedal4_ub_clip,treeout_drangedal4_ub@polygons[[bigtrees_drangedal4_ub[i]]]@Polygons[[1]],inside=F)}
plot(drangedal4_ub_clip) 

canopy_diff_drangedal4_ub_clip <- (as.raster(grid_canopy(drangedal4_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(drangedal4_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(drangedal4_ub_clip,res=0.5)))))
plot(canopy_diff_drangedal4_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
drangedal4_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 4 UB',10:9]))
drangedal4_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Drangedal 4 UB',10:9][drangedal4_ub_order,]))
drangedal4_ub_cut<-lasclip(drangedal4_ub_clip,drangedal4_ub_poly)
plot(drangedal4_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_drangedal4_ub_20x20 <-grid_terrain(drangedal4_ub_cut,method='knnidw',res=1)
canopymod_drangedal4_ub_20x20  <-grid_canopy(drangedal4_ub_cut,res=1)

terrainmod_drangedal4_ub_resampeled_20x20 <- resample(as.raster(terrainmod_drangedal4_ub_20x20), as.raster(canopymod_drangedal4_ub_20x20, method='bilinear'))
canopy_diff_drangedal4_ub_20x20 <- (as.raster(canopymod_drangedal4_ub_20x20)-terrainmod_drangedal4_ub_resampeled_20x20)
plot(canopy_diff_drangedal4_ub_20x20)

writeRaster(canopy_diff_drangedal4_ub_20x20,'Telemark/canopy_height_clipped_raster/drangedal4_ub_canopyheight', overwrite=TRUE)





# Fritsoe2 ----------------------------------------------------------------


# Fritsoe2_b
terrainmod_fritsoe2_b  <-grid_terrain(fritsoe2_b, method='knnidw',res=1)
canopymod_fritsoe2_b   <-grid_canopy(fritsoe2_b,res=1)

terrainmod_fritsoe2_b_resampled <-resample(as.raster(terrainmod_fritsoe2_b), as.raster(canopymod_fritsoe2_b), method='bilinear')
canopy_diff_fritsoe2_b<-(as.raster(canopymod_fritsoe2_b)-terrainmod_fritsoe2_b_resampled)
plot(canopy_diff_fritsoe2_b)

trees_fritsoe2_b<-tree_detection(fritsoe2_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_fritsoe2_b<-extract(canopy_diff_fritsoe2_b,trees_fritsoe2_b[,1:2])

lastrees_dalponte(fritsoe2_b,canopy_diff_fritsoe2_b,trees_fritsoe2_b[treeheight_fritsoe2_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_fritsoe2_b<-tree_hulls(fritsoe2_b,type='convex',field='treeID')
plot(canopy_diff_fritsoe2_b)
plot(treeout_fritsoe2_b,add=T) 

bigtrees_fritsoe2_b<-which(extract(canopy_diff_fritsoe2_b,treeout_fritsoe2_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

fritsoe2_b_clip<-lasclip(fritsoe2_b,treeout_fritsoe2_b@polygons[[bigtrees_fritsoe2_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_fritsoe2_b)){
  print(i)
  fritsoe2_b_clip<-lasclip(fritsoe2_b_clip,treeout_fritsoe2_b@polygons[[bigtrees_fritsoe2_b[i]]]@Polygons[[1]],inside=F)}
plot(fritsoe2_b_clip) 

canopy_diff_fritsoe2_b_clip <- (as.raster(grid_canopy(fritsoe2_b_clip,res=0.5))-(crop(as.raster(grid_terrain(fritsoe2_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(fritsoe2_b_clip,res=0.5)))))
plot(canopy_diff_fritsoe2_b_clip)


#Cutting the 32x32m square(with big trees removed) to 20x20 m
fritsoe2_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fritzøe 2 B',10:9]))
fritsoe2_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fritzøe 2 B',10:9][fritsoe2_b_order,]))
fritsoe2_b_cut<-lasclip(fritsoe2_b_clip,fritsoe2_b_poly)
plot(fritsoe2_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_fritsoe2_b_20x20 <-grid_terrain(fritsoe2_b_cut,method='knnidw',res=1)
canopymod_fritsoe2_b_20x20  <-grid_canopy(fritsoe2_b_cut,res=1)

terrainmod_fritsoe2_b_resampeled_20x20 <- resample(as.raster(terrainmod_fritsoe2_b_20x20), as.raster(canopymod_fritsoe2_b_20x20, method='bilinear'))
canopy_diff_fritsoe2_b_20x20 <- (as.raster(canopymod_fritsoe2_b_20x20)-terrainmod_fritsoe2_b_resampeled_20x20)
plot(canopy_diff_fritsoe2_b_20x20)

writeRaster(canopy_diff_fritsoe2_b_20x20,'Telemark/canopy_height_clipped_raster/fritsoe2_b_canopyheight', overwrite=TRUE)





# Fritsoe2_ub
terrainmod_fritsoe2_ub <-grid_terrain(fritsoe2_ub,method='knnidw',res=1)
canopymod_fritsoe2_ub  <-grid_canopy(fritsoe2_ub,res=1)

terrainmod_fritsoe2_ub_resampeled <- resample(as.raster(terrainmod_fritsoe2_ub), as.raster(canopymod_fritsoe2_ub, method='bilinear'))
canopy_diff_fritsoe2_ub <- (as.raster(canopymod_fritsoe2_ub)-terrainmod_fritsoe2_ub_resampeled)
plot(canopy_diff_fritsoe2_ub)

trees_fritsoe2_ub<-tree_detection(fritsoe2_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_fritsoe2_ub<-extract(canopy_diff_fritsoe2_ub,trees_fritsoe2_ub[,1:2])

lastrees_dalponte(fritsoe2_ub,canopy_diff_fritsoe2_ub,trees_fritsoe2_ub[treeheight_fritsoe2_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_fritsoe2_ub<-tree_hulls(fritsoe2_ub,type='convex',field='treeID')
plot(canopy_diff_fritsoe2_ub)
plot(treeout_fritsoe2_ub,add=T) 

bigtrees_fritsoe2_ub<-which(extract(canopy_diff_fritsoe2_ub,treeout_fritsoe2_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

fritsoe2_ub_clip<-lasclip(fritsoe2_ub,treeout_fritsoe2_ub@polygons[[bigtrees_fritsoe2_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_fritsoe2_ub)){
  print(i)
  fritsoe2_ub_clip<-lasclip(fritsoe2_ub_clip,treeout_fritsoe2_ub@polygons[[bigtrees_fritsoe2_ub[i]]]@Polygons[[1]],inside=F)}
plot(fritsoe2_ub_clip) 

canopy_diff_fritsoe2_ub_clip <- (as.raster(grid_canopy(fritsoe2_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(fritsoe2_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(fritsoe2_ub_clip,res=0.5)))))
plot(canopy_diff_fritsoe2_ub_clip)


#Cutting the 32x32m square(with big trees removed) to 20x20 m
fritsoe2_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fritzøe 2 UB',10:9]))
fritsoe2_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fritzøe 2 UB',10:9][fritsoe2_ub_order,]))
fritsoe2_ub_cut<-lasclip(fritsoe2_ub_clip,fritsoe2_ub_poly)
plot(fritsoe2_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_fritsoe2_ub_20x20 <-grid_terrain(fritsoe2_ub_cut,method='knnidw',res=1)
canopymod_fritsoe2_ub_20x20  <-grid_canopy(fritsoe2_ub_cut,res=1)

terrainmod_fritsoe2_ub_resampeled_20x20 <- resample(as.raster(terrainmod_fritsoe2_ub_20x20), as.raster(canopymod_fritsoe2_ub_20x20, method='bilinear'))
canopy_diff_fritsoe2_ub_20x20 <- (as.raster(canopymod_fritsoe2_ub_20x20)-terrainmod_fritsoe2_ub_resampeled_20x20)
plot(canopy_diff_fritsoe2_ub_20x20)

writeRaster(canopy_diff_fritsoe2_ub_20x20,'Telemark/canopy_height_clipped_raster/fritsoe2_ub_canopyheight', overwrite=TRUE)




# Fritsoe1 ----------------------------------------------------------------


# Fritsoe1_b
terrainmod_fritsoe1_b  <-grid_terrain(fritsoe1_b, method='knnidw',res=1)
canopymod_fritsoe1_b   <-grid_canopy(fritsoe1_b,res=1)

terrainmod_fritsoe1_b_resampled <-resample(as.raster(terrainmod_fritsoe1_b), as.raster(canopymod_fritsoe1_b), method='bilinear')
canopy_diff_fritsoe1_b<-(as.raster(canopymod_fritsoe1_b)-terrainmod_fritsoe1_b_resampled)
plot(canopy_diff_fritsoe1_b)


trees_fritsoe1_b<-tree_detection(fritsoe1_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_fritsoe1_b<-extract(canopy_diff_fritsoe1_b,trees_fritsoe1_b[,1:2])

lastrees_dalponte(fritsoe1_b,canopy_diff_fritsoe1_b,trees_fritsoe1_b[treeheight_fritsoe1_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_fritsoe1_b<-tree_hulls(fritsoe1_b,type='convex',field='treeID')
plot(canopy_diff_fritsoe1_b)
plot(treeout_fritsoe1_b,add=T) 

bigtrees_fritsoe1_b<-which(extract(canopy_diff_fritsoe1_b,treeout_fritsoe1_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

fritsoe1_b_clip<-lasclip(fritsoe1_b,treeout_fritsoe1_b@polygons[[bigtrees_fritsoe1_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_fritsoe1_b)){
  print(i)
  fritsoe1_b_clip<-lasclip(fritsoe1_b_clip,treeout_fritsoe1_b@polygons[[bigtrees_fritsoe1_b[i]]]@Polygons[[1]],inside=F)}
plot(fritsoe1_b_clip) 

canopy_diff_fritsoe1_b_clip <- (as.raster(grid_canopy(fritsoe1_b_clip,res=0.5))-(crop(as.raster(grid_terrain(fritsoe1_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(fritsoe1_b_clip,res=0.5)))))
plot(canopy_diff_fritsoe1_b_clip)


#Cutting the 32x32m square(with big trees removed) to 20x20 m
fritsoe1_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fritzøe 1 B',10:9]))
fritsoe1_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fritzøe 1 B',10:9][fritsoe1_b_order,]))
fritsoe1_b_cut<-lasclip(fritsoe1_b_clip,fritsoe1_b_poly)
plot(fritsoe1_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_fritsoe1_b_20x20 <-grid_terrain(fritsoe1_b_cut,method='knnidw',res=1)
canopymod_fritsoe1_b_20x20  <-grid_canopy(fritsoe1_b_cut,res=1)

terrainmod_fritsoe1_b_resampeled_20x20 <- resample(as.raster(terrainmod_fritsoe1_b_20x20), as.raster(canopymod_fritsoe1_b_20x20, method='bilinear'))
canopy_diff_fritsoe1_b_20x20 <- (as.raster(canopymod_fritsoe1_b_20x20)-terrainmod_fritsoe1_b_resampeled_20x20)
plot(canopy_diff_fritsoe1_b_20x20)

writeRaster(canopy_diff_fritsoe1_b_20x20,'Telemark/canopy_height_clipped_raster/fritsoe1_b_canopyheight', overwrite=TRUE)


# Fritsoe1_ub
terrainmod_fritsoe1_ub <-grid_terrain(fritsoe1_ub,method='knnidw',res=1)
canopymod_fritsoe1_ub  <-grid_canopy(fritsoe1_ub,res=1)


terrainmod_fritsoe1_ub_resampeled <- resample(as.raster(terrainmod_fritsoe1_ub), as.raster(canopymod_fritsoe1_ub, method='bilinear'))
canopy_diff_fritsoe1_ub <- (as.raster(canopymod_fritsoe1_ub)-terrainmod_fritsoe1_ub_resampeled)
plot(canopy_diff_fritsoe1_ub)
canopy_diff_fritsoe1_ub #mac 4,8

#Cutting the 32x32m square(with big trees removed) to 20x20 m
fritsoe1_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Telemark/Fritsoe1.las')
fritsoe1_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fritzøe 1 UB',10:9]))
fritsoe1_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fritzøe 1 UB',10:9][fritsoe1_ub_order,]))
fritsoe1_ub_cut<-lasclip(fritsoe1_las,fritsoe1_ub_poly)
plot(fritsoe1_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_fritsoe1_ub_20x20 <-grid_terrain(fritsoe1_ub_cut,method='knnidw',res=1)
canopymod_fritsoe1_ub_20x20  <-grid_canopy(fritsoe1_ub_cut,res=1)

terrainmod_fritsoe1_ub_resampeled_20x20 <- resample(as.raster(terrainmod_fritsoe1_ub_20x20), as.raster(canopymod_fritsoe1_ub_20x20, method='bilinear'))
canopy_diff_fritsoe1_ub_20x20 <- (as.raster(canopymod_fritsoe1_ub_20x20)-terrainmod_fritsoe1_ub_resampeled_20x20)
plot(canopy_diff_fritsoe1_ub_20x20)

writeRaster(canopy_diff_fritsoe1_ub_20x20,'Telemark/canopy_height_clipped_raster/fritsoe1_ub_canopyheight', overwrite=TRUE)



# Fyresdal ----------------------------------------------------------------


# Fyresdal_b
terrainmod_fyresdal_b  <-grid_terrain(fyresdal_b, method='knnidw',res=1)
canopymod_fyresdal_b   <-grid_canopy(fyresdal_b,res=1)

terrainmod_fyresdal_b_resampled <-resample(as.raster(terrainmod_fyresdal_b), as.raster(canopymod_fyresdal_b), method='bilinear')
canopy_diff_fyresdal_b<-(as.raster(canopymod_fyresdal_b)-terrainmod_fyresdal_b_resampled)
plot(canopy_diff_fyresdal_b)

trees_fyresdal_b<-tree_detection(fyresdal_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_fyresdal_b<-extract(canopy_diff_fyresdal_b,trees_fyresdal_b[,1:2])

lastrees_dalponte(fyresdal_b,canopy_diff_fyresdal_b,trees_fyresdal_b[treeheight_fyresdal_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_fyresdal_b<-tree_hulls(fyresdal_b,type='convex',field='treeID')
plot(canopy_diff_fyresdal_b)
plot(treeout_fyresdal_b,add=T) 

bigtrees_fyresdal_b<-which(extract(canopy_diff_fyresdal_b,treeout_fyresdal_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

fyresdal_b_clip<-lasclip(fyresdal_b,treeout_fyresdal_b@polygons[[bigtrees_fyresdal_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_fyresdal_b)){
  print(i)
  fyresdal_b_clip<-lasclip(fyresdal_b_clip,treeout_fyresdal_b@polygons[[bigtrees_fyresdal_b[i]]]@Polygons[[1]],inside=F)}
plot(fyresdal_b_clip) 

canopy_diff_fyresdal_b_clip <- (as.raster(grid_canopy(fyresdal_b_clip,res=0.5))-(crop(as.raster(grid_terrain(fyresdal_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(fyresdal_b_clip,res=0.5)))))
plot(canopy_diff_fyresdal_b_clip)


#Cutting the 32x32m square(with big trees removed) to 20x20 m
fyresdal_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fyresdal 1 B',10:9]))
fyresdal_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fyresdal 1 B',10:9][fyresdal_b_order,]))
fyresdal_b_cut<-lasclip(fyresdal_b_clip,fyresdal_b_poly)
plot(fyresdal_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_fyresdal_b_20x20 <-grid_terrain(fyresdal_b_cut,method='knnidw',res=1)
canopymod_fyresdal_b_20x20  <-grid_canopy(fyresdal_b_cut,res=1)

terrainmod_fyresdal_b_resampeled_20x20 <- resample(as.raster(terrainmod_fyresdal_b_20x20), as.raster(canopymod_fyresdal_b_20x20, method='bilinear'))
canopy_diff_fyresdal_b_20x20 <- (as.raster(canopymod_fyresdal_b_20x20)-terrainmod_fyresdal_b_resampeled_20x20)
plot(canopy_diff_fyresdal_b_20x20)

writeRaster(canopy_diff_fyresdal_b_20x20,'Telemark/canopy_height_clipped_raster/fyresdal_b_canopyheight', overwrite=TRUE)



# Fyresdal_ub
terrainmod_fyresdal_ub <-grid_terrain(fyresdal_ub,method='knnidw',res=1)
canopymod_fyresdal_ub  <-grid_canopy(fyresdal_ub,res=1)

terrainmod_fyresdal_ub_resampeled <- resample(as.raster(terrainmod_fyresdal_ub), as.raster(canopymod_fyresdal_ub, method='bilinear'))
canopy_diff_fyresdal_ub <- (as.raster(canopymod_fyresdal_ub)-terrainmod_fyresdal_ub_resampeled)
plot(canopy_diff_fyresdal_ub)

trees_fyresdal_ub<-tree_detection(fyresdal_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_fyresdal_ub<-extract(canopy_diff_fyresdal_ub,trees_fyresdal_ub[,1:2])

lastrees_dalponte(fyresdal_ub,canopy_diff_fyresdal_ub,trees_fyresdal_ub[treeheight_fyresdal_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_fyresdal_ub<-tree_hulls(fyresdal_ub,type='convex',field='treeID')
plot(canopy_diff_fyresdal_ub)
plot(treeout_fyresdal_ub,add=T) 

bigtrees_fyresdal_ub<-which(extract(canopy_diff_fyresdal_ub,treeout_fyresdal_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

fyresdal_ub_clip<-lasclip(fyresdal_ub,treeout_fyresdal_ub@polygons[[bigtrees_fyresdal_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_fyresdal_ub)){
  print(i)
  fyresdal_ub_clip<-lasclip(fyresdal_ub_clip,treeout_fyresdal_ub@polygons[[bigtrees_fyresdal_ub[i]]]@Polygons[[1]],inside=F)}
plot(fyresdal_ub_clip) 

canopy_diff_fyresdal_ub_clip <- (as.raster(grid_canopy(fyresdal_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(fyresdal_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(fyresdal_ub_clip,res=0.5)))))
plot(canopy_diff_fyresdal_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
fyresdal_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fyresdal 1 UB',10:9]))
fyresdal_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Fyresdal 1 UB',10:9][fyresdal_ub_order,]))
fyresdal_ub_cut<-lasclip(fyresdal_ub_clip,fyresdal_ub_poly)
plot(fyresdal_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_fyresdal_ub_20x20 <-grid_terrain(fyresdal_ub_cut,method='knnidw',res=1)
canopymod_fyresdal_ub_20x20  <-grid_canopy(fyresdal_ub_cut,res=1)

terrainmod_fyresdal_ub_resampeled_20x20 <- resample(as.raster(terrainmod_fyresdal_ub_20x20), as.raster(canopymod_fyresdal_ub_20x20, method='bilinear'))
canopy_diff_fyresdal_ub_20x20 <- (as.raster(canopymod_fyresdal_ub_20x20)-terrainmod_fyresdal_ub_resampeled_20x20)
plot(canopy_diff_fyresdal_ub_20x20)

writeRaster(canopy_diff_fyresdal_ub_20x20,'Telemark/canopy_height_clipped_raster/fyresdal_ub_canopyheight', overwrite=TRUE)


# Kviteseid1 --------------------------------------------------------------


# kviteseid1_b
terrainmod_kviteseid1_b  <-grid_terrain(kviteseid1_b, method='knnidw',res=1)
canopymod_kviteseid1_b   <-grid_canopy(kviteseid1_b,res=1)

terrainmod_kviteseid1_b_resampled <-resample(as.raster(terrainmod_kviteseid1_b), as.raster(canopymod_kviteseid1_b), method='bilinear')
canopy_diff_kviteseid1_b<-(as.raster(canopymod_kviteseid1_b)-terrainmod_kviteseid1_b_resampled)
plot(canopy_diff_kviteseid1_b)

trees_kviteseid1_b<-tree_detection(kviteseid1_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_kviteseid1_b<-extract(canopy_diff_kviteseid1_b,trees_kviteseid1_b[,1:2])

lastrees_dalponte(kviteseid1_b,canopy_diff_kviteseid1_b,trees_kviteseid1_b[treeheight_kviteseid1_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_kviteseid1_b<-tree_hulls(kviteseid1_b,type='convex',field='treeID')
plot(canopy_diff_kviteseid1_b)
plot(treeout_kviteseid1_b,add=T) 

bigtrees_kviteseid1_b<-which(extract(canopy_diff_kviteseid1_b,treeout_kviteseid1_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

kviteseid1_b_clip<-lasclip(kviteseid1_b,treeout_kviteseid1_b@polygons[[bigtrees_kviteseid1_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_kviteseid1_b)){
  print(i)
  kviteseid1_b_clip<-lasclip(kviteseid1_b_clip,treeout_kviteseid1_b@polygons[[bigtrees_kviteseid1_b[i]]]@Polygons[[1]],inside=F)}
plot(kviteseid1_b_clip) 

canopy_diff_kviteseid1_b_clip <- (as.raster(grid_canopy(kviteseid1_b_clip,res=0.5))-(crop(as.raster(grid_terrain(kviteseid1_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(kviteseid1_b_clip,res=0.5)))))
plot(canopy_diff_kviteseid1_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
kviteseid1_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 1 B',10:9]))
kviteseid1_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 1 B',10:9][kviteseid1_b_order,]))
kviteseid1_b_cut<-lasclip(kviteseid1_b_clip,kviteseid1_b_poly)
plot(kviteseid1_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_kviteseid1_b_20x20 <-grid_terrain(kviteseid1_b_cut,method='knnidw',res=1)
canopymod_kviteseid1_b_20x20  <-grid_canopy(kviteseid1_b_cut,res=1)

terrainmod_kviteseid1_b_resampeled_20x20 <- resample(as.raster(terrainmod_kviteseid1_b_20x20), as.raster(canopymod_kviteseid1_b_20x20, method='bilinear'))
canopy_diff_kviteseid1_b_20x20 <- (as.raster(canopymod_kviteseid1_b_20x20)-terrainmod_kviteseid1_b_resampeled_20x20)
plot(canopy_diff_kviteseid1_b_20x20)

writeRaster(canopy_diff_kviteseid1_b_20x20,'Telemark/canopy_height_clipped_raster/kviteseid1_b_canopyheight', overwrite=TRUE)



#kviteseid1_ub
terrainmod_kviteseid1_ub <-grid_terrain(kviteseid1_ub,method='knnidw',res=1)
canopymod_kviteseid1_ub  <-grid_canopy(kviteseid1_ub,res=1)

terrainmod_kviteseid1_ub_resampeled <- resample(as.raster(terrainmod_kviteseid1_ub), as.raster(canopymod_kviteseid1_ub, method='bilinear'))
canopy_diff_kviteseid1_ub <- (as.raster(canopymod_kviteseid1_ub)-terrainmod_kviteseid1_ub_resampeled)
plot(canopy_diff_kviteseid1_ub)


trees_kviteseid1_ub<-tree_detection(kviteseid1_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_kviteseid1_ub<-extract(canopy_diff_kviteseid1_ub,trees_kviteseid1_ub[,1:2])

lastrees_dalponte(kviteseid1_ub,canopy_diff_kviteseid1_ub,trees_kviteseid1_ub[treeheight_kviteseid1_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_kviteseid1_ub<-tree_hulls(kviteseid1_ub,type='convex',field='treeID')
plot(canopy_diff_kviteseid1_ub)
plot(treeout_kviteseid1_ub,add=T) 

bigtrees_kviteseid1_ub<-which(extract(canopy_diff_kviteseid1_ub,treeout_kviteseid1_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

kviteseid1_ub_clip<-lasclip(kviteseid1_ub,treeout_kviteseid1_ub@polygons[[bigtrees_kviteseid1_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_kviteseid1_ub)){
  print(i)
  kviteseid1_ub_clip<-lasclip(kviteseid1_ub_clip,treeout_kviteseid1_ub@polygons[[bigtrees_kviteseid1_ub[i]]]@Polygons[[1]],inside=F)}
plot(kviteseid1_ub_clip) 

canopy_diff_kviteseid1_ub_clip <- (as.raster(grid_canopy(kviteseid1_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(kviteseid1_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(kviteseid1_ub_clip,res=0.5)))))
plot(canopy_diff_kviteseid1_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
kviteseid1_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 1 UB',10:9]))
kviteseid1_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 1 UB',10:9][kviteseid1_ub_order,]))
kviteseid1_ub_cut<-lasclip(kviteseid1_ub_clip,kviteseid1_ub_poly)
plot(kviteseid1_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_kviteseid1_ub_20x20 <-grid_terrain(kviteseid1_ub_cut,method='knnidw',res=1)
canopymod_kviteseid1_ub_20x20  <-grid_canopy(kviteseid1_ub_cut,res=1)

terrainmod_kviteseid1_ub_resampeled_20x20 <- resample(as.raster(terrainmod_kviteseid1_ub_20x20), as.raster(canopymod_kviteseid1_ub_20x20, method='bilinear'))
canopy_diff_kviteseid1_ub_20x20 <- (as.raster(canopymod_kviteseid1_ub_20x20)-terrainmod_kviteseid1_ub_resampeled_20x20)
plot(canopy_diff_kviteseid1_ub_20x20)

writeRaster(canopy_diff_kviteseid1_ub_20x20,'Telemark/canopy_height_clipped_raster/kviteseid1_ub_canopyheight', overwrite=TRUE)


# Kviteseid2 --------------------------------------------------------------


# kviteseid2_b
terrainmod_kviteseid2_b  <-grid_terrain(kviteseid2_b, method='knnidw',res=1)
canopymod_kviteseid2_b   <-grid_canopy(kviteseid2_b,res=1)

terrainmod_kviteseid2_b_resampled <-resample(as.raster(terrainmod_kviteseid2_b), as.raster(canopymod_kviteseid2_b), method='bilinear')
canopy_diff_kviteseid2_b<-(as.raster(canopymod_kviteseid2_b)-terrainmod_kviteseid2_b_resampled)
plot(canopy_diff_kviteseid2_b)

trees_kviteseid2_b<-tree_detection(kviteseid2_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_kviteseid2_b<-extract(canopy_diff_kviteseid2_b,trees_kviteseid2_b[,1:2])

lastrees_dalponte(kviteseid2_b,canopy_diff_kviteseid2_b,trees_kviteseid2_b[treeheight_kviteseid2_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_kviteseid2_b<-tree_hulls(kviteseid2_b,type='convex',field='treeID')
plot(canopy_diff_kviteseid2_b)
plot(treeout_kviteseid2_b,add=T) 

bigtrees_kviteseid2_b<-which(extract(canopy_diff_kviteseid2_b,treeout_kviteseid2_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

kviteseid2_b_clip<-lasclip(kviteseid2_b,treeout_kviteseid2_b@polygons[[bigtrees_kviteseid2_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_kviteseid2_b)){
  print(i)
  kviteseid2_b_clip<-lasclip(kviteseid2_b_clip,treeout_kviteseid2_b@polygons[[bigtrees_kviteseid2_b[i]]]@Polygons[[1]],inside=F)}
plot(kviteseid2_b_clip) 

canopy_diff_kviteseid2_b_clip <- (as.raster(grid_canopy(kviteseid2_b_clip,res=0.5))-(crop(as.raster(grid_terrain(kviteseid2_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(kviteseid2_b_clip,res=0.5)))))
plot(canopy_diff_kviteseid2_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
kviteseid2_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 2 B',10:9]))
kviteseid2_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 2 B',10:9][kviteseid2_b_order,]))
kviteseid2_b_cut<-lasclip(kviteseid2_b_clip,kviteseid2_b_poly)
plot(kviteseid2_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_kviteseid2_b_20x20 <-grid_terrain(kviteseid2_b_cut,method='knnidw',res=1)
canopymod_kviteseid2_b_20x20  <-grid_canopy(kviteseid2_b_cut,res=1)

terrainmod_kviteseid2_b_resampeled_20x20 <- resample(as.raster(terrainmod_kviteseid2_b_20x20), as.raster(canopymod_kviteseid2_b_20x20, method='bilinear'))
canopy_diff_kviteseid2_b_20x20 <- (as.raster(canopymod_kviteseid2_b_20x20)-terrainmod_kviteseid2_b_resampeled_20x20)
plot(canopy_diff_kviteseid2_b_20x20)

writeRaster(canopy_diff_kviteseid2_b_20x20,'Telemark/canopy_height_clipped_raster/kviteseid2_b_canopyheight', overwrite=TRUE)



# kviteseid2_ub
terrainmod_kviteseid2_ub <-grid_terrain(kviteseid2_ub,method='knnidw',res=1)
canopymod_kviteseid2_ub  <-grid_canopy(kviteseid2_ub,res=1)

terrainmod_kviteseid2_ub_resampeled <- resample(as.raster(terrainmod_kviteseid2_ub), as.raster(canopymod_kviteseid2_ub, method='bilinear'))
canopy_diff_kviteseid2_ub <- (as.raster(canopymod_kviteseid2_ub)-terrainmod_kviteseid2_ub_resampeled)
plot(canopy_diff_kviteseid2_ub)

trees_kviteseid2_ub<-tree_detection(kviteseid2_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_kviteseid2_ub<-extract(canopy_diff_kviteseid2_ub,trees_kviteseid2_ub[,1:2])

lastrees_dalponte(kviteseid2_ub,canopy_diff_kviteseid2_ub,trees_kviteseid2_ub[treeheight_kviteseid2_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_kviteseid2_ub<-tree_hulls(kviteseid2_ub,type='convex',field='treeID')
plot(canopy_diff_kviteseid2_ub)
plot(treeout_kviteseid2_ub,add=T) 

bigtrees_kviteseid2_ub<-which(extract(canopy_diff_kviteseid2_ub,treeout_kviteseid2_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

kviteseid2_ub_clip<-lasclip(kviteseid2_ub,treeout_kviteseid2_ub@polygons[[bigtrees_kviteseid2_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_kviteseid2_ub)){
  print(i)
  kviteseid2_ub_clip<-lasclip(kviteseid2_ub_clip,treeout_kviteseid2_ub@polygons[[bigtrees_kviteseid2_ub[i]]]@Polygons[[1]],inside=F)}
plot(kviteseid2_ub_clip) 

canopy_diff_kviteseid2_ub_clip <- (as.raster(grid_canopy(kviteseid2_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(kviteseid2_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(kviteseid2_ub_clip,res=0.5)))))
plot(canopy_diff_kviteseid2_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
kviteseid2_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 2 UB',10:9]))
kviteseid2_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 2 UB',10:9][kviteseid2_ub_order,]))
kviteseid2_ub_cut<-lasclip(kviteseid2_ub_clip,kviteseid2_ub_poly)
plot(kviteseid2_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_kviteseid2_ub_20x20 <-grid_terrain(kviteseid2_ub_cut,method='knnidw',res=1)
canopymod_kviteseid2_ub_20x20  <-grid_canopy(kviteseid2_ub_cut,res=1)

terrainmod_kviteseid2_ub_resampeled_20x20 <- resample(as.raster(terrainmod_kviteseid2_ub_20x20), as.raster(canopymod_kviteseid2_ub_20x20, method='bilinear'))
canopy_diff_kviteseid2_ub_20x20 <- (as.raster(canopymod_kviteseid2_ub_20x20)-terrainmod_kviteseid2_ub_resampeled_20x20)
plot(canopy_diff_kviteseid2_ub_20x20)

writeRaster(canopy_diff_kviteseid2_ub_20x20,'Telemark/canopy_height_clipped_raster/kviteseid2_ub_canopyheight', overwrite=TRUE)



# Kviteseid3 --------------------------------------------------------------


# kviteseid3_b
terrainmod_kviteseid3_b  <-grid_terrain(kviteseid3_b, method='knnidw',res=1)
canopymod_kviteseid3_b   <-grid_canopy(kviteseid3_b,res=1)

terrainmod_kviteseid3_b_resampled <-resample(as.raster(terrainmod_kviteseid3_b), as.raster(canopymod_kviteseid3_b), method='bilinear')
canopy_diff_kviteseid3_b<-(as.raster(canopymod_kviteseid3_b)-terrainmod_kviteseid3_b_resampled)
plot(canopy_diff_kviteseid3_b)

trees_kviteseid3_b<-tree_detection(kviteseid3_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_kviteseid3_b<-extract(canopy_diff_kviteseid3_b,trees_kviteseid3_b[,1:2])

lastrees_dalponte(kviteseid3_b,canopy_diff_kviteseid3_b,trees_kviteseid3_b[treeheight_kviteseid3_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_kviteseid3_b<-tree_hulls(kviteseid3_b,type='convex',field='treeID')
plot(canopy_diff_kviteseid3_b)
plot(treeout_kviteseid3_b,add=T) 

bigtrees_kviteseid3_b<-which(extract(canopy_diff_kviteseid3_b,treeout_kviteseid3_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

kviteseid3_b_clip<-lasclip(kviteseid3_b,treeout_kviteseid3_b@polygons[[bigtrees_kviteseid3_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_kviteseid3_b)){
  print(i)
  kviteseid3_b_clip<-lasclip(kviteseid3_b_clip,treeout_kviteseid3_b@polygons[[bigtrees_kviteseid3_b[i]]]@Polygons[[1]],inside=F)}
plot(kviteseid3_b_clip) 

canopy_diff_kviteseid3_b_clip <- (as.raster(grid_canopy(kviteseid3_b_clip,res=0.5))-(crop(as.raster(grid_terrain(kviteseid3_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(kviteseid3_b_clip,res=0.5)))))
plot(canopy_diff_kviteseid3_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
kviteseid3_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 3 B',10:9]))
kviteseid3_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 3 B',10:9][kviteseid3_b_order,]))
kviteseid3_b_cut<-lasclip(kviteseid3_b_clip,kviteseid3_b_poly)
plot(kviteseid3_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_kviteseid3_b_20x20 <-grid_terrain(kviteseid3_b_cut,method='knnidw',res=1)
canopymod_kviteseid3_b_20x20  <-grid_canopy(kviteseid3_b_cut,res=1)

terrainmod_kviteseid3_b_resampeled_20x20 <- resample(as.raster(terrainmod_kviteseid3_b_20x20), as.raster(canopymod_kviteseid3_b_20x20, method='bilinear'))
canopy_diff_kviteseid3_b_20x20 <- (as.raster(canopymod_kviteseid3_b_20x20)-terrainmod_kviteseid3_b_resampeled_20x20)
plot(canopy_diff_kviteseid3_b_20x20)

writeRaster(canopy_diff_kviteseid3_b_20x20,'Telemark/canopy_height_clipped_raster/kviteseid3_b_canopyheight', overwrite=TRUE)


# kviteseid3_ub
terrainmod_kviteseid3_ub <-grid_terrain(kviteseid3_ub,method='knnidw',res=1)
canopymod_kviteseid3_ub  <-grid_canopy(kviteseid3_ub,res=1)


terrainmod_kviteseid3_ub_resampeled <- resample(as.raster(terrainmod_kviteseid3_ub), as.raster(canopymod_kviteseid3_ub, method='bilinear'))
canopy_diff_kviteseid3_ub <- (as.raster(canopymod_kviteseid3_ub)-terrainmod_kviteseid3_ub_resampeled)
plot(canopy_diff_kviteseid3_ub)

trees_kviteseid3_ub<-tree_detection(kviteseid3_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_kviteseid3_ub<-extract(canopy_diff_kviteseid3_ub,trees_kviteseid3_ub[,1:2])

lastrees_dalponte(kviteseid3_ub,canopy_diff_kviteseid3_ub,trees_kviteseid3_ub[treeheight_kviteseid3_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_kviteseid3_ub<-tree_hulls(kviteseid3_ub,type='convex',field='treeID')
plot(canopy_diff_kviteseid3_ub)
plot(treeout_kviteseid3_ub,add=T) 

bigtrees_kviteseid3_ub<-which(extract(canopy_diff_kviteseid3_ub,treeout_kviteseid3_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

kviteseid3_ub_clip<-lasclip(kviteseid3_ub,treeout_kviteseid3_ub@polygons[[bigtrees_kviteseid3_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_kviteseid3_ub)){
  print(i)
  kviteseid3_ub_clip<-lasclip(kviteseid3_ub_clip,treeout_kviteseid3_ub@polygons[[bigtrees_kviteseid3_ub[i]]]@Polygons[[1]],inside=F)}
plot(kviteseid3_ub_clip) 

canopy_diff_kviteseid3_ub_clip <- (as.raster(grid_canopy(kviteseid3_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(kviteseid3_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(kviteseid3_ub_clip,res=0.5)))))
plot(canopy_diff_kviteseid3_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
kviteseid3_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 3 UB',10:9]))
kviteseid3_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Kviteseid 3 UB',10:9][kviteseid3_ub_order,]))
kviteseid3_ub_cut<-lasclip(kviteseid3_ub_clip,kviteseid3_ub_poly)
plot(kviteseid3_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_kviteseid3_ub_20x20 <-grid_terrain(kviteseid3_ub_cut,method='knnidw',res=1)
canopymod_kviteseid3_ub_20x20  <-grid_canopy(kviteseid3_ub_cut,res=1)

terrainmod_kviteseid3_ub_resampeled_20x20 <- resample(as.raster(terrainmod_kviteseid3_ub_20x20), as.raster(canopymod_kviteseid3_ub_20x20, method='bilinear'))
canopy_diff_kviteseid3_ub_20x20 <- (as.raster(canopymod_kviteseid3_ub_20x20)-terrainmod_kviteseid3_ub_resampeled_20x20)
plot(canopy_diff_kviteseid3_ub_20x20)

writeRaster(canopy_diff_kviteseid3_ub_20x20,'Telemark/canopy_height_clipped_raster/kviteseid3_ub_canopyheight', overwrite=TRUE)


# Nome Cappelen 1 ---------------------------------------------------------


# n_cappelen1_b
terrainmod_n_cappelen1_b  <-grid_terrain(n_cappelen1_b, method='knnidw',res=1)
canopymod_n_cappelen1_b   <-grid_canopy(n_cappelen1_b,res=1)

terrainmod_n_cappelen1_b_resampled <-resample(as.raster(terrainmod_n_cappelen1_b), as.raster(canopymod_n_cappelen1_b), method='bilinear')
canopy_diff_n_cappelen1_b<-(as.raster(canopymod_n_cappelen1_b)-terrainmod_n_cappelen1_b_resampled)
plot(canopy_diff_n_cappelen1_b)

trees_n_cappelen1_b<-tree_detection(n_cappelen1_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_n_cappelen1_b<-extract(canopy_diff_n_cappelen1_b,trees_n_cappelen1_b[,1:2])

lastrees_dalponte(n_cappelen1_b,canopy_diff_n_cappelen1_b,trees_n_cappelen1_b[treeheight_n_cappelen1_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_n_cappelen1_b<-tree_hulls(n_cappelen1_b,type='convex',field='treeID')
plot(canopy_diff_n_cappelen1_b)
plot(treeout_n_cappelen1_b,add=T) 

bigtrees_n_cappelen1_b<-which(extract(canopy_diff_n_cappelen1_b,treeout_n_cappelen1_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

n_cappelen1_b_clip<-lasclip(n_cappelen1_b,treeout_n_cappelen1_b@polygons[[bigtrees_n_cappelen1_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_n_cappelen1_b)){
  print(i)
  n_cappelen1_b_clip<-lasclip(n_cappelen1_b_clip,treeout_n_cappelen1_b@polygons[[bigtrees_n_cappelen1_b[i]]]@Polygons[[1]],inside=F)}
plot(n_cappelen1_b_clip) 

canopy_diff_n_cappelen1_b_clip <- (as.raster(grid_canopy(n_cappelen1_b_clip,res=0.5))-(crop(as.raster(grid_terrain(n_cappelen1_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(n_cappelen1_b_clip,res=0.5)))))
plot(canopy_diff_n_cappelen1_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
n_cappelen1_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Cappelen 1 B',10:9]))
n_cappelen1_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Cappelen 1 B',10:9][n_cappelen1_b_order,]))
n_cappelen1_b_cut<-lasclip(n_cappelen1_b_clip,n_cappelen1_b_poly)
plot(n_cappelen1_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_n_cappelen1_b_20x20 <-grid_terrain(n_cappelen1_b_cut,method='knnidw',res=1)
canopymod_n_cappelen1_b_20x20  <-grid_canopy(n_cappelen1_b_cut,res=1)

terrainmod_n_cappelen1_b_resampeled_20x20 <- resample(as.raster(terrainmod_n_cappelen1_b_20x20), as.raster(canopymod_n_cappelen1_b_20x20, method='bilinear'))
canopy_diff_n_cappelen1_b_20x20 <- (as.raster(canopymod_n_cappelen1_b_20x20)-terrainmod_n_cappelen1_b_resampeled_20x20)
plot(canopy_diff_n_cappelen1_b_20x20)

writeRaster(canopy_diff_n_cappelen1_b_20x20,'Telemark/canopy_height_clipped_raster/n_cappelen1_b_canopyheight', overwrite=TRUE)




# n_cappelen1_ub
terrainmod_n_cappelen1_ub <-grid_terrain(n_cappelen1_ub,method='knnidw',res=1)
canopymod_n_cappelen1_ub  <-grid_canopy(n_cappelen1_ub,res=1)

terrainmod_n_cappelen1_ub_resampeled <- resample(as.raster(terrainmod_n_cappelen1_ub), as.raster(canopymod_n_cappelen1_ub, method='bilinear'))
canopy_diff_n_cappelen1_ub <- (as.raster(canopymod_n_cappelen1_ub)-terrainmod_n_cappelen1_ub_resampeled)
plot(canopy_diff_n_cappelen1_ub)

trees_n_cappelen1_ub<-tree_detection(n_cappelen1_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_n_cappelen1_ub<-extract(canopy_diff_n_cappelen1_ub,trees_n_cappelen1_ub[,1:2])

lastrees_dalponte(n_cappelen1_ub,canopy_diff_n_cappelen1_ub,trees_n_cappelen1_ub[treeheight_n_cappelen1_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_n_cappelen1_ub<-tree_hulls(n_cappelen1_ub,type='convex',field='treeID')
plot(canopy_diff_n_cappelen1_ub)
plot(treeout_n_cappelen1_ub,add=T) 

bigtrees_n_cappelen1_ub<-which(extract(canopy_diff_n_cappelen1_ub,treeout_n_cappelen1_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

n_cappelen1_ub_clip<-lasclip(n_cappelen1_ub,treeout_n_cappelen1_ub@polygons[[bigtrees_n_cappelen1_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_n_cappelen1_ub)){
  print(i)
  n_cappelen1_ub_clip<-lasclip(n_cappelen1_ub_clip,treeout_n_cappelen1_ub@polygons[[bigtrees_n_cappelen1_ub[i]]]@Polygons[[1]],inside=F)}
plot(n_cappelen1_ub_clip) 

canopy_diff_n_cappelen1_ub_clip <- (as.raster(grid_canopy(n_cappelen1_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(n_cappelen1_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(n_cappelen1_ub_clip,res=0.5)))))
plot(canopy_diff_n_cappelen1_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
n_cappelen1_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Cappelen 1 UB',10:9]))
n_cappelen1_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Cappelen 1 UB',10:9][n_cappelen1_ub_order,]))
n_cappelen1_ub_cut<-lasclip(n_cappelen1_ub_clip,n_cappelen1_ub_poly)
plot(n_cappelen1_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_n_cappelen1_ub_20x20 <-grid_terrain(n_cappelen1_ub_cut,method='knnidw',res=1)
canopymod_n_cappelen1_ub_20x20  <-grid_canopy(n_cappelen1_ub_cut,res=1)

terrainmod_n_cappelen1_ub_resampeled_20x20 <- resample(as.raster(terrainmod_n_cappelen1_ub_20x20), as.raster(canopymod_n_cappelen1_ub_20x20, method='bilinear'))
canopy_diff_n_cappelen1_ub_20x20 <- (as.raster(canopymod_n_cappelen1_ub_20x20)-terrainmod_n_cappelen1_ub_resampeled_20x20)
plot(canopy_diff_n_cappelen1_ub_20x20)

writeRaster(canopy_diff_n_cappelen1_ub_20x20,'Telemark/canopy_height_clipped_raster/n_cappelen1_ub_canopyheight', overwrite=TRUE)



# Nome Cappelen 2 ---------------------------------------------------------


# n_cappelen2_b
terrainmod_n_cappelen2_b  <-grid_terrain(n_cappelen2_b, method='knnidw',res=1)
canopymod_n_cappelen2_b   <-grid_canopy(n_cappelen2_b,res=1)

terrainmod_n_cappelen2_b_resampled <-resample(as.raster(terrainmod_n_cappelen2_b), as.raster(canopymod_n_cappelen2_b), method='bilinear')
canopy_diff_n_cappelen2_b<-(as.raster(canopymod_n_cappelen2_b)-terrainmod_n_cappelen2_b_resampled)
plot(canopy_diff_n_cappelen2_b)

trees_n_cappelen2_b<-tree_detection(n_cappelen2_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_n_cappelen2_b<-extract(canopy_diff_n_cappelen2_b,trees_n_cappelen2_b[,1:2])

lastrees_dalponte(n_cappelen2_b,canopy_diff_n_cappelen2_b,trees_n_cappelen2_b[treeheight_n_cappelen2_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_n_cappelen2_b<-tree_hulls(n_cappelen2_b,type='convex',field='treeID')
plot(canopy_diff_n_cappelen2_b)
plot(treeout_n_cappelen2_b,add=T) 

bigtrees_n_cappelen2_b<-which(extract(canopy_diff_n_cappelen2_b,treeout_n_cappelen2_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

n_cappelen2_b_clip<-lasclip(n_cappelen2_b,treeout_n_cappelen2_b@polygons[[bigtrees_n_cappelen2_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_n_cappelen2_b)){
  print(i)
  n_cappelen2_b_clip<-lasclip(n_cappelen2_b_clip,treeout_n_cappelen2_b@polygons[[bigtrees_n_cappelen2_b[i]]]@Polygons[[1]],inside=F)}
plot(n_cappelen2_b_clip) 

canopy_diff_n_cappelen2_b_clip <- (as.raster(grid_canopy(n_cappelen2_b_clip,res=0.5))-(crop(as.raster(grid_terrain(n_cappelen2_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(n_cappelen2_b_clip,res=0.5)))))
plot(canopy_diff_n_cappelen2_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
n_cappelen2_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Cappelen 2 B',10:9]))
n_cappelen2_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Cappelen 2 B',10:9][n_cappelen2_b_order,]))
n_cappelen2_b_cut<-lasclip(n_cappelen2_b_clip,n_cappelen2_b_poly)
plot(n_cappelen2_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_n_cappelen2_b_20x20 <-grid_terrain(n_cappelen2_b_cut,method='knnidw',res=1)
canopymod_n_cappelen2_b_20x20  <-grid_canopy(n_cappelen2_b_cut,res=1)

terrainmod_n_cappelen2_b_resampeled_20x20 <- resample(as.raster(terrainmod_n_cappelen2_b_20x20), as.raster(canopymod_n_cappelen2_b_20x20, method='bilinear'))
canopy_diff_n_cappelen2_b_20x20 <- (as.raster(canopymod_n_cappelen2_b_20x20)-terrainmod_n_cappelen2_b_resampeled_20x20)
plot(canopy_diff_n_cappelen2_b_20x20)

writeRaster(canopy_diff_n_cappelen2_b_20x20,'Telemark/canopy_height_clipped_raster/n_cappelen2_b_canopyheight', overwrite=TRUE)


# n_cappelen2_ub
terrainmod_n_cappelen2_ub <-grid_terrain(n_cappelen2_ub,method='knnidw',res=1)
canopymod_n_cappelen2_ub  <-grid_canopy(n_cappelen2_ub,res=1)


terrainmod_n_cappelen2_ub_resampeled <- resample(as.raster(terrainmod_n_cappelen2_ub), as.raster(canopymod_n_cappelen2_ub, method='bilinear'))
canopy_diff_n_cappelen2_ub <- (as.raster(canopymod_n_cappelen2_ub)-terrainmod_n_cappelen2_ub_resampeled)
plot(canopy_diff_n_cappelen2_ub)

trees_n_cappelen2_ub<-tree_detection(n_cappelen2_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_n_cappelen2_ub<-extract(canopy_diff_n_cappelen2_ub,trees_n_cappelen2_ub[,1:2])

lastrees_dalponte(n_cappelen2_ub,canopy_diff_n_cappelen2_ub,trees_n_cappelen2_ub[treeheight_n_cappelen2_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_n_cappelen2_ub<-tree_hulls(n_cappelen2_ub,type='convex',field='treeID')
plot(canopy_diff_n_cappelen2_ub)
plot(treeout_n_cappelen2_ub,add=T) 

bigtrees_n_cappelen2_ub<-which(extract(canopy_diff_n_cappelen2_ub,treeout_n_cappelen2_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

n_cappelen2_ub_clip<-lasclip(n_cappelen2_ub,treeout_n_cappelen2_ub@polygons[[bigtrees_n_cappelen2_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_n_cappelen2_ub)){
  print(i)
  n_cappelen2_ub_clip<-lasclip(n_cappelen2_ub_clip,treeout_n_cappelen2_ub@polygons[[bigtrees_n_cappelen2_ub[i]]]@Polygons[[1]],inside=F)}
plot(n_cappelen2_ub_clip) 

canopy_diff_n_cappelen2_ub_clip <- (as.raster(grid_canopy(n_cappelen2_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(n_cappelen2_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(n_cappelen2_ub_clip,res=0.5)))))
plot(canopy_diff_n_cappelen2_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
n_cappelen2_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Cappelen 2 UB',10:9]))
n_cappelen2_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Cappelen 2 UB',10:9][n_cappelen2_ub_order,]))
n_cappelen2_ub_cut<-lasclip(n_cappelen2_ub_clip,n_cappelen2_ub_poly)
plot(n_cappelen2_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_n_cappelen2_ub_20x20 <-grid_terrain(n_cappelen2_ub_cut,method='knnidw',res=1)
canopymod_n_cappelen2_ub_20x20  <-grid_canopy(n_cappelen2_ub_cut,res=1)

terrainmod_n_cappelen2_ub_resampeled_20x20 <- resample(as.raster(terrainmod_n_cappelen2_ub_20x20), as.raster(canopymod_n_cappelen2_ub_20x20, method='bilinear'))
canopy_diff_n_cappelen2_ub_20x20 <- (as.raster(canopymod_n_cappelen2_ub_20x20)-terrainmod_n_cappelen2_ub_resampeled_20x20)
plot(canopy_diff_n_cappelen2_ub_20x20)

writeRaster(canopy_diff_n_cappelen2_ub_20x20,'Telemark/canopy_height_clipped_raster/n_cappelen2_ub_canopyheight', overwrite=TRUE)


# Notodden 3 --------------------------------------------------------------


# notodden3_b
terrainmod_notodden3_b  <-grid_terrain(notodden3_b, method='knnidw',res=1)
canopymod_notodden3_b   <-grid_canopy(notodden3_b,res=1)

terrainmod_notodden3_b_resampled <-resample(as.raster(terrainmod_notodden3_b), as.raster(canopymod_notodden3_b), method='bilinear')
canopy_diff_notodden3_b<-(as.raster(canopymod_notodden3_b)-terrainmod_notodden3_b_resampled)
plot(canopy_diff_notodden3_b)
#max 6,363

#Cutting the 32x32m square(with big trees removed) to 20x20 m
notodden3_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Telemark/Notodden3.las')
notodden3_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 3 B',10:9]))
notodden3_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 3 B',10:9][notodden3_b_order,]))
notodden3_b_cut<-lasclip(notodden3_las,notodden3_b_poly)
plot(notodden3_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_notodden3_b_20x20 <-grid_terrain(notodden3_b_cut,method='knnidw',res=1)
canopymod_notodden3_b_20x20  <-grid_canopy(notodden3_b_cut,res=1)

terrainmod_notodden3_b_resampeled_20x20 <- resample(as.raster(terrainmod_notodden3_b_20x20), as.raster(canopymod_notodden3_b_20x20, method='bilinear'))
canopy_diff_notodden3_b_20x20 <- (as.raster(canopymod_notodden3_b_20x20)-terrainmod_notodden3_b_resampeled_20x20)
plot(canopy_diff_notodden3_b_20x20)

writeRaster(canopy_diff_notodden3_b_20x20,'Telemark/canopy_height_clipped_raster/notodden3_b_canopyheight', overwrite=TRUE)


# notodden3_ub
terrainmod_notodden3_ub <-grid_terrain(notodden3_ub,method='knnidw',res=1)
canopymod_notodden3_ub  <-grid_canopy(notodden3_ub,res=1)


terrainmod_notodden3_ub_resampeled <- resample(as.raster(terrainmod_notodden3_ub), as.raster(canopymod_notodden3_ub, method='bilinear'))
canopy_diff_notodden3_ub <- (as.raster(canopymod_notodden3_ub)-terrainmod_notodden3_ub_resampeled)
plot(canopy_diff_notodden3_ub)
#max 4,539

#Cutting the 32x32m square(with big trees removed) to 20x20 m
notodden3_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Telemark/Notodden3.las')
notodden3_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 3 UB',10:9]))
notodden3_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 3 UB',10:9][notodden3_ub_order,]))
notodden3_ub_cut<-lasclip(notodden3_las,notodden3_ub_poly)
plot(notodden3_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_notodden3_ub_20x20 <-grid_terrain(notodden3_ub_cut,method='knnidw',res=1)
canopymod_notodden3_ub_20x20  <-grid_canopy(notodden3_ub_cut,res=1)

terrainmod_notodden3_ub_resampeled_20x20 <- resample(as.raster(terrainmod_notodden3_ub_20x20), as.raster(canopymod_notodden3_ub_20x20, method='bilinear'))
canopy_diff_notodden3_ub_20x20 <- (as.raster(canopymod_notodden3_ub_20x20)-terrainmod_notodden3_ub_resampeled_20x20)
plot(canopy_diff_notodden3_ub_20x20)

writeRaster(canopy_diff_notodden3_ub_20x20,'Telemark/canopy_height_clipped_raster/notodden3_ub_canopyheight', overwrite=TRUE)


# Notodden 5 --------------------------------------------------------------


# notodden5_b
terrainmod_notodden5_b  <-grid_terrain(notodden5_b, method='knnidw',res=1)
canopymod_notodden5_b   <-grid_canopy(notodden5_b,res=1)

terrainmod_notodden5_b_resampled <-resample(as.raster(terrainmod_notodden5_b), as.raster(canopymod_notodden5_b), method='bilinear')
canopy_diff_notodden5_b<-(as.raster(canopymod_notodden5_b)-terrainmod_notodden5_b_resampled)
plot(canopy_diff_notodden5_b)

trees_notodden5_b<-tree_detection(notodden5_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_notodden5_b<-extract(canopy_diff_notodden5_b,trees_notodden5_b[,1:2])

lastrees_dalponte(notodden5_b,canopy_diff_notodden5_b,trees_notodden5_b[treeheight_notodden5_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_notodden5_b<-tree_hulls(notodden5_b,type='convex',field='treeID')
plot(canopy_diff_notodden5_b)
plot(treeout_notodden5_b,add=T) 

bigtrees_notodden5_b<-which(extract(canopy_diff_notodden5_b,treeout_notodden5_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

notodden5_b_clip<-lasclip(notodden5_b,treeout_notodden5_b@polygons[[bigtrees_notodden5_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_notodden5_b)){
  print(i)
  notodden5_b_clip<-lasclip(notodden5_b_clip,treeout_notodden5_b@polygons[[bigtrees_notodden5_b[i]]]@Polygons[[1]],inside=F)}
plot(notodden5_b_clip) 

canopy_diff_notodden5_b_clip <- (as.raster(grid_canopy(notodden5_b_clip,res=0.5))-(crop(as.raster(grid_terrain(notodden5_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(notodden5_b_clip,res=0.5)))))
plot(canopy_diff_notodden5_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
notodden5_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 5 B',10:9]))
notodden5_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 5 B',10:9][notodden5_b_order,]))
notodden5_b_cut<-lasclip(notodden5_b_clip,notodden5_b_poly)
plot(notodden5_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_notodden5_b_20x20 <-grid_terrain(notodden5_b_cut,method='knnidw',res=1)
canopymod_notodden5_b_20x20  <-grid_canopy(notodden5_b_cut,res=1)

terrainmod_notodden5_b_resampeled_20x20 <- resample(as.raster(terrainmod_notodden5_b_20x20), as.raster(canopymod_notodden5_b_20x20, method='bilinear'))
canopy_diff_notodden5_b_20x20 <- (as.raster(canopymod_notodden5_b_20x20)-terrainmod_notodden5_b_resampeled_20x20)
plot(canopy_diff_notodden5_b_20x20)

writeRaster(canopy_diff_notodden5_b_20x20,'Telemark/canopy_height_clipped_raster/notodden5_b_canopyheight', overwrite=TRUE)

# notodden5_ub
terrainmod_notodden5_ub <-grid_terrain(notodden5_ub,method='knnidw',res=1)
canopymod_notodden5_ub  <-grid_canopy(notodden5_ub,res=1)


terrainmod_notodden5_ub_resampeled <- resample(as.raster(terrainmod_notodden5_ub), as.raster(canopymod_notodden5_ub, method='bilinear'))
canopy_diff_notodden5_ub <- (as.raster(canopymod_notodden5_ub)-terrainmod_notodden5_ub_resampeled)
plot(canopy_diff_notodden5_ub)
#max 3,495

#Cutting the 32x32m square(with big trees removed) to 20x20 m
notodden5_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Telemark/Notodden5.las')
notodden5_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 5 UB',10:9]))
notodden5_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 5 UB',10:9][notodden5_ub_order,]))
notodden5_ub_cut<-lasclip(notodden5_las,notodden5_ub_poly)
plot(notodden5_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_notodden5_ub_20x20 <-grid_terrain(notodden5_ub_cut,method='knnidw',res=1)
canopymod_notodden5_ub_20x20  <-grid_canopy(notodden5_ub_cut,res=1)

terrainmod_notodden5_ub_resampeled_20x20 <- resample(as.raster(terrainmod_notodden5_ub_20x20), as.raster(canopymod_notodden5_ub_20x20, method='bilinear'))
canopy_diff_notodden5_ub_20x20 <- (as.raster(canopymod_notodden5_ub_20x20)-terrainmod_notodden5_ub_resampeled_20x20)
plot(canopy_diff_notodden5_ub_20x20)

writeRaster(canopy_diff_notodden5_ub_20x20,'Telemark/canopy_height_clipped_raster/notodden5_ub_canopyheight', overwrite=TRUE)



# Notodden 6 --------------------------------------------------------------


# notodden6_b
terrainmod_notodden6_b  <-grid_terrain(notodden6_b, method='knnidw',res=1)
canopymod_notodden6_b   <-grid_canopy(notodden6_b,res=1)

terrainmod_notodden6_b_resampled <-resample(as.raster(terrainmod_notodden6_b), as.raster(canopymod_notodden6_b), method='bilinear')
canopy_diff_notodden6_b<-(as.raster(canopymod_notodden6_b)-terrainmod_notodden6_b_resampled)
plot(canopy_diff_notodden6_b)

trees_notodden6_b<-tree_detection(notodden6_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_notodden6_b<-extract(canopy_diff_notodden6_b,trees_notodden6_b[,1:2])

lastrees_dalponte(notodden6_b,canopy_diff_notodden6_b,trees_notodden6_b[treeheight_notodden6_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_notodden6_b<-tree_hulls(notodden6_b,type='convex',field='treeID')
plot(canopy_diff_notodden6_b)
plot(treeout_notodden6_b,add=T) 

bigtrees_notodden6_b<-which(extract(canopy_diff_notodden6_b,treeout_notodden6_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

notodden6_b_clip<-lasclip(notodden6_b,treeout_notodden6_b@polygons[[bigtrees_notodden6_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_notodden6_b)){
  print(i)
  notodden6_b_clip<-lasclip(notodden6_b_clip,treeout_notodden6_b@polygons[[bigtrees_notodden6_b[i]]]@Polygons[[1]],inside=F)}
plot(notodden6_b_clip) 

canopy_diff_notodden6_b_clip <- (as.raster(grid_canopy(notodden6_b_clip,res=0.5))-(crop(as.raster(grid_terrain(notodden6_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(notodden6_b_clip,res=0.5)))))
plot(canopy_diff_notodden6_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
notodden6_b_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 6 B',10:9]))
notodden6_b_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 6 B',10:9][notodden6_b_order,]))
notodden6_b_cut<-lasclip(notodden6_b_clip,notodden6_b_poly)
plot(notodden6_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_notodden6_b_20x20 <-grid_terrain(notodden6_b_cut,method='knnidw',res=1)
canopymod_notodden6_b_20x20  <-grid_canopy(notodden6_b_cut,res=1)

terrainmod_notodden6_b_resampeled_20x20 <- resample(as.raster(terrainmod_notodden6_b_20x20), as.raster(canopymod_notodden6_b_20x20, method='bilinear'))
canopy_diff_notodden6_b_20x20 <- (as.raster(canopymod_notodden6_b_20x20)-terrainmod_notodden6_b_resampeled_20x20)
plot(canopy_diff_notodden6_b_20x20)

writeRaster(canopy_diff_notodden6_b_20x20,'Telemark/canopy_height_clipped_raster/notodden6_b_canopyheight', overwrite=TRUE)


# notodden6_ub
terrainmod_notodden6_ub <-grid_terrain(notodden6_ub,method='knnidw',res=1)
canopymod_notodden6_ub  <-grid_canopy(notodden6_ub,res=1)

terrainmod_notodden6_ub_resampeled <- resample(as.raster(terrainmod_notodden6_ub), as.raster(canopymod_notodden6_ub, method='bilinear'))
canopy_diff_notodden6_ub <- (as.raster(canopymod_notodden6_ub)-terrainmod_notodden6_ub_resampeled)
plot(canopy_diff_notodden6_ub)


trees_notodden6_ub<-tree_detection(notodden6_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_notodden6_ub<-extract(canopy_diff_notodden6_ub,trees_notodden6_ub[,1:2])

lastrees_dalponte(notodden6_ub,canopy_diff_notodden6_ub,trees_notodden6_ub[treeheight_notodden6_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_notodden6_ub<-tree_hulls(notodden6_ub,type='convex',field='treeID')
plot(canopy_diff_notodden6_ub)
plot(treeout_notodden6_ub,add=T) 

bigtrees_notodden6_ub<-which(extract(canopy_diff_notodden6_ub,treeout_notodden6_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

notodden6_ub_clip<-lasclip(notodden6_ub,treeout_notodden6_ub@polygons[[bigtrees_notodden6_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_notodden6_ub)){
  print(i)
  notodden6_ub_clip<-lasclip(notodden6_ub_clip,treeout_notodden6_ub@polygons[[bigtrees_notodden6_ub[i]]]@Polygons[[1]],inside=F)}
plot(notodden6_ub_clip) 

canopy_diff_notodden6_ub_clip <- (as.raster(grid_canopy(notodden6_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(notodden6_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(notodden6_ub_clip,res=0.5)))))
plot(canopy_diff_notodden6_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
notodden6_ub_order<-chull(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 6 UB',10:9]))
notodden6_ub_poly<-Polygon(as.matrix(plotcoords_telemark[plotcoords_telemark$flatenavn=='Notodden 6 UB',10:9][notodden6_ub_order,]))
notodden6_ub_cut<-lasclip(notodden6_ub_clip,notodden6_ub_poly)
plot(notodden6_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_notodden6_ub_20x20 <-grid_terrain(notodden6_ub_cut,method='knnidw',res=1)
canopymod_notodden6_ub_20x20  <-grid_canopy(notodden6_ub_cut,res=1)

terrainmod_notodden6_ub_resampeled_20x20 <- resample(as.raster(terrainmod_notodden6_ub_20x20), as.raster(canopymod_notodden6_ub_20x20, method='bilinear'))
canopy_diff_notodden6_ub_20x20 <- (as.raster(canopymod_notodden6_ub_20x20)-terrainmod_notodden6_ub_resampeled_20x20)
plot(canopy_diff_notodden6_ub_20x20)

writeRaster(canopy_diff_notodden6_ub_20x20,'Telemark/canopy_height_clipped_raster/notodden6_ub_canopyheight', overwrite=TRUE)












# Hedmark og Akershus -----------------------------------------------------


# Didrik Holmsen ----------------------------------------------------------


# Didrik Holmsen_b
terrainmod_didrik_holmsen_b  <-grid_terrain(didrik_holmsen_b, method='knnidw',res=1)
canopymod_didrik_holmsen_b   <-grid_canopy(didrik_holmsen_b,res=1)

terrainmod_didrik_holmsen_b_resampled <-resample(as.raster(terrainmod_didrik_holmsen_b), as.raster(canopymod_didrik_holmsen_b), method='bilinear')
canopy_diff_didrik_holmsen_b<-(as.raster(canopymod_didrik_holmsen_b)-terrainmod_didrik_holmsen_b_resampled)
plot(canopy_diff_didrik_holmsen_b)
 

trees_didrik_holmsen_b<-tree_detection(didrik_holmsen_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_didrik_holmsen_b<-extract(canopy_diff_didrik_holmsen_b,trees_didrik_holmsen_b[,1:2])

lastrees_dalponte(didrik_holmsen_b,canopy_diff_didrik_holmsen_b,trees_didrik_holmsen_b[treeheight_didrik_holmsen_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_didrik_holmsen_b<-tree_hulls(didrik_holmsen_b,type='convex',field='treeID')
plot(canopy_diff_didrik_holmsen_b)
plot(treeout_didrik_holmsen_b,add=T) 

bigtrees_didrik_holmsen_b<-which(extract(canopy_diff_didrik_holmsen_b,treeout_didrik_holmsen_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

didrik_holmsen_b_clip<-lasclip(didrik_holmsen_b,treeout_didrik_holmsen_b@polygons[[bigtrees_didrik_holmsen_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_didrik_holmsen_b)){
  print(i)
  didrik_holmsen_b_clip<-lasclip(didrik_holmsen_b_clip,treeout_didrik_holmsen_b@polygons[[bigtrees_didrik_holmsen_b[i]]]@Polygons[[1]],inside=F)}
plot(didrik_holmsen_b_clip) 

canopy_diff_didrik_holmsen_b_clip <- (as.raster(grid_canopy(didrik_holmsen_b_clip,res=0.5))-(crop(as.raster(grid_terrain(didrik_holmsen_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(didrik_holmsen_b_clip,res=0.5)))))
plot(canopy_diff_didrik_holmsen_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
didrik_holmsen_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='DH2',15:14]))
didrik_holmsen_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='DH2',15:14][didrik_holmsen_b_order,]))
didrik_holmsen_b_cut<-lasclip(didrik_holmsen_b_clip,didrik_holmsen_b_poly)
plot(didrik_holmsen_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_didrik_holmsen_b_20x20 <-grid_terrain(didrik_holmsen_b_cut,method='knnidw',res=1)
canopymod_didrik_holmsen_b_20x20  <-grid_canopy(didrik_holmsen_b_cut,res=1)

terrainmod_didrik_holmsen_b_resampeled_20x20 <- resample(as.raster(terrainmod_didrik_holmsen_b_20x20), as.raster(canopymod_didrik_holmsen_b_20x20, method='bilinear'))
canopy_diff_didrik_holmsen_b_20x20 <- (as.raster(canopymod_didrik_holmsen_b_20x20)-terrainmod_didrik_holmsen_b_resampeled_20x20)
plot(canopy_diff_didrik_holmsen_b_20x20)

writeRaster(canopy_diff_didrik_holmsen_b_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/didrik_holmsen_b_canopyheight', overwrite=TRUE)


# Didrik Holmsen_ub
terrainmod_didrik_holmsen_ub <-grid_terrain(didrik_holmsen_ub,method='knnidw',res=1)
canopymod_didrik_holmsen_ub  <-grid_canopy(didrik_holmsen_ub,res=1)


terrainmod_didrik_holmsen_ub_resampeled <- resample(as.raster(terrainmod_didrik_holmsen_ub), as.raster(canopymod_didrik_holmsen_ub, method='bilinear'))
canopy_diff_didrik_holmsen_ub <- (as.raster(canopymod_didrik_holmsen_ub)-terrainmod_didrik_holmsen_ub_resampeled)
plot(canopy_diff_didrik_holmsen_ub)

trees_didrik_holmsen_ub<-tree_detection(didrik_holmsen_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_didrik_holmsen_ub<-extract(canopy_diff_didrik_holmsen_ub,trees_didrik_holmsen_ub[,1:2])

lastrees_dalponte(didrik_holmsen_ub,canopy_diff_didrik_holmsen_ub,trees_didrik_holmsen_ub[treeheight_didrik_holmsen_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_didrik_holmsen_ub<-tree_hulls(didrik_holmsen_ub,type='convex',field='treeID')
plot(canopy_diff_didrik_holmsen_ub)
plot(treeout_didrik_holmsen_ub,add=T) 

bigtrees_didrik_holmsen_ub<-which(extract(canopy_diff_didrik_holmsen_ub,treeout_didrik_holmsen_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

didrik_holmsen_ub_clip<-lasclip(didrik_holmsen_ub,treeout_didrik_holmsen_ub@polygons[[bigtrees_didrik_holmsen_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_didrik_holmsen_ub)){
  print(i)
  didrik_holmsen_ub_clip<-lasclip(didrik_holmsen_ub_clip,treeout_didrik_holmsen_ub@polygons[[bigtrees_didrik_holmsen_ub[i]]]@Polygons[[1]],inside=F)}
plot(didrik_holmsen_ub_clip) 

canopy_diff_didrik_holmsen_ub_clip <- (as.raster(grid_canopy(didrik_holmsen_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(didrik_holmsen_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(didrik_holmsen_ub_clip,res=0.5)))))
plot(canopy_diff_didrik_holmsen_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
didrik_holmsen_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='DH1',15:14]))
didrik_holmsen_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='DH1',15:14][didrik_holmsen_ub_order,]))
didrik_holmsen_ub_cut<-lasclip(didrik_holmsen_ub_clip,didrik_holmsen_ub_poly)
plot(didrik_holmsen_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_didrik_holmsen_ub_20x20 <-grid_terrain(didrik_holmsen_ub_cut,method='knnidw',res=1)
canopymod_didrik_holmsen_ub_20x20  <-grid_canopy(didrik_holmsen_ub_cut,res=1)

terrainmod_didrik_holmsen_ub_resampeled_20x20 <- resample(as.raster(terrainmod_didrik_holmsen_ub_20x20), as.raster(canopymod_didrik_holmsen_ub_20x20, method='bilinear'))
canopy_diff_didrik_holmsen_ub_20x20 <- (as.raster(canopymod_didrik_holmsen_ub_20x20)-terrainmod_didrik_holmsen_ub_resampeled_20x20)
plot(canopy_diff_didrik_holmsen_ub_20x20)

writeRaster(canopy_diff_didrik_holmsen_ub_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/didrik_holmsen_ub_canopyheight', overwrite=TRUE)


# Eidskog -----------------------------------------------------------------


#Eidskog_b
terrainmod_eidskog_b  <-grid_terrain(eidskog_b, method='knnidw',res=1)
canopymod_eidskog_b   <-grid_canopy(eidskog_b,res=1)

terrainmod_eidskog_b_resampled <-resample(as.raster(terrainmod_eidskog_b), as.raster(canopymod_eidskog_b), method='bilinear')
canopy_diff_eidskog_b<-(as.raster(canopymod_eidskog_b)-terrainmod_eidskog_b_resampled)
plot(canopy_diff_eidskog_b)

trees_eidskog_b<-tree_detection(eidskog_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_eidskog_b<-extract(canopy_diff_eidskog_b,trees_eidskog_b[,1:2])

lastrees_dalponte(eidskog_b,canopy_diff_eidskog_b,trees_eidskog_b[treeheight_eidskog_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_eidskog_b<-tree_hulls(eidskog_b,type='convex',field='treeID')
plot(canopy_diff_eidskog_b)
plot(treeout_eidskog_b,add=T) 

bigtrees_eidskog_b<-which(extract(canopy_diff_eidskog_b,treeout_eidskog_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

eidskog_b_clip<-lasclip(eidskog_b,treeout_eidskog_b@polygons[[bigtrees_eidskog_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_eidskog_b)){
  print(i)
  eidskog_b_clip<-lasclip(eidskog_b_clip,treeout_eidskog_b@polygons[[bigtrees_eidskog_b[i]]]@Polygons[[1]],inside=F)}
plot(eidskog_b_clip) 

canopy_diff_eidskog_b_clip <- (as.raster(grid_canopy(eidskog_b_clip,res=0.5))-(crop(as.raster(grid_terrain(eidskog_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(eidskog_b_clip,res=0.5)))))
plot(canopy_diff_eidskog_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
eidskog_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='STSKN2',15:14]))
eidskog_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='STSKN2',15:14][eidskog_b_order,]))
eidskog_b_cut<-lasclip(eidskog_b_clip,eidskog_b_poly)
plot(eidskog_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_eidskog_b_20x20 <-grid_terrain(eidskog_b_cut,method='knnidw',res=1)
canopymod_eidskog_b_20x20  <-grid_canopy(eidskog_b_cut,res=1)

terrainmod_eidskog_b_resampeled_20x20 <- resample(as.raster(terrainmod_eidskog_b_20x20), as.raster(canopymod_eidskog_b_20x20, method='bilinear'))
canopy_diff_eidskog_b_20x20 <- (as.raster(canopymod_eidskog_b_20x20)-terrainmod_eidskog_b_resampeled_20x20)
plot(canopy_diff_eidskog_b_20x20)

writeRaster(canopy_diff_eidskog_b_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/eidskog_b_canopyheight', overwrite=TRUE)




#Eidskog_ub
terrainmod_eidskog_ub <-grid_terrain(eidskog_ub,method='knnidw',res=1)
canopymod_eidskog_ub  <-grid_canopy(eidskog_ub,res=1)

terrainmod_eidskog_ub_resampeled <- resample(as.raster(terrainmod_eidskog_ub), as.raster(canopymod_eidskog_ub, method='bilinear'))
canopy_diff_eidskog_ub <- (as.raster(canopymod_eidskog_ub)-terrainmod_eidskog_ub_resampeled)
plot(canopy_diff_eidskog_ub)


trees_eidskog_ub<-tree_detection(eidskog_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_eidskog_ub<-extract(canopy_diff_eidskog_ub,trees_eidskog_ub[,1:2])

lastrees_dalponte(eidskog_ub,canopy_diff_eidskog_ub,trees_eidskog_ub[treeheight_eidskog_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_eidskog_ub<-tree_hulls(eidskog_ub,type='convex',field='treeID')
plot(canopy_diff_eidskog_ub)
plot(treeout_eidskog_ub,add=T) 

bigtrees_eidskog_ub<-which(extract(canopy_diff_eidskog_ub,treeout_eidskog_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

eidskog_ub_clip<-lasclip(eidskog_ub,treeout_eidskog_ub@polygons[[bigtrees_eidskog_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_eidskog_ub)){
  print(i)
  eidskog_ub_clip<-lasclip(eidskog_ub_clip,treeout_eidskog_ub@polygons[[bigtrees_eidskog_ub[i]]]@Polygons[[1]],inside=F)}
plot(eidskog_ub_clip) 

canopy_diff_eidskog_ub_clip <- (as.raster(grid_canopy(eidskog_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(eidskog_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(eidskog_ub_clip,res=0.5)))))
plot(canopy_diff_eidskog_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
eidskog_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='STSKN1',15:14]))
eidskog_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='STSKN1',15:14][eidskog_ub_order,]))
eidskog_ub_cut<-lasclip(eidskog_ub_clip,eidskog_ub_poly)
plot(eidskog_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_eidskog_ub_20x20 <-grid_terrain(eidskog_ub_cut,method='knnidw',res=1)
canopymod_eidskog_ub_20x20  <-grid_canopy(eidskog_ub_cut,res=1)

terrainmod_eidskog_ub_resampeled_20x20 <- resample(as.raster(terrainmod_eidskog_ub_20x20), as.raster(canopymod_eidskog_ub_20x20, method='bilinear'))
canopy_diff_eidskog_ub_20x20 <- (as.raster(canopymod_eidskog_ub_20x20)-terrainmod_eidskog_ub_resampeled_20x20)
plot(canopy_diff_eidskog_ub_20x20)

writeRaster(canopy_diff_eidskog_ub_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/eidskog_ub_canopyheight', overwrite=TRUE)


# Fet3 --------------------------------------------------------------------


# Fet3_b
terrainmod_fet3_b  <-grid_terrain(fet3_b, method='knnidw',res=1)
canopymod_fet3_b   <-grid_canopy(fet3_b,res=1)

terrainmod_fet3_b_resampled <-resample(as.raster(terrainmod_fet3_b), as.raster(canopymod_fet3_b), method='bilinear')
canopy_diff_fet3_b<-(as.raster(canopymod_fet3_b)-terrainmod_fet3_b_resampled)
plot(canopy_diff_fet3_b)
canopy_diff_fet3_b# max 2


#Cutting the 32x32m square(with big trees removed) to 20x20 m
fet3_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Hedmark_Akershus/Fet3.las') 
fet3_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='FK2',15:14]))
fet3_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='FK2',15:14][fet3_b_order,]))
fet3_b_cut<-lasclip(fet3_las,fet3_b_poly)
plot(fet3_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_fet3_b_20x20 <-grid_terrain(fet3_b_cut,method='knnidw',res=1)
canopymod_fet3_b_20x20  <-grid_canopy(fet3_b_cut,res=1)

terrainmod_fet3_b_resampeled_20x20 <- resample(as.raster(terrainmod_fet3_b_20x20), as.raster(canopymod_fet3_b_20x20, method='bilinear'))
canopy_diff_fet3_b_20x20 <- (as.raster(canopymod_fet3_b_20x20)-terrainmod_fet3_b_resampeled_20x20)
plot(canopy_diff_fet3_b_20x20)

writeRaster(canopy_diff_fet3_b_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/fet3_b_canopyheight', overwrite=TRUE)



# Fet3_ub
terrainmod_fet3_ub <-grid_terrain(fet3_ub,method='knnidw',res=1)
canopymod_fet3_ub  <-grid_canopy(fet3_ub,res=1)


terrainmod_fet3_ub_resampeled <- resample(as.raster(terrainmod_fet3_ub), as.raster(canopymod_fet3_ub, method='bilinear'))
canopy_diff_fet3_ub <- (as.raster(canopymod_fet3_ub)-terrainmod_fet3_ub_resampeled)
plot(canopy_diff_fet3_ub)

canopy_diff_fet3_ub #max 6,6

#Cutting the 32x32m square(with big trees removed) to 20x20 m
fet3_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Hedmark_Akershus/Fet3.las') 
fet3_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='FK1',15:14]))
fet3_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='FK1',15:14][fet3_ub_order,]))
fet3_ub_cut<-lasclip(fet3_las,fet3_ub_poly)
plot(fet3_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_fet3_ub_20x20 <-grid_terrain(fet3_ub_cut,method='knnidw',res=1)
canopymod_fet3_ub_20x20  <-grid_canopy(fet3_ub_cut,res=1)

terrainmod_fet3_ub_resampeled_20x20 <- resample(as.raster(terrainmod_fet3_ub_20x20), as.raster(canopymod_fet3_ub_20x20, method='bilinear'))
canopy_diff_fet3_ub_20x20 <- (as.raster(canopymod_fet3_ub_20x20)-terrainmod_fet3_ub_resampeled_20x20)
plot(canopy_diff_fet3_ub_20x20)

writeRaster(canopy_diff_fet3_ub_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/fet3_ub_canopyheight', overwrite=TRUE)



# h_pramhus ---------------------------------------------------------------


# h_pramhus_b
terrainmod_h_pramhus_b  <-grid_terrain(h_pramhus_b, method='knnidw',res=1)
canopymod_h_pramhus_b   <-grid_canopy(h_pramhus_b,res=1)

terrainmod_h_pramhus_b_resampled <-resample(as.raster(terrainmod_h_pramhus_b), as.raster(canopymod_h_pramhus_b), method='bilinear')
canopy_diff_h_pramhus_b<-(as.raster(canopymod_h_pramhus_b)-terrainmod_h_pramhus_b_resampled)
plot(canopy_diff_h_pramhus_b)

#1 outlying very high point (like a bird?)
cellStats(canopy_diff_h_pramhus_b,stat='max')
canopy_diff_h_pramhus_b[canopy_diff_h_pramhus_b>300] <- NA
canopy_diff_h_pramhus_b #max 4.802
plot(canopy_diff_h_pramhus_b)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
halvard_pramhus_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Hedmark_Akershus/Halvard_Pramhus.las') 
h_pramhus_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='HP1',15:14]))
h_pramhus_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='HP1',15:14][h_pramhus_b_order,]))
h_pramhus_b_cut<-lasclip(halvard_pramhus_las,h_pramhus_b_poly)
plot(h_pramhus_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_h_pramhus_b_20x20 <-grid_terrain(h_pramhus_b_cut,method='knnidw',res=1)
canopymod_h_pramhus_b_20x20  <-grid_canopy(h_pramhus_b_cut,res=1)

terrainmod_h_pramhus_b_resampeled_20x20 <- resample(as.raster(terrainmod_h_pramhus_b_20x20), as.raster(canopymod_h_pramhus_b_20x20, method='bilinear'))
canopy_diff_h_pramhus_b_20x20 <- (as.raster(canopymod_h_pramhus_b_20x20)-terrainmod_h_pramhus_b_resampeled_20x20)
plot(canopy_diff_h_pramhus_b_20x20)

writeRaster(canopy_diff_h_pramhus_b_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/h_pramhus_b_canopyheight', overwrite=TRUE)


# h_pramhus_ub 
terrainmod_h_pramhus_ub <-grid_terrain(h_pramhus_ub,method='knnidw',res=1)
canopymod_h_pramhus_ub  <-grid_canopy(h_pramhus_ub,res=1)

terrainmod_h_pramhus_ub_resampeled <- resample(as.raster(terrainmod_h_pramhus_ub), as.raster(canopymod_h_pramhus_ub, method='bilinear'))
canopy_diff_h_pramhus_ub <- (as.raster(canopymod_h_pramhus_ub)-terrainmod_h_pramhus_ub_resampeled)
plot(canopy_diff_h_pramhus_ub)

#h_pramhus_ub@data[h_pramhus_ub@data$Z>300] <- NA
#plot(h_pramhus_ub)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
halvard_pramhus_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Hedmark_Akershus/Halvard_Pramhus.las') 
h_pramhus_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='HP2',15:14]))
h_pramhus_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='HP2',15:14][h_pramhus_ub_order,]))
h_pramhus_ub_cut<-lasclip(halvard_pramhus_las,h_pramhus_ub_poly)
plot(h_pramhus_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_h_pramhus_ub_20x20 <-grid_terrain(h_pramhus_ub_cut,method='knnidw',res=1)
canopymod_h_pramhus_ub_20x20  <-grid_canopy(h_pramhus_ub_cut,res=1)

terrainmod_h_pramhus_ub_resampeled_20x20 <- resample(as.raster(terrainmod_h_pramhus_ub_20x20), as.raster(canopymod_h_pramhus_ub_20x20, method='bilinear'))
canopy_diff_h_pramhus_ub_20x20 <- (as.raster(canopymod_h_pramhus_ub_20x20)-terrainmod_h_pramhus_ub_resampeled_20x20)

#1 outlying very high point (like a bird?)
cellStats(canopy_diff_h_pramhus_ub_20x20,stat='max')
canopy_diff_h_pramhus_ub_20x20[canopy_diff_h_pramhus_ub_20x20>300] <- NA
canopy_diff_h_pramhus_ub_20x20 
plot(canopy_diff_h_pramhus_ub_20x20)

writeRaster(canopy_diff_h_pramhus_ub_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/h_pramhus_ub_canopyheight', overwrite=TRUE)




# Stangeskovene Aurskog ---------------------------------------------------


# stangeskovene aurskog_b
terrainmod_stangesk_aurskog_b  <-grid_terrain(stangesk_aurskog_b, method='knnidw',res=1)
canopymod_stangesk_aurskog_b   <-grid_canopy(stangesk_aurskog_b,res=1)

terrainmod_stangesk_aurskog_b_resampled <-resample(as.raster(terrainmod_stangesk_aurskog_b), as.raster(canopymod_stangesk_aurskog_b), method='bilinear')
canopy_diff_stangesk_aurskog_b<-(as.raster(canopymod_stangesk_aurskog_b)-terrainmod_stangesk_aurskog_b_resampled)
plot(canopy_diff_stangesk_aurskog_b)

trees_stangesk_aurskog_b<-tree_detection(stangesk_aurskog_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_stangesk_aurskog_b<-extract(canopy_diff_stangesk_aurskog_b,trees_stangesk_aurskog_b[,1:2])

lastrees_dalponte(stangesk_aurskog_b,canopy_diff_stangesk_aurskog_b,trees_stangesk_aurskog_b[treeheight_stangesk_aurskog_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_stangesk_aurskog_b<-tree_hulls(stangesk_aurskog_b,type='convex',field='treeID')
plot(canopy_diff_stangesk_aurskog_b)
plot(treeout_stangesk_aurskog_b,add=T) 

bigtrees_stangesk_aurskog_b<-which(extract(canopy_diff_stangesk_aurskog_b,treeout_stangesk_aurskog_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

stangesk_aurskog_b_clip<-lasclip(stangesk_aurskog_b,treeout_stangesk_aurskog_b@polygons[[bigtrees_stangesk_aurskog_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_stangesk_aurskog_b)){
  print(i)
  stangesk_aurskog_b_clip<-lasclip(stangesk_aurskog_b_clip,treeout_stangesk_aurskog_b@polygons[[bigtrees_stangesk_aurskog_b[i]]]@Polygons[[1]],inside=F)}
plot(stangesk_aurskog_b_clip) 

canopy_diff_stangesk_aurskog_b_clip <- (as.raster(grid_canopy(stangesk_aurskog_b_clip,res=0.5))-(crop(as.raster(grid_terrain(stangesk_aurskog_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(stangesk_aurskog_b_clip,res=0.5)))))
plot(canopy_diff_stangesk_aurskog_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
stangesk_aurskog_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SSA1',15:14]))
stangesk_aurskog_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SSA1',15:14][stangesk_aurskog_b_order,]))
stangesk_aurskog_b_cut<-lasclip(stangesk_aurskog_b_clip,stangesk_aurskog_b_poly)
plot(stangesk_aurskog_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_stangesk_aurskog_b_20x20 <-grid_terrain(stangesk_aurskog_b_cut,method='knnidw',res=1)
canopymod_stangesk_aurskog_b_20x20  <-grid_canopy(stangesk_aurskog_b_cut,res=1)

terrainmod_stangesk_aurskog_b_resampeled_20x20 <- resample(as.raster(terrainmod_stangesk_aurskog_b_20x20), as.raster(canopymod_stangesk_aurskog_b_20x20, method='bilinear'))
canopy_diff_stangesk_aurskog_b_20x20 <- (as.raster(canopymod_stangesk_aurskog_b_20x20)-terrainmod_stangesk_aurskog_b_resampeled_20x20)
plot(canopy_diff_stangesk_aurskog_b_20x20)

writeRaster(canopy_diff_stangesk_aurskog_b_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/stangesk_aurskog_b_canopyheight', overwrite=TRUE)



# stangeskovene aurskog_ub
terrainmod_stangesk_aurskog_ub <-grid_terrain(stangesk_aurskog_ub,method='knnidw',res=1)
canopymod_stangesk_aurskog_ub  <-grid_canopy(stangesk_aurskog_ub,res=1)

terrainmod_stangesk_aurskog_ub_resampeled <- resample(as.raster(terrainmod_stangesk_aurskog_ub), as.raster(canopymod_stangesk_aurskog_ub, method='bilinear'))
canopy_diff_stangesk_aurskog_ub <- (as.raster(canopymod_stangesk_aurskog_ub)-terrainmod_stangesk_aurskog_ub_resampeled)
plot(canopy_diff_stangesk_aurskog_ub)
#max 5.779


#Cutting the 32x32m square(with big trees removed) to 20x20 m
stangeskovene_aurskog_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Hedmark_Akershus/Stangeskovene_Aurskog.las') 
stangesk_aurskog_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SSA2',15:14]))
stangesk_aurskog_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SSA2',15:14][stangesk_aurskog_ub_order,]))
stangesk_aurskog_ub_cut<-lasclip(stangeskovene_aurskog_las,stangesk_aurskog_ub_poly)
plot(stangesk_aurskog_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_stangesk_aurskog_ub_20x20 <-grid_terrain(stangesk_aurskog_ub_cut,method='knnidw',res=1)
canopymod_stangesk_aurskog_ub_20x20  <-grid_canopy(stangesk_aurskog_ub_cut,res=1)

terrainmod_stangesk_aurskog_ub_resampeled_20x20 <- resample(as.raster(terrainmod_stangesk_aurskog_ub_20x20), as.raster(canopymod_stangesk_aurskog_ub_20x20, method='bilinear'))
canopy_diff_stangesk_aurskog_ub_20x20 <- (as.raster(canopymod_stangesk_aurskog_ub_20x20)-terrainmod_stangesk_aurskog_ub_resampeled_20x20)
plot(canopy_diff_stangesk_aurskog_ub_20x20)

writeRaster(canopy_diff_stangesk_aurskog_ub_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/stangesk_aurskog_ub_canopyheight', overwrite=TRUE)




# Stangeskovene eidskog ---------------------------------------------------


# stangeskovene eidskog_b
terrainmod_stangesk_eidskog_b  <-grid_terrain(stangesk_eidskog_b, method='knnidw',res=1)
canopymod_stangesk_eidskog_b   <-grid_canopy(stangesk_eidskog_b,res=1)

terrainmod_stangesk_eidskog_b_resampled <-resample(as.raster(terrainmod_stangesk_eidskog_b), as.raster(canopymod_stangesk_eidskog_b), method='bilinear')
canopy_diff_stangesk_eidskog_b<-(as.raster(canopymod_stangesk_eidskog_b)-terrainmod_stangesk_eidskog_b_resampled)
plot(canopy_diff_stangesk_eidskog_b)
#Max 3,085


#Cutting the 32x32m square(with big trees removed) to 20x20 m
stangeskovene_eidskog_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Hedmark_Akershus/Stangeskovene_Eidskog.las') 
stangesk_eidskog_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SSB1',15:14]))
stangesk_eidskog_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SSB1',15:14][stangesk_eidskog_b_order,]))
stangesk_eidskog_b_cut<-lasclip(stangeskovene_eidskog_las,stangesk_eidskog_b_poly)
plot(stangesk_eidskog_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_stangesk_eidskog_b_20x20 <-grid_terrain(stangesk_eidskog_b_cut,method='knnidw',res=1)
canopymod_stangesk_eidskog_b_20x20  <-grid_canopy(stangesk_eidskog_b_cut,res=1)

terrainmod_stangesk_eidskog_b_resampeled_20x20 <- resample(as.raster(terrainmod_stangesk_eidskog_b_20x20), as.raster(canopymod_stangesk_eidskog_b_20x20, method='bilinear'))
canopy_diff_stangesk_eidskog_b_20x20 <- (as.raster(canopymod_stangesk_eidskog_b_20x20)-terrainmod_stangesk_eidskog_b_resampeled_20x20)
plot(canopy_diff_stangesk_eidskog_b_20x20)

writeRaster(canopy_diff_stangesk_eidskog_b_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/stangesk_eidskog_b_canopyheight', overwrite=TRUE)


# stangeskovene eidskog_ub
terrainmod_stangesk_eidskog_ub <-grid_terrain(stangesk_eidskog_ub,method='knnidw',res=1)
canopymod_stangesk_eidskog_ub  <-grid_canopy(stangesk_eidskog_ub,res=1)

terrainmod_stangesk_eidskog_ub_resampeled <- resample(as.raster(terrainmod_stangesk_eidskog_ub), as.raster(canopymod_stangesk_eidskog_ub, method='bilinear'))
canopy_diff_stangesk_eidskog_ub <- (as.raster(canopymod_stangesk_eidskog_ub)-terrainmod_stangesk_eidskog_ub_resampeled)
plot(canopy_diff_stangesk_eidskog_ub)

trees_stangesk_eidskog_ub<-tree_detection(stangesk_eidskog_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_stangesk_eidskog_ub<-extract(canopy_diff_stangesk_eidskog_ub,trees_stangesk_eidskog_ub[,1:2])

lastrees_dalponte(stangesk_eidskog_ub,canopy_diff_stangesk_eidskog_ub,trees_stangesk_eidskog_ub[treeheight_stangesk_eidskog_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_stangesk_eidskog_ub<-tree_hulls(stangesk_eidskog_ub,type='convex',field='treeID')
plot(canopy_diff_stangesk_eidskog_ub)
plot(treeout_stangesk_eidskog_ub,add=T) 

bigtrees_stangesk_eidskog_ub<-which(extract(canopy_diff_stangesk_eidskog_ub,treeout_stangesk_eidskog_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

stangesk_eidskog_ub_clip<-lasclip(stangesk_eidskog_ub,treeout_stangesk_eidskog_ub@polygons[[bigtrees_stangesk_eidskog_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_stangesk_eidskog_ub)){
  print(i)
  stangesk_eidskog_ub_clip<-lasclip(stangesk_eidskog_ub_clip,treeout_stangesk_eidskog_ub@polygons[[bigtrees_stangesk_eidskog_ub[i]]]@Polygons[[1]],inside=F)}
plot(stangesk_eidskog_ub_clip) 

canopy_diff_stangesk_eidskog_ub_clip <- (as.raster(grid_canopy(stangesk_eidskog_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(stangesk_eidskog_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(stangesk_eidskog_ub_clip,res=0.5)))))
plot(canopy_diff_stangesk_eidskog_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
stangesk_eidskog_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SSB2',15:14]))
stangesk_eidskog_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SSB2',15:14][stangesk_eidskog_ub_order,]))
stangesk_eidskog_ub_cut<-lasclip(stangesk_eidskog_ub_clip,stangesk_eidskog_ub_poly)
plot(stangesk_eidskog_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_stangesk_eidskog_ub_20x20 <-grid_terrain(stangesk_eidskog_ub_cut,method='knnidw',res=1)
canopymod_stangesk_eidskog_ub_20x20  <-grid_canopy(stangesk_eidskog_ub_cut,res=1)

terrainmod_stangesk_eidskog_ub_resampeled_20x20 <- resample(as.raster(terrainmod_stangesk_eidskog_ub_20x20), as.raster(canopymod_stangesk_eidskog_ub_20x20, method='bilinear'))
canopy_diff_stangesk_eidskog_ub_20x20 <- (as.raster(canopymod_stangesk_eidskog_ub_20x20)-terrainmod_stangesk_eidskog_ub_resampeled_20x20)
plot(canopy_diff_stangesk_eidskog_ub_20x20)

writeRaster(canopy_diff_stangesk_eidskog_ub_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/stangesk_eidskog_ub_canopyheight', overwrite=TRUE)



# Stig Dahlen -------------------------------------------------------------


# stig_dahlen_b
terrainmod_stig_dahlen_b  <-grid_terrain(stig_dahlen_b, method='knnidw',res=1)
canopymod_stig_dahlen_b   <-grid_canopy(stig_dahlen_b,res=1)

terrainmod_stig_dahlen_b_resampled <-resample(as.raster(terrainmod_stig_dahlen_b), as.raster(canopymod_stig_dahlen_b), method='bilinear')
canopy_diff_stig_dahlen_b<-(as.raster(canopymod_stig_dahlen_b)-terrainmod_stig_dahlen_b_resampled)
plot(canopy_diff_stig_dahlen_b)

trees_stig_dahlen_b<-tree_detection(stig_dahlen_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_stig_dahlen_b<-extract(canopy_diff_stig_dahlen_b,trees_stig_dahlen_b[,1:2])

lastrees_dalponte(stig_dahlen_b,canopy_diff_stig_dahlen_b,trees_stig_dahlen_b[treeheight_stig_dahlen_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_stig_dahlen_b<-tree_hulls(stig_dahlen_b,type='convex',field='treeID')
plot(canopy_diff_stig_dahlen_b)
plot(treeout_stig_dahlen_b,add=T) 

bigtrees_stig_dahlen_b<-which(extract(canopy_diff_stig_dahlen_b,treeout_stig_dahlen_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

stig_dahlen_b_clip<-lasclip(stig_dahlen_b,treeout_stig_dahlen_b@polygons[[bigtrees_stig_dahlen_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_stig_dahlen_b)){
  print(i)
  stig_dahlen_b_clip<-lasclip(stig_dahlen_b_clip,treeout_stig_dahlen_b@polygons[[bigtrees_stig_dahlen_b[i]]]@Polygons[[1]],inside=F)}
plot(stig_dahlen_b_clip) 

canopy_diff_stig_dahlen_b_clip <- (as.raster(grid_canopy(stig_dahlen_b_clip,res=0.5))-(crop(as.raster(grid_terrain(stig_dahlen_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(stig_dahlen_b_clip,res=0.5)))))
plot(canopy_diff_stig_dahlen_b_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
stig_dahlen_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SD2',15:14]))
stig_dahlen_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SD2',15:14][stig_dahlen_b_order,]))
stig_dahlen_b_cut<-lasclip(stig_dahlen_b_clip,stig_dahlen_b_poly)
plot(stig_dahlen_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_stig_dahlen_b_20x20 <-grid_terrain(stig_dahlen_b_cut,method='knnidw',res=1)
canopymod_stig_dahlen_b_20x20  <-grid_canopy(stig_dahlen_b_cut,res=1)

terrainmod_stig_dahlen_b_resampeled_20x20 <- resample(as.raster(terrainmod_stig_dahlen_b_20x20), as.raster(canopymod_stig_dahlen_b_20x20, method='bilinear'))
canopy_diff_stig_dahlen_b_20x20 <- (as.raster(canopymod_stig_dahlen_b_20x20)-terrainmod_stig_dahlen_b_resampeled_20x20)
plot(canopy_diff_stig_dahlen_b_20x20)

writeRaster(canopy_diff_stig_dahlen_b_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/stig_dahlen_b_canopyheight', overwrite=TRUE)

# stig_dahlen_ub
terrainmod_stig_dahlen_ub <-grid_terrain(stig_dahlen_ub,method='knnidw',res=1)
canopymod_stig_dahlen_ub  <-grid_canopy(stig_dahlen_ub,res=1)

terrainmod_stig_dahlen_ub_resampeled <- resample(as.raster(terrainmod_stig_dahlen_ub), as.raster(canopymod_stig_dahlen_ub, method='bilinear'))
canopy_diff_stig_dahlen_ub <- (as.raster(canopymod_stig_dahlen_ub)-terrainmod_stig_dahlen_ub_resampeled)
plot(canopy_diff_stig_dahlen_ub)
#max 6,619

#Cutting the 32x32m square(with big trees removed) to 20x20 m
stig_dahlen_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Hedmark_Akershus/Stig_Dahlen.las') 
stig_dahlen_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SD1',15:14]))
stig_dahlen_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SD1',15:14][stig_dahlen_ub_order,]))
stig_dahlen_ub_cut<-lasclip(stig_dahlen_las,stig_dahlen_ub_poly)
plot(stig_dahlen_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_stig_dahlen_ub_20x20 <-grid_terrain(stig_dahlen_ub_cut,method='knnidw',res=1)
canopymod_stig_dahlen_ub_20x20  <-grid_canopy(stig_dahlen_ub_cut,res=1)

terrainmod_stig_dahlen_ub_resampeled_20x20 <- resample(as.raster(terrainmod_stig_dahlen_ub_20x20), as.raster(canopymod_stig_dahlen_ub_20x20, method='bilinear'))
canopy_diff_stig_dahlen_ub_20x20 <- (as.raster(canopymod_stig_dahlen_ub_20x20)-terrainmod_stig_dahlen_ub_resampeled_20x20)
plot(canopy_diff_stig_dahlen_ub_20x20)

writeRaster(canopy_diff_stig_dahlen_ub_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/stig_dahlen_ub_canopyheight', overwrite=TRUE)



# Truls Holm --------------------------------------------------------------


# truls_holm_b
terrainmod_truls_holm_b  <-grid_terrain(truls_holm_b, method='knnidw',res=1)
canopymod_truls_holm_b   <-grid_canopy(truls_holm_b,res=1)

terrainmod_truls_holm_b_resampled <-resample(as.raster(terrainmod_truls_holm_b), as.raster(canopymod_truls_holm_b), method='bilinear')
canopy_diff_truls_holm_b<-(as.raster(canopymod_truls_holm_b)-terrainmod_truls_holm_b_resampled)
plot(canopy_diff_truls_holm_b)
#max 6.814

#Cutting the 32x32m square(with big trees removed) to 20x20 m
truls_holm_las <-  readLAS('C:/Users/Ingrid/Documents/Master - Sustherb/orginale_las/Hedmark_Akershus/Truls_Holm.las') 
truls_holm_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='TH1',15:14]))
truls_holm_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='TH1',15:14][truls_holm_b_order,]))
truls_holm_b_cut<-lasclip(truls_holm_las,truls_holm_b_poly)
plot(truls_holm_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_truls_holm_b_20x20 <-grid_terrain(truls_holm_b_cut,method='knnidw',res=1)
canopymod_truls_holm_b_20x20  <-grid_canopy(truls_holm_b_cut,res=1)

terrainmod_truls_holm_b_resampeled_20x20 <- resample(as.raster(terrainmod_truls_holm_b_20x20), as.raster(canopymod_truls_holm_b_20x20, method='bilinear'))
canopy_diff_truls_holm_b_20x20 <- (as.raster(canopymod_truls_holm_b_20x20)-terrainmod_truls_holm_b_resampeled_20x20)
plot(canopy_diff_truls_holm_b_20x20)

writeRaster(canopy_diff_truls_holm_b_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/truls_holm_b_canopyheight', overwrite=TRUE)


# truls_holm_ub
terrainmod_truls_holm_ub <-grid_terrain(truls_holm_ub,method='knnidw',res=1)
canopymod_truls_holm_ub  <-grid_canopy(truls_holm_ub,res=1)


terrainmod_truls_holm_ub_resampeled <- resample(as.raster(terrainmod_truls_holm_ub), as.raster(canopymod_truls_holm_ub, method='bilinear'))
canopy_diff_truls_holm_ub <- (as.raster(canopymod_truls_holm_ub)-terrainmod_truls_holm_ub_resampeled)
plot(canopy_diff_truls_holm_ub)

trees_truls_holm_ub<-tree_detection(truls_holm_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_truls_holm_ub<-extract(canopy_diff_truls_holm_ub,trees_truls_holm_ub[,1:2])

lastrees_dalponte(truls_holm_ub,canopy_diff_truls_holm_ub,trees_truls_holm_ub[treeheight_truls_holm_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_truls_holm_ub<-tree_hulls(truls_holm_ub,type='convex',field='treeID')
plot(canopy_diff_truls_holm_ub)
plot(treeout_truls_holm_ub,add=T) 

bigtrees_truls_holm_ub<-which(extract(canopy_diff_truls_holm_ub,treeout_truls_holm_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

truls_holm_ub_clip<-lasclip(truls_holm_ub,treeout_truls_holm_ub@polygons[[bigtrees_truls_holm_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_truls_holm_ub)){
  print(i)
  truls_holm_ub_clip<-lasclip(truls_holm_ub_clip,treeout_truls_holm_ub@polygons[[bigtrees_truls_holm_ub[i]]]@Polygons[[1]],inside=F)}
plot(truls_holm_ub_clip) 

canopy_diff_truls_holm_ub_clip <- (as.raster(grid_canopy(truls_holm_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(truls_holm_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(truls_holm_ub_clip,res=0.5)))))
plot(canopy_diff_truls_holm_ub_clip)

#Cutting the 32x32m square(with big trees removed) to 20x20 m
truls_holm_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='TH2',15:14]))
truls_holm_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='TH2',15:14][truls_holm_ub_order,]))
truls_holm_ub_cut<-lasclip(truls_holm_ub_clip,truls_holm_ub_poly)
plot(truls_holm_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_truls_holm_ub_20x20 <-grid_terrain(truls_holm_ub_cut,method='knnidw',res=1)
canopymod_truls_holm_ub_20x20  <-grid_canopy(truls_holm_ub_cut,res=1)

terrainmod_truls_holm_ub_resampeled_20x20 <- resample(as.raster(terrainmod_truls_holm_ub_20x20), as.raster(canopymod_truls_holm_ub_20x20, method='bilinear'))
canopy_diff_truls_holm_ub_20x20 <- (as.raster(canopymod_truls_holm_ub_20x20)-terrainmod_truls_holm_ub_resampeled_20x20)
plot(canopy_diff_truls_holm_ub_20x20)

writeRaster(canopy_diff_truls_holm_ub_20x20,'Hedmark_Akershus/canopy_height_clipped_raster/truls_holm_ub_canopyheight', overwrite=TRUE)


# Sørem --------------------------------------------------------------

# sorem_b
terrainmod_sorem_b  <-grid_terrain(sorem_b, method='knnidw',res=1)
canopymod_sorem_b   <-grid_canopy(sorem_b,res=1)

terrainmod_sorem_b_resampled <-resample(as.raster(terrainmod_sorem_b), as.raster(canopymod_sorem_b), method='bilinear')
canopy_diff_sorem_b<-(as.raster(canopymod_sorem_b)-terrainmod_sorem_b_resampled)
plot(canopy_diff_sorem_b)
cellStats(canopy_diff_sorem_b,'max')

sorem_b_clip<-sorem_b
if(cellStats(canopy_diff_sorem_b,'max')>7) {
  trees_sorem_b<-tree_detection(sorem_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_sorem_b<-extract(canopy_diff_sorem_b,trees_sorem_b[,1:2])
  
  lastrees_dalponte(sorem_b,canopy_diff_sorem_b,trees_sorem_b[treeheight_sorem_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_sorem_b<-tree_hulls(sorem_b,type='convex',field='treeID')
  plot(canopy_diff_sorem_b)
  plot(treeout_sorem_b,add=T) 
  
  bigtrees_sorem_b<-which(extract(canopy_diff_sorem_b,treeout_sorem_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  sorem_b_clip<-lasclip(sorem_b,treeout_sorem_b@polygons[[bigtrees_sorem_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_sorem_b)){
    print(i)
    sorem_b_clip<-lasclip(sorem_b_clip,treeout_sorem_b@polygons[[bigtrees_sorem_b[i]]]@Polygons[[1]],inside=F)}
  plot(sorem_b_clip) 
  
  canopy_diff_sorem_b_clip <- (as.raster(grid_canopy(sorem_b_clip,res=0.5))-(crop(as.raster(grid_terrain(sorem_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(sorem_b_clip,res=0.5)))))
  plot(canopy_diff_sorem_b_clip)
}

#Cutting the 32x32m square(with big trees removed) to 20x20 m
#sorem_las <-  readLAS('data/clipped_las/sorem.las') 
sorem_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SK1',15:14]))
sorem_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SK1',15:14][sorem_b_order,]))
sorem_b_cut<-lasclip(sorem_b_clip,sorem_b_poly)
plot(sorem_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_sorem_b_20x20 <-grid_terrain(sorem_b_cut,method='knnidw',res=1)
canopymod_sorem_b_20x20  <-grid_canopy(sorem_b_cut,res=1)

terrainmod_sorem_b_resampeled_20x20 <- resample(as.raster(terrainmod_sorem_b_20x20), as.raster(canopymod_sorem_b_20x20, method='bilinear'))
canopy_diff_sorem_b_20x20 <- (as.raster(canopymod_sorem_b_20x20)-terrainmod_sorem_b_resampeled_20x20)
plot(canopy_diff_sorem_b_20x20)

writeRaster(canopy_diff_sorem_b_20x20,'data/canopy_height_clipped_raster/sorem_b_canopyheight', overwrite=TRUE)


# sorem_ub
terrainmod_sorem_ub <-grid_terrain(sorem_ub,method='knnidw',res=1)
canopymod_sorem_ub  <-grid_canopy(sorem_ub,res=1)


terrainmod_sorem_ub_resampeled <- resample(as.raster(terrainmod_sorem_ub), as.raster(canopymod_sorem_ub, method='bilinear'))
canopy_diff_sorem_ub <- (as.raster(canopymod_sorem_ub)-terrainmod_sorem_ub_resampeled)
plot(canopy_diff_sorem_ub)
cellStats(canopy_diff_sorem_ub,'max')

sorem_ub_clip<-sorem_ub
if(cellStats(canopy_diff_sorem_ub,'max')>7) {
trees_sorem_ub<-tree_detection(sorem_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_sorem_ub<-extract(canopy_diff_sorem_ub,trees_sorem_ub[,1:2])

lastrees_dalponte(sorem_ub,canopy_diff_sorem_ub,trees_sorem_ub[treeheight_sorem_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)

treeout_sorem_ub<-tree_hulls(sorem_ub,type='convex',field='treeID')
plot(canopy_diff_sorem_ub)
plot(treeout_sorem_ub,add=T) 

bigtrees_sorem_ub<-which(extract(canopy_diff_sorem_ub,treeout_sorem_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m

sorem_ub_clip<-lasclip(sorem_ub,treeout_sorem_ub@polygons[[bigtrees_sorem_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
for(i in 2:length(bigtrees_sorem_ub)){
  print(i)
  sorem_ub_clip<-lasclip(sorem_ub_clip,treeout_sorem_ub@polygons[[bigtrees_sorem_ub[i]]]@Polygons[[1]],inside=F)}
plot(sorem_ub_clip) 

canopy_diff_sorem_ub_clip <- (as.raster(grid_canopy(sorem_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(sorem_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(sorem_ub_clip,res=0.5)))))
plot(canopy_diff_sorem_ub_clip)
}
#Cutting the 32x32m square(with big trees removed) to 20x20 m
sorem_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SK2',15:14]))
sorem_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='SK2',15:14][sorem_ub_order,]))
sorem_ub_cut<-lasclip(sorem_ub_clip,sorem_ub_poly)
plot(sorem_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_sorem_ub_20x20 <-grid_terrain(sorem_ub_cut,method='knnidw',res=1)
canopymod_sorem_ub_20x20  <-grid_canopy(sorem_ub_cut,res=1)

terrainmod_sorem_ub_resampeled_20x20 <- resample(as.raster(terrainmod_sorem_ub_20x20), as.raster(canopymod_sorem_ub_20x20, method='bilinear'))
canopy_diff_sorem_ub_20x20 <- (as.raster(canopymod_sorem_ub_20x20)-terrainmod_sorem_ub_resampeled_20x20)
plot(canopy_diff_sorem_ub_20x20)

writeRaster(canopy_diff_sorem_ub_20x20,'data/canopy_height_clipped_raster/sorem_ub_canopyheight', overwrite=TRUE)


# Nes1 --------------------------------------------------------------

# nes1_b
terrainmod_nes1_b  <-grid_terrain(nes1_b, method='knnidw',res=1)
canopymod_nes1_b   <-grid_canopy(nes1_b,res=1)

terrainmod_nes1_b_resampled <-resample(as.raster(terrainmod_nes1_b), as.raster(canopymod_nes1_b), method='bilinear')
canopy_diff_nes1_b<-(as.raster(canopymod_nes1_b)-terrainmod_nes1_b_resampled)
plot(canopy_diff_nes1_b)
cellStats(canopy_diff_nes1_b,'max')

nes1_b_clip<-nes1_b
if(cellStats(canopy_diff_nes1_b,'max')>7) {
  trees_nes1_b<-tree_detection(nes1_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_nes1_b<-extract(canopy_diff_nes1_b,trees_nes1_b[,1:2])
  
  lastrees_dalponte(nes1_b,canopy_diff_nes1_b,trees_nes1_b[treeheight_nes1_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_nes1_b<-tree_hulls(nes1_b,type='convex',field='treeID')
  plot(canopy_diff_nes1_b)
  plot(treeout_nes1_b,add=T) 
  
  bigtrees_nes1_b<-which(extract(canopy_diff_nes1_b,treeout_nes1_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  nes1_b_clip<-lasclip(nes1_b,treeout_nes1_b@polygons[[bigtrees_nes1_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_nes1_b)){
    print(i)
    nes1_b_clip<-lasclip(nes1_b_clip,treeout_nes1_b@polygons[[bigtrees_nes1_b[i]]]@Polygons[[1]],inside=F)}
  plot(nes1_b_clip) 
  
  canopy_diff_nes1_b_clip <- (as.raster(grid_canopy(nes1_b_clip,res=0.5))-(crop(as.raster(grid_terrain(nes1_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(nes1_b_clip,res=0.5)))))
  plot(canopy_diff_nes1_b_clip)
}

#Cutting the 32x32m square(with big trees removed) to 20x20 m
#nes1_las <-  readLAS('data/clipped_las/nes1.las') 
nes1_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='DD2',15:14]))
nes1_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='DD2',15:14][nes1_b_order,]))
nes1_b_cut<-lasclip(nes1_b_clip,nes1_b_poly)
plot(nes1_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_nes1_b_20x20 <-grid_terrain(nes1_b_cut,method='knnidw',res=1)
canopymod_nes1_b_20x20  <-grid_canopy(nes1_b_cut,res=1)

terrainmod_nes1_b_resampeled_20x20 <- resample(as.raster(terrainmod_nes1_b_20x20), as.raster(canopymod_nes1_b_20x20, method='bilinear'))
canopy_diff_nes1_b_20x20 <- (as.raster(canopymod_nes1_b_20x20)-terrainmod_nes1_b_resampeled_20x20)
plot(canopy_diff_nes1_b_20x20)

writeRaster(canopy_diff_nes1_b_20x20,'data/canopy_height_clipped_raster/nes1_b_canopyheight', overwrite=TRUE)


# nes1_ub
terrainmod_nes1_ub <-grid_terrain(nes1_ub,method='knnidw',res=1)
canopymod_nes1_ub  <-grid_canopy(nes1_ub,res=1)


terrainmod_nes1_ub_resampeled <- resample(as.raster(terrainmod_nes1_ub), as.raster(canopymod_nes1_ub, method='bilinear'))
canopy_diff_nes1_ub <- (as.raster(canopymod_nes1_ub)-terrainmod_nes1_ub_resampeled)
plot(canopy_diff_nes1_ub)
cellStats(canopy_diff_nes1_ub,'max')

nes1_ub_clip<-nes1_ub
if(cellStats(canopy_diff_nes1_ub,'max')>7) {
  trees_nes1_ub<-tree_detection(nes1_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_nes1_ub<-extract(canopy_diff_nes1_ub,trees_nes1_ub[,1:2])
  
  lastrees_dalponte(nes1_ub,canopy_diff_nes1_ub,trees_nes1_ub[treeheight_nes1_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_nes1_ub<-tree_hulls(nes1_ub,type='convex',field='treeID')
  plot(canopy_diff_nes1_ub)
  plot(treeout_nes1_ub,add=T) 
  
  bigtrees_nes1_ub<-which(extract(canopy_diff_nes1_ub,treeout_nes1_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  nes1_ub_clip<-lasclip(nes1_ub,treeout_nes1_ub@polygons[[bigtrees_nes1_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_nes1_ub)){
    print(i)
    nes1_ub_clip<-lasclip(nes1_ub_clip,treeout_nes1_ub@polygons[[bigtrees_nes1_ub[i]]]@Polygons[[1]],inside=F)}
  plot(nes1_ub_clip) 
  
  canopy_diff_nes1_ub_clip <- (as.raster(grid_canopy(nes1_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(nes1_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(nes1_ub_clip,res=0.5)))))
  plot(canopy_diff_nes1_ub_clip)
}
#Cutting the 32x32m square(with big trees removed) to 20x20 m
nes1_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='DD1',15:14]))
nes1_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='DD1',15:14][nes1_ub_order,]))
nes1_ub_cut<-lasclip(nes1_ub_clip,nes1_ub_poly)
plot(nes1_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_nes1_ub_20x20 <-grid_terrain(nes1_ub_cut,method='knnidw',res=1)
canopymod_nes1_ub_20x20  <-grid_canopy(nes1_ub_cut,res=1)

terrainmod_nes1_ub_resampeled_20x20 <- resample(as.raster(terrainmod_nes1_ub_20x20), as.raster(canopymod_nes1_ub_20x20, method='bilinear'))
canopy_diff_nes1_ub_20x20 <- (as.raster(canopymod_nes1_ub_20x20)-terrainmod_nes1_ub_resampeled_20x20)
plot(canopy_diff_nes1_ub_20x20)

writeRaster(canopy_diff_nes1_ub_20x20,'data/canopy_height_clipped_raster/nes1_ub_canopyheight', overwrite=TRUE)

# Nes2 --------------------------------------------------------------

# nes2_b
terrainmod_nes2_b  <-grid_terrain(nes2_b, method='knnidw',res=1)
canopymod_nes2_b   <-grid_canopy(nes2_b,res=1)

terrainmod_nes2_b_resampled <-resample(as.raster(terrainmod_nes2_b), as.raster(canopymod_nes2_b), method='bilinear')
canopy_diff_nes2_b<-(as.raster(canopymod_nes2_b)-terrainmod_nes2_b_resampled)
plot(canopy_diff_nes2_b)
cellStats(canopy_diff_nes2_b,'max')

nes2_b_clip<-nes2_b
if(cellStats(canopy_diff_nes2_b,'max')>7) {
  trees_nes2_b<-tree_detection(nes2_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_nes2_b<-extract(canopy_diff_nes2_b,trees_nes2_b[,1:2])
  
  lastrees_dalponte(nes2_b,canopy_diff_nes2_b,trees_nes2_b[treeheight_nes2_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_nes2_b<-tree_hulls(nes2_b,type='convex',field='treeID')
  plot(canopy_diff_nes2_b)
  plot(treeout_nes2_b,add=T) 
  
  bigtrees_nes2_b<-which(extract(canopy_diff_nes2_b,treeout_nes2_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  nes2_b_clip<-lasclip(nes2_b,treeout_nes2_b@polygons[[bigtrees_nes2_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_nes2_b)){
    print(i)
    nes2_b_clip<-lasclip(nes2_b_clip,treeout_nes2_b@polygons[[bigtrees_nes2_b[i]]]@Polygons[[1]],inside=F)}
  plot(nes2_b_clip) 
  
  canopy_diff_nes2_b_clip <- (as.raster(grid_canopy(nes2_b_clip,res=0.5))-(crop(as.raster(grid_terrain(nes2_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(nes2_b_clip,res=0.5)))))
  plot(canopy_diff_nes2_b_clip)
}

#Cutting the 32x32m square(with big trees removed) to 20x20 m
#nes2_las <-  readLAS('data/clipped_las/nes2.las') 
nes2_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='OL2',15:14]))
nes2_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='OL2',15:14][nes2_b_order,]))
nes2_b_cut<-lasclip(nes2_b_clip,nes2_b_poly)
plot(nes2_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_nes2_b_20x20 <-grid_terrain(nes2_b_cut,method='knnidw',res=1)
canopymod_nes2_b_20x20  <-grid_canopy(nes2_b_cut,res=1)

terrainmod_nes2_b_resampeled_20x20 <- resample(as.raster(terrainmod_nes2_b_20x20), as.raster(canopymod_nes2_b_20x20, method='bilinear'))
canopy_diff_nes2_b_20x20 <- (as.raster(canopymod_nes2_b_20x20)-terrainmod_nes2_b_resampeled_20x20)
plot(canopy_diff_nes2_b_20x20)

writeRaster(canopy_diff_nes2_b_20x20,'data/canopy_height_clipped_raster/nes2_b_canopyheight', overwrite=TRUE)


# nes2_ub
terrainmod_nes2_ub <-grid_terrain(nes2_ub,method='knnidw',res=1)
canopymod_nes2_ub  <-grid_canopy(nes2_ub,res=1)


terrainmod_nes2_ub_resampeled <- resample(as.raster(terrainmod_nes2_ub), as.raster(canopymod_nes2_ub, method='bilinear'))
canopy_diff_nes2_ub <- (as.raster(canopymod_nes2_ub)-terrainmod_nes2_ub_resampeled)
plot(canopy_diff_nes2_ub)
cellStats(canopy_diff_nes2_ub,'max')

nes2_ub_clip<-nes2_ub
if(cellStats(canopy_diff_nes2_ub,'max')>7) {
  trees_nes2_ub<-tree_detection(nes2_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_nes2_ub<-extract(canopy_diff_nes2_ub,trees_nes2_ub[,1:2])
  
  lastrees_dalponte(nes2_ub,canopy_diff_nes2_ub,trees_nes2_ub[treeheight_nes2_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_nes2_ub<-tree_hulls(nes2_ub,type='convex',field='treeID')
  plot(canopy_diff_nes2_ub)
  plot(treeout_nes2_ub,add=T) 
  
  bigtrees_nes2_ub<-which(extract(canopy_diff_nes2_ub,treeout_nes2_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  nes2_ub_clip<-lasclip(nes2_ub,treeout_nes2_ub@polygons[[bigtrees_nes2_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_nes2_ub)){
    print(i)
    nes2_ub_clip<-lasclip(nes2_ub_clip,treeout_nes2_ub@polygons[[bigtrees_nes2_ub[i]]]@Polygons[[1]],inside=F)}
  plot(nes2_ub_clip) 
  
  canopy_diff_nes2_ub_clip <- (as.raster(grid_canopy(nes2_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(nes2_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(nes2_ub_clip,res=0.5)))))
  plot(canopy_diff_nes2_ub_clip)
}
#Cutting the 32x32m square(with big trees removed) to 20x20 m
nes2_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='OL1',15:14]))
nes2_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='OL1',15:14][nes2_ub_order,]))
nes2_ub_cut<-lasclip(nes2_ub_clip,nes2_ub_poly)
plot(nes2_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_nes2_ub_20x20 <-grid_terrain(nes2_ub_cut,method='knnidw',res=1)
canopymod_nes2_ub_20x20  <-grid_canopy(nes2_ub_cut,res=1)

terrainmod_nes2_ub_resampeled_20x20 <- resample(as.raster(terrainmod_nes2_ub_20x20), as.raster(canopymod_nes2_ub_20x20, method='bilinear'))
canopy_diff_nes2_ub_20x20 <- (as.raster(canopymod_nes2_ub_20x20)-terrainmod_nes2_ub_resampeled_20x20)
plot(canopy_diff_nes2_ub_20x20)

writeRaster(canopy_diff_nes2_ub_20x20,'data/canopy_height_clipped_raster/nes2_ub_canopyheight', overwrite=TRUE)


# Kongsvinger 1 --------------------------------------------------------------

# kongsvinger1_b
terrainmod_kongsvinger1_b  <-grid_terrain(kongsvinger1_b, method='knnidw',res=1)
canopymod_kongsvinger1_b   <-grid_canopy(kongsvinger1_b,res=1)

terrainmod_kongsvinger1_b_resampled <-resample(as.raster(terrainmod_kongsvinger1_b), as.raster(canopymod_kongsvinger1_b), method='bilinear')
canopy_diff_kongsvinger1_b<-(as.raster(canopymod_kongsvinger1_b)-terrainmod_kongsvinger1_b_resampled)
plot(canopy_diff_kongsvinger1_b)
cellStats(canopy_diff_kongsvinger1_b,'max')

kongsvinger1_b_clip<-kongsvinger1_b
if(cellStats(canopy_diff_kongsvinger1_b,'max')>7) {
  trees_kongsvinger1_b<-tree_detection(kongsvinger1_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_kongsvinger1_b<-extract(canopy_diff_kongsvinger1_b,trees_kongsvinger1_b[,1:2])
  
  lastrees_dalponte(kongsvinger1_b,canopy_diff_kongsvinger1_b,trees_kongsvinger1_b[treeheight_kongsvinger1_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_kongsvinger1_b<-tree_hulls(kongsvinger1_b,type='convex',field='treeID')
  plot(canopy_diff_kongsvinger1_b)
  plot(treeout_kongsvinger1_b,add=T) 
  
  bigtrees_kongsvinger1_b<-which(extract(canopy_diff_kongsvinger1_b,treeout_kongsvinger1_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  kongsvinger1_b_clip<-lasclip(kongsvinger1_b,treeout_kongsvinger1_b@polygons[[bigtrees_kongsvinger1_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_kongsvinger1_b)){
    print(i)
    kongsvinger1_b_clip<-lasclip(kongsvinger1_b_clip,treeout_kongsvinger1_b@polygons[[bigtrees_kongsvinger1_b[i]]]@Polygons[[1]],inside=F)}
  plot(kongsvinger1_b_clip) 
  
  canopy_diff_kongsvinger1_b_clip <- (as.raster(grid_canopy(kongsvinger1_b_clip,res=0.5))-(crop(as.raster(grid_terrain(kongsvinger1_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(kongsvinger1_b_clip,res=0.5)))))
  plot(canopy_diff_kongsvinger1_b_clip)
}

#Cutting the 32x32m square(with big trees removed) to 20x20 m
#kongsvinger1_las <-  readLAS('data/clipped_las/kongsvinger1.las') 
kongsvinger1_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='OIA1',15:14]))
kongsvinger1_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='OIA1',15:14][kongsvinger1_b_order,]))
kongsvinger1_b_cut<-lasclip(kongsvinger1_b_clip,kongsvinger1_b_poly)
plot(kongsvinger1_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_kongsvinger1_b_20x20 <-grid_terrain(kongsvinger1_b_cut,method='knnidw',res=1)
canopymod_kongsvinger1_b_20x20  <-grid_canopy(kongsvinger1_b_cut,res=1)

terrainmod_kongsvinger1_b_resampeled_20x20 <- resample(as.raster(terrainmod_kongsvinger1_b_20x20), as.raster(canopymod_kongsvinger1_b_20x20, method='bilinear'))
canopy_diff_kongsvinger1_b_20x20 <- (as.raster(canopymod_kongsvinger1_b_20x20)-terrainmod_kongsvinger1_b_resampeled_20x20)
plot(canopy_diff_kongsvinger1_b_20x20)

writeRaster(canopy_diff_kongsvinger1_b_20x20,'data/canopy_height_clipped_raster/kongsvinger1_b_canopyheight', overwrite=TRUE)


# kongsvinger1_ub
terrainmod_kongsvinger1_ub <-grid_terrain(kongsvinger1_ub,method='knnidw',res=1)
canopymod_kongsvinger1_ub  <-grid_canopy(kongsvinger1_ub,res=1)


terrainmod_kongsvinger1_ub_resampeled <- resample(as.raster(terrainmod_kongsvinger1_ub), as.raster(canopymod_kongsvinger1_ub, method='bilinear'))
canopy_diff_kongsvinger1_ub <- (as.raster(canopymod_kongsvinger1_ub)-terrainmod_kongsvinger1_ub_resampeled)
plot(canopy_diff_kongsvinger1_ub)
cellStats(canopy_diff_kongsvinger1_ub,'max')

kongsvinger1_ub_clip<-kongsvinger1_ub
if(cellStats(canopy_diff_kongsvinger1_ub,'max')>7) {
  trees_kongsvinger1_ub<-tree_detection(kongsvinger1_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_kongsvinger1_ub<-extract(canopy_diff_kongsvinger1_ub,trees_kongsvinger1_ub[,1:2])
  
  lastrees_dalponte(kongsvinger1_ub,canopy_diff_kongsvinger1_ub,trees_kongsvinger1_ub[treeheight_kongsvinger1_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_kongsvinger1_ub<-tree_hulls(kongsvinger1_ub,type='convex',field='treeID')
  plot(canopy_diff_kongsvinger1_ub)
  plot(treeout_kongsvinger1_ub,add=T) 
  
  bigtrees_kongsvinger1_ub<-which(extract(canopy_diff_kongsvinger1_ub,treeout_kongsvinger1_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  kongsvinger1_ub_clip<-lasclip(kongsvinger1_ub,treeout_kongsvinger1_ub@polygons[[bigtrees_kongsvinger1_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_kongsvinger1_ub)){
    print(i)
    kongsvinger1_ub_clip<-lasclip(kongsvinger1_ub_clip,treeout_kongsvinger1_ub@polygons[[bigtrees_kongsvinger1_ub[i]]]@Polygons[[1]],inside=F)}
  plot(kongsvinger1_ub_clip) 
  
  canopy_diff_kongsvinger1_ub_clip <- (as.raster(grid_canopy(kongsvinger1_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(kongsvinger1_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(kongsvinger1_ub_clip,res=0.5)))))
  plot(canopy_diff_kongsvinger1_ub_clip)
}
#Cutting the 32x32m square(with big trees removed) to 20x20 m
kongsvinger1_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='OIA2',15:14]))
kongsvinger1_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='OIA2',15:14][kongsvinger1_ub_order,]))
kongsvinger1_ub_cut<-lasclip(kongsvinger1_ub_clip,kongsvinger1_ub_poly)
plot(kongsvinger1_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_kongsvinger1_ub_20x20 <-grid_terrain(kongsvinger1_ub_cut,method='knnidw',res=1)
canopymod_kongsvinger1_ub_20x20  <-grid_canopy(kongsvinger1_ub_cut,res=1)

terrainmod_kongsvinger1_ub_resampeled_20x20 <- resample(as.raster(terrainmod_kongsvinger1_ub_20x20), as.raster(canopymod_kongsvinger1_ub_20x20, method='bilinear'))
canopy_diff_kongsvinger1_ub_20x20 <- (as.raster(canopymod_kongsvinger1_ub_20x20)-terrainmod_kongsvinger1_ub_resampeled_20x20)
plot(canopy_diff_kongsvinger1_ub_20x20)

writeRaster(canopy_diff_kongsvinger1_ub_20x20,'data/canopy_height_clipped_raster/kongsvinger1_ub_canopyheight', overwrite=TRUE)



# kongsvinger2 --------------------------------------------------------------

# kongsvinger2_b
terrainmod_kongsvinger2_b  <-grid_terrain(kongsvinger2_b, method='knnidw',res=1)
canopymod_kongsvinger2_b   <-grid_canopy(kongsvinger2_b,res=1)

terrainmod_kongsvinger2_b_resampled <-resample(as.raster(terrainmod_kongsvinger2_b), as.raster(canopymod_kongsvinger2_b), method='bilinear')
canopy_diff_kongsvinger2_b<-(as.raster(canopymod_kongsvinger2_b)-terrainmod_kongsvinger2_b_resampled)
plot(canopy_diff_kongsvinger2_b)
cellStats(canopy_diff_kongsvinger2_b,'max')

kongsvinger2_b_clip<-kongsvinger2_b
if(cellStats(canopy_diff_kongsvinger2_b,'max')>7) {
  trees_kongsvinger2_b<-tree_detection(kongsvinger2_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_kongsvinger2_b<-extract(canopy_diff_kongsvinger2_b,trees_kongsvinger2_b[,1:2])
  
  lastrees_dalponte(kongsvinger2_b,canopy_diff_kongsvinger2_b,trees_kongsvinger2_b[treeheight_kongsvinger2_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_kongsvinger2_b<-tree_hulls(kongsvinger2_b,type='convex',field='treeID')
  plot(canopy_diff_kongsvinger2_b)
  plot(treeout_kongsvinger2_b,add=T) 
  
  bigtrees_kongsvinger2_b<-which(extract(canopy_diff_kongsvinger2_b,treeout_kongsvinger2_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  kongsvinger2_b_clip<-lasclip(kongsvinger2_b,treeout_kongsvinger2_b@polygons[[bigtrees_kongsvinger2_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_kongsvinger2_b)){
    print(i)
    kongsvinger2_b_clip<-lasclip(kongsvinger2_b_clip,treeout_kongsvinger2_b@polygons[[bigtrees_kongsvinger2_b[i]]]@Polygons[[1]],inside=F)}
  plot(kongsvinger2_b_clip) 
  
  canopy_diff_kongsvinger2_b_clip <- (as.raster(grid_canopy(kongsvinger2_b_clip,res=0.5))-(crop(as.raster(grid_terrain(kongsvinger2_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(kongsvinger2_b_clip,res=0.5)))))
  plot(canopy_diff_kongsvinger2_b_clip)
}

#Cutting the 32x32m square(with big trees removed) to 20x20 m
#kongsvinger2_las <-  readLAS('data/clipped_las/kongsvinger2.las') 
kongsvinger2_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='JCD2',15:14]))
kongsvinger2_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='JCD2',15:14][kongsvinger2_b_order,]))
kongsvinger2_b_cut<-lasclip(kongsvinger2_b_clip,kongsvinger2_b_poly)
plot(kongsvinger2_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_kongsvinger2_b_20x20 <-grid_terrain(kongsvinger2_b_cut,method='knnidw',res=1)
canopymod_kongsvinger2_b_20x20  <-grid_canopy(kongsvinger2_b_cut,res=1)

terrainmod_kongsvinger2_b_resampeled_20x20 <- resample(as.raster(terrainmod_kongsvinger2_b_20x20), as.raster(canopymod_kongsvinger2_b_20x20, method='bilinear'))
canopy_diff_kongsvinger2_b_20x20 <- (as.raster(canopymod_kongsvinger2_b_20x20)-terrainmod_kongsvinger2_b_resampeled_20x20)
plot(canopy_diff_kongsvinger2_b_20x20)

writeRaster(canopy_diff_kongsvinger2_b_20x20,'data/canopy_height_clipped_raster/kongsvinger2_b_canopyheight', overwrite=TRUE)


# kongsvinger2_ub
terrainmod_kongsvinger2_ub <-grid_terrain(kongsvinger2_ub,method='knnidw',res=1)
canopymod_kongsvinger2_ub  <-grid_canopy(kongsvinger2_ub,res=1)


terrainmod_kongsvinger2_ub_resampeled <- resample(as.raster(terrainmod_kongsvinger2_ub), as.raster(canopymod_kongsvinger2_ub, method='bilinear'))
canopy_diff_kongsvinger2_ub <- (as.raster(canopymod_kongsvinger2_ub)-terrainmod_kongsvinger2_ub_resampeled)
plot(canopy_diff_kongsvinger2_ub)
cellStats(canopy_diff_kongsvinger2_ub,'max')

kongsvinger2_ub_clip<-kongsvinger2_ub
if(cellStats(canopy_diff_kongsvinger2_ub,'max')>7) {
  trees_kongsvinger2_ub<-tree_detection(kongsvinger2_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_kongsvinger2_ub<-extract(canopy_diff_kongsvinger2_ub,trees_kongsvinger2_ub[,1:2])
  
  lastrees_dalponte(kongsvinger2_ub,canopy_diff_kongsvinger2_ub,trees_kongsvinger2_ub[treeheight_kongsvinger2_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_kongsvinger2_ub<-tree_hulls(kongsvinger2_ub,type='convex',field='treeID')
  plot(canopy_diff_kongsvinger2_ub)
  plot(treeout_kongsvinger2_ub,add=T) 
  
  bigtrees_kongsvinger2_ub<-which(extract(canopy_diff_kongsvinger2_ub,treeout_kongsvinger2_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  kongsvinger2_ub_clip<-lasclip(kongsvinger2_ub,treeout_kongsvinger2_ub@polygons[[bigtrees_kongsvinger2_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_kongsvinger2_ub)){
    print(i)
    kongsvinger2_ub_clip<-lasclip(kongsvinger2_ub_clip,treeout_kongsvinger2_ub@polygons[[bigtrees_kongsvinger2_ub[i]]]@Polygons[[1]],inside=F)}
  plot(kongsvinger2_ub_clip) 
  
  canopy_diff_kongsvinger2_ub_clip <- (as.raster(grid_canopy(kongsvinger2_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(kongsvinger2_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(kongsvinger2_ub_clip,res=0.5)))))
  plot(canopy_diff_kongsvinger2_ub_clip)
}
#Cutting the 32x32m square(with big trees removed) to 20x20 m
kongsvinger2_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='JCD1',15:14]))
kongsvinger2_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='JCD1',15:14][kongsvinger2_ub_order,]))
kongsvinger2_ub_cut<-lasclip(kongsvinger2_ub_clip,kongsvinger2_ub_poly)
plot(kongsvinger2_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_kongsvinger2_ub_20x20 <-grid_terrain(kongsvinger2_ub_cut,method='knnidw',res=1)
canopymod_kongsvinger2_ub_20x20  <-grid_canopy(kongsvinger2_ub_cut,res=1)

terrainmod_kongsvinger2_ub_resampeled_20x20 <- resample(as.raster(terrainmod_kongsvinger2_ub_20x20), as.raster(canopymod_kongsvinger2_ub_20x20, method='bilinear'))
canopy_diff_kongsvinger2_ub_20x20 <- (as.raster(canopymod_kongsvinger2_ub_20x20)-terrainmod_kongsvinger2_ub_resampeled_20x20)
plot(canopy_diff_kongsvinger2_ub_20x20)

writeRaster(canopy_diff_kongsvinger2_ub_20x20,'data/canopy_height_clipped_raster/kongsvinger2_ub_canopyheight', overwrite=TRUE)


# maarud1 --------------------------------------------------------------

# maarud1_b
terrainmod_maarud1_b  <-grid_terrain(maarud1_b, method='knnidw',res=1)
canopymod_maarud1_b   <-grid_canopy(maarud1_b,res=1)

terrainmod_maarud1_b_resampled <-resample(as.raster(terrainmod_maarud1_b), as.raster(canopymod_maarud1_b), method='bilinear')
canopy_diff_maarud1_b<-(as.raster(canopymod_maarud1_b)-terrainmod_maarud1_b_resampled)
plot(canopy_diff_maarud1_b)
cellStats(canopy_diff_maarud1_b,'max')

maarud1_b_clip<-maarud1_b
if(cellStats(canopy_diff_maarud1_b,'max')>7) {
  trees_maarud1_b<-tree_detection(maarud1_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_maarud1_b<-extract(canopy_diff_maarud1_b,trees_maarud1_b[,1:2])
  
  lastrees_dalponte(maarud1_b,canopy_diff_maarud1_b,trees_maarud1_b[treeheight_maarud1_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_maarud1_b<-tree_hulls(maarud1_b,type='convex',field='treeID')
  plot(canopy_diff_maarud1_b)
  plot(treeout_maarud1_b,add=T) 
  
  bigtrees_maarud1_b<-which(extract(canopy_diff_maarud1_b,treeout_maarud1_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  maarud1_b_clip<-lasclip(maarud1_b,treeout_maarud1_b@polygons[[bigtrees_maarud1_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_maarud1_b)){
    print(i)
    maarud1_b_clip<-lasclip(maarud1_b_clip,treeout_maarud1_b@polygons[[bigtrees_maarud1_b[i]]]@Polygons[[1]],inside=F)}
  plot(maarud1_b_clip) 
  
  canopy_diff_maarud1_b_clip <- (as.raster(grid_canopy(maarud1_b_clip,res=0.5))-(crop(as.raster(grid_terrain(maarud1_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(maarud1_b_clip,res=0.5)))))
  plot(canopy_diff_maarud1_b_clip)
}

#Cutting the 32x32m square(with big trees removed) to 20x20 m
#maarud1_las <-  readLAS('data/clipped_las/maarud1.las') 
maarud1_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M1.2',15:14]))
maarud1_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M1.2',15:14][maarud1_b_order,]))
maarud1_b_cut<-lasclip(maarud1_b_clip,maarud1_b_poly)
plot(maarud1_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_maarud1_b_20x20 <-grid_terrain(maarud1_b_cut,method='knnidw',res=1)
canopymod_maarud1_b_20x20  <-grid_canopy(maarud1_b_cut,res=1)

terrainmod_maarud1_b_resampeled_20x20 <- resample(as.raster(terrainmod_maarud1_b_20x20), as.raster(canopymod_maarud1_b_20x20, method='bilinear'))
canopy_diff_maarud1_b_20x20 <- (as.raster(canopymod_maarud1_b_20x20)-terrainmod_maarud1_b_resampeled_20x20)
plot(canopy_diff_maarud1_b_20x20)

writeRaster(canopy_diff_maarud1_b_20x20,'data/canopy_height_clipped_raster/maarud1_b_canopyheight', overwrite=TRUE)


# maarud1_ub
terrainmod_maarud1_ub <-grid_terrain(maarud1_ub,method='knnidw',res=1)
canopymod_maarud1_ub  <-grid_canopy(maarud1_ub,res=1)


terrainmod_maarud1_ub_resampeled <- resample(as.raster(terrainmod_maarud1_ub), as.raster(canopymod_maarud1_ub, method='bilinear'))
canopy_diff_maarud1_ub <- (as.raster(canopymod_maarud1_ub)-terrainmod_maarud1_ub_resampeled)
plot(canopy_diff_maarud1_ub)
cellStats(canopy_diff_maarud1_ub,'max')

maarud1_ub_clip<-maarud1_ub
if(cellStats(canopy_diff_maarud1_ub,'max')>7) {
  trees_maarud1_ub<-tree_detection(maarud1_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_maarud1_ub<-extract(canopy_diff_maarud1_ub,trees_maarud1_ub[,1:2])
  
  lastrees_dalponte(maarud1_ub,canopy_diff_maarud1_ub,trees_maarud1_ub[treeheight_maarud1_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_maarud1_ub<-tree_hulls(maarud1_ub,type='convex',field='treeID')
  plot(canopy_diff_maarud1_ub)
  plot(treeout_maarud1_ub,add=T) 
  
  bigtrees_maarud1_ub<-which(extract(canopy_diff_maarud1_ub,treeout_maarud1_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  maarud1_ub_clip<-lasclip(maarud1_ub,treeout_maarud1_ub@polygons[[bigtrees_maarud1_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_maarud1_ub)){
    print(i)
    maarud1_ub_clip<-lasclip(maarud1_ub_clip,treeout_maarud1_ub@polygons[[bigtrees_maarud1_ub[i]]]@Polygons[[1]],inside=F)}
  plot(maarud1_ub_clip) 
  
  canopy_diff_maarud1_ub_clip <- (as.raster(grid_canopy(maarud1_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(maarud1_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(maarud1_ub_clip,res=0.5)))))
  plot(canopy_diff_maarud1_ub_clip)
}
#Cutting the 32x32m square(with big trees removed) to 20x20 m
maarud1_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M1.1',15:14]))
maarud1_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M1.1',15:14][maarud1_ub_order,]))
maarud1_ub_cut<-lasclip(maarud1_ub_clip,maarud1_ub_poly)
plot(maarud1_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_maarud1_ub_20x20 <-grid_terrain(maarud1_ub_cut,method='knnidw',res=1)
canopymod_maarud1_ub_20x20  <-grid_canopy(maarud1_ub_cut,res=1)

terrainmod_maarud1_ub_resampeled_20x20 <- resample(as.raster(terrainmod_maarud1_ub_20x20), as.raster(canopymod_maarud1_ub_20x20, method='bilinear'))
canopy_diff_maarud1_ub_20x20 <- (as.raster(canopymod_maarud1_ub_20x20)-terrainmod_maarud1_ub_resampeled_20x20)
plot(canopy_diff_maarud1_ub_20x20)

writeRaster(canopy_diff_maarud1_ub_20x20,'data/canopy_height_clipped_raster/maarud1_ub_canopyheight', overwrite=TRUE)


# maarud2 --------------------------------------------------------------

# maarud2_b
terrainmod_maarud2_b  <-grid_terrain(maarud2_b, method='knnidw',res=1)
canopymod_maarud2_b   <-grid_canopy(maarud2_b,res=1)

terrainmod_maarud2_b_resampled <-resample(as.raster(terrainmod_maarud2_b), as.raster(canopymod_maarud2_b), method='bilinear')
canopy_diff_maarud2_b<-(as.raster(canopymod_maarud2_b)-terrainmod_maarud2_b_resampled)
plot(canopy_diff_maarud2_b)
cellStats(canopy_diff_maarud2_b,'max')

maarud2_b_clip<-maarud2_b
if(cellStats(canopy_diff_maarud2_b,'max')>7) {
  trees_maarud2_b<-tree_detection(maarud2_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_maarud2_b<-extract(canopy_diff_maarud2_b,trees_maarud2_b[,1:2])
  
  lastrees_dalponte(maarud2_b,canopy_diff_maarud2_b,trees_maarud2_b[treeheight_maarud2_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_maarud2_b<-tree_hulls(maarud2_b,type='convex',field='treeID')
  plot(canopy_diff_maarud2_b)
  plot(treeout_maarud2_b,add=T) 
  
  bigtrees_maarud2_b<-which(extract(canopy_diff_maarud2_b,treeout_maarud2_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  maarud2_b_clip<-lasclip(maarud2_b,treeout_maarud2_b@polygons[[bigtrees_maarud2_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_maarud2_b)){
    print(i)
    maarud2_b_clip<-lasclip(maarud2_b_clip,treeout_maarud2_b@polygons[[bigtrees_maarud2_b[i]]]@Polygons[[1]],inside=F)}
  plot(maarud2_b_clip) 
  
  canopy_diff_maarud2_b_clip <- (as.raster(grid_canopy(maarud2_b_clip,res=0.5))-(crop(as.raster(grid_terrain(maarud2_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(maarud2_b_clip,res=0.5)))))
  plot(canopy_diff_maarud2_b_clip)
}

#Cutting the 32x32m square(with big trees removed) to 20x20 m
#maarud2_las <-  readLAS('data/clipped_las/maarud2.las') 
maarud2_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M2.2',15:14]))
maarud2_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M2.2',15:14][maarud2_b_order,]))
maarud2_b_cut<-lasclip(maarud2_b_clip,maarud2_b_poly)
plot(maarud2_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_maarud2_b_20x20 <-grid_terrain(maarud2_b_cut,method='knnidw',res=1)
canopymod_maarud2_b_20x20  <-grid_canopy(maarud2_b_cut,res=1)

terrainmod_maarud2_b_resampeled_20x20 <- resample(as.raster(terrainmod_maarud2_b_20x20), as.raster(canopymod_maarud2_b_20x20, method='bilinear'))
canopy_diff_maarud2_b_20x20 <- (as.raster(canopymod_maarud2_b_20x20)-terrainmod_maarud2_b_resampeled_20x20)
plot(canopy_diff_maarud2_b_20x20)

writeRaster(canopy_diff_maarud2_b_20x20,'data/canopy_height_clipped_raster/maarud2_b_canopyheight', overwrite=TRUE)


# maarud2_ub
terrainmod_maarud2_ub <-grid_terrain(maarud2_ub,method='knnidw',res=1)
canopymod_maarud2_ub  <-grid_canopy(maarud2_ub,res=1)


terrainmod_maarud2_ub_resampeled <- resample(as.raster(terrainmod_maarud2_ub), as.raster(canopymod_maarud2_ub, method='bilinear'))
canopy_diff_maarud2_ub <- (as.raster(canopymod_maarud2_ub)-terrainmod_maarud2_ub_resampeled)
plot(canopy_diff_maarud2_ub)
cellStats(canopy_diff_maarud2_ub,'max')

maarud2_ub_clip<-maarud2_ub
if(cellStats(canopy_diff_maarud2_ub,'max')>7) {
  trees_maarud2_ub<-tree_detection(maarud2_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_maarud2_ub<-extract(canopy_diff_maarud2_ub,trees_maarud2_ub[,1:2])
  
  lastrees_dalponte(maarud2_ub,canopy_diff_maarud2_ub,trees_maarud2_ub[treeheight_maarud2_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_maarud2_ub<-tree_hulls(maarud2_ub,type='convex',field='treeID')
  plot(canopy_diff_maarud2_ub)
  plot(treeout_maarud2_ub,add=T) 
  
  bigtrees_maarud2_ub<-which(extract(canopy_diff_maarud2_ub,treeout_maarud2_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  maarud2_ub_clip<-lasclip(maarud2_ub,treeout_maarud2_ub@polygons[[bigtrees_maarud2_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_maarud2_ub)){
    print(i)
    maarud2_ub_clip<-lasclip(maarud2_ub_clip,treeout_maarud2_ub@polygons[[bigtrees_maarud2_ub[i]]]@Polygons[[1]],inside=F)}
  plot(maarud2_ub_clip) 
  
  canopy_diff_maarud2_ub_clip <- (as.raster(grid_canopy(maarud2_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(maarud2_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(maarud2_ub_clip,res=0.5)))))
  plot(canopy_diff_maarud2_ub_clip)
}
#Cutting the 32x32m square(with big trees removed) to 20x20 m
maarud2_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M2.1',15:14]))
maarud2_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M2.1',15:14][maarud2_ub_order,]))
maarud2_ub_cut<-lasclip(maarud2_ub_clip,maarud2_ub_poly)
plot(maarud2_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_maarud2_ub_20x20 <-grid_terrain(maarud2_ub_cut,method='knnidw',res=1)
canopymod_maarud2_ub_20x20  <-grid_canopy(maarud2_ub_cut,res=1)

terrainmod_maarud2_ub_resampeled_20x20 <- resample(as.raster(terrainmod_maarud2_ub_20x20), as.raster(canopymod_maarud2_ub_20x20, method='bilinear'))
canopy_diff_maarud2_ub_20x20 <- (as.raster(canopymod_maarud2_ub_20x20)-terrainmod_maarud2_ub_resampeled_20x20)
plot(canopy_diff_maarud2_ub_20x20)

writeRaster(canopy_diff_maarud2_ub_20x20,'data/canopy_height_clipped_raster/maarud2_ub_canopyheight', overwrite=TRUE)

# maarud3 --------------------------------------------------------------

# maarud3_b
terrainmod_maarud3_b  <-grid_terrain(maarud3_b, method='knnidw',res=1)
canopymod_maarud3_b   <-grid_canopy(maarud3_b,res=1)

terrainmod_maarud3_b_resampled <-resample(as.raster(terrainmod_maarud3_b), as.raster(canopymod_maarud3_b), method='bilinear')
canopy_diff_maarud3_b<-(as.raster(canopymod_maarud3_b)-terrainmod_maarud3_b_resampled)
plot(canopy_diff_maarud3_b)
cellStats(canopy_diff_maarud3_b,'max')

maarud3_b_clip<-maarud3_b
if(cellStats(canopy_diff_maarud3_b,'max')>7) {
  trees_maarud3_b<-tree_detection(maarud3_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_maarud3_b<-extract(canopy_diff_maarud3_b,trees_maarud3_b[,1:2])
  
  lastrees_dalponte(maarud3_b,canopy_diff_maarud3_b,trees_maarud3_b[treeheight_maarud3_b>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_maarud3_b<-tree_hulls(maarud3_b,type='convex',field='treeID')
  plot(canopy_diff_maarud3_b)
  plot(treeout_maarud3_b,add=T) 
  
  bigtrees_maarud3_b<-which(extract(canopy_diff_maarud3_b,treeout_maarud3_b,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  maarud3_b_clip<-lasclip(maarud3_b,treeout_maarud3_b@polygons[[bigtrees_maarud3_b[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_maarud3_b)){
    print(i)
    maarud3_b_clip<-lasclip(maarud3_b_clip,treeout_maarud3_b@polygons[[bigtrees_maarud3_b[i]]]@Polygons[[1]],inside=F)}
  plot(maarud3_b_clip) 
  
  canopy_diff_maarud3_b_clip <- (as.raster(grid_canopy(maarud3_b_clip,res=0.5))-(crop(as.raster(grid_terrain(maarud3_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(maarud3_b_clip,res=0.5)))))
  plot(canopy_diff_maarud3_b_clip)
}

#Cutting the 32x32m square(with big trees removed) to 20x20 m
#maarud3_las <-  readLAS('data/clipped_las/maarud3.las') 
maarud3_b_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M3.2',15:14]))
maarud3_b_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M3.2',15:14][maarud3_b_order,]))
maarud3_b_cut<-lasclip(maarud3_b_clip,maarud3_b_poly)
plot(maarud3_b_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_maarud3_b_20x20 <-grid_terrain(maarud3_b_cut,method='knnidw',res=1)
canopymod_maarud3_b_20x20  <-grid_canopy(maarud3_b_cut,res=1)

terrainmod_maarud3_b_resampeled_20x20 <- resample(as.raster(terrainmod_maarud3_b_20x20), as.raster(canopymod_maarud3_b_20x20, method='bilinear'))
canopy_diff_maarud3_b_20x20 <- (as.raster(canopymod_maarud3_b_20x20)-terrainmod_maarud3_b_resampeled_20x20)
plot(canopy_diff_maarud3_b_20x20)

writeRaster(canopy_diff_maarud3_b_20x20,'data/canopy_height_clipped_raster/maarud3_b_canopyheight', overwrite=TRUE)


# maarud3_ub
terrainmod_maarud3_ub <-grid_terrain(maarud3_ub,method='knnidw',res=1)
canopymod_maarud3_ub  <-grid_canopy(maarud3_ub,res=1)


terrainmod_maarud3_ub_resampeled <- resample(as.raster(terrainmod_maarud3_ub), as.raster(canopymod_maarud3_ub, method='bilinear'))
canopy_diff_maarud3_ub <- (as.raster(canopymod_maarud3_ub)-terrainmod_maarud3_ub_resampeled)
plot(canopy_diff_maarud3_ub)
cellStats(canopy_diff_maarud3_ub,'max')

maarud3_ub_clip<-maarud3_ub
if(cellStats(canopy_diff_maarud3_ub,'max')>7) {
  trees_maarud3_ub<-tree_detection(maarud3_ub,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
  treeheight_maarud3_ub<-extract(canopy_diff_maarud3_ub,trees_maarud3_ub[,1:2])
  
  lastrees_dalponte(maarud3_ub,canopy_diff_maarud3_ub,trees_maarud3_ub[treeheight_maarud3_ub>=5,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
  
  treeout_maarud3_ub<-tree_hulls(maarud3_ub,type='convex',field='treeID')
  plot(canopy_diff_maarud3_ub)
  plot(treeout_maarud3_ub,add=T) 
  
  bigtrees_maarud3_ub<-which(extract(canopy_diff_maarud3_ub,treeout_maarud3_ub,fun=max,na.rm=T)>threshold) #identify trees larger than 7m
  
  maarud3_ub_clip<-lasclip(maarud3_ub,treeout_maarud3_ub@polygons[[bigtrees_maarud3_ub[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
  for(i in 2:length(bigtrees_maarud3_ub)){
    print(i)
    maarud3_ub_clip<-lasclip(maarud3_ub_clip,treeout_maarud3_ub@polygons[[bigtrees_maarud3_ub[i]]]@Polygons[[1]],inside=F)}
  plot(maarud3_ub_clip) 
  
  canopy_diff_maarud3_ub_clip <- (as.raster(grid_canopy(maarud3_ub_clip,res=0.5))-(crop(as.raster(grid_terrain(maarud3_ub_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(maarud3_ub_clip,res=0.5)))))
  plot(canopy_diff_maarud3_ub_clip)
}
#Cutting the 32x32m square(with big trees removed) to 20x20 m
maarud3_ub_order<-chull(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M3.1',15:14]))
maarud3_ub_poly<-Polygon(as.matrix(plotcoords_hedmark_akershus[plotcoords_hedmark_akershus$Uthegningi=='M3.1',15:14][maarud3_ub_order,]))
maarud3_ub_cut<-lasclip(maarud3_ub_clip,maarud3_ub_poly)
plot(maarud3_ub_cut) #20x20 m area as point cloud

#Make new canopy height model for 20x20 m square
terrainmod_maarud3_ub_20x20 <-grid_terrain(maarud3_ub_cut,method='knnidw',res=1)
canopymod_maarud3_ub_20x20  <-grid_canopy(maarud3_ub_cut,res=1)

terrainmod_maarud3_ub_resampeled_20x20 <- resample(as.raster(terrainmod_maarud3_ub_20x20), as.raster(canopymod_maarud3_ub_20x20, method='bilinear'))
canopy_diff_maarud3_ub_20x20 <- (as.raster(canopymod_maarud3_ub_20x20)-terrainmod_maarud3_ub_resampeled_20x20)
plot(canopy_diff_maarud3_ub_20x20)

writeRaster(canopy_diff_maarud3_ub_20x20,'data/canopy_height_clipped_raster/maarud3_ub_canopyheight', overwrite=TRUE)



# Test --------------------------------------------------------------------


# remove tall trees -see tree identification and masking
#test_list <- c(canopy_diff_bratsberg_b, canopy_diff_bratsberg_ub, canopy_diff_didrik_holmsen_b, canopy_diff_didrik_holmsen_ub)
#for (i in test_list) {
  
#}
#Funker det å lage for loop når trefjerningsalgoritmen tar inn både lasfila b eller ub og canopy difference fila? 

getValues(canopy_diff_h_pramhus_b_20x20)
summary(canopy_diff_h_pramhus_b_20x20)


#Make a table for some summary values
df1<-data.frame(matrix(nrow=2,ncol=3))
rownames(df1)<-c('bbub','bbb')
colnames(df1)<-c('Site name','Treatment','Median canpy height')  
df1[1,3]<-median(getValues(canopy_diff_h_pramhus_b_20x20),na.rm=T)
write.csv(df1,'myfunkytable.csv')

#calculate mean canopy height?
cellStats(canopy_diff_bratsberg_b, stat = 'mean')
cellStats(canopy_diff_bratsberg_ub, stat = 'mean')
cellStats(canopy_diff_bratsberg_b, stat = 'sd')
cellStats(canopy_diff_bratsberg_ub, stat = 'sd')


#Test: work flow: las -> canopy diff -> clip out big trees -> make new las without big trees -> canopy diff
#Bratsberg
terrainmod_bratsberg_b  <-grid_terrain(bratsberg_b, method='knnidw',res=1)
canopymod_bratsberg_b   <-grid_canopy(bratsberg_b,res=1)


terrainmod_bratsberg_b_resampled <-resample(as.raster(terrainmod_bratsberg_b), as.raster(canopymod_bratsberg_b), method='bilinear')
canopy_diff_bratsberg_b<-(as.raster(canopymod_bratsberg_b)-terrainmod_bratsberg_b_resampled)
plot(canopy_diff_bratsberg_b)

#Tree detection
trees_bratsberg_b<-tree_detection(bratsberg_b,ws=5,hmin=5)#Detect all trees >5m with moving window of 5m 
treeheight_bratsberg_b<-extract(canopy_diff_bratsberg_b,trees_bratsberg_b[,1:2])

lastrees_dalponte(bratsberg_b,canopy_diff_bratsberg_b,trees_bratsberg_b[treeheight_bratsberg_b>=4,],th_seed=0.05,th_cr=0.1)#Dalponte algorthim... Using the canopy height difference (not canopy model)
#Lastrees_dalponte seems to be the best method as it allows use of a canopy model.
#need to look further into arguments to ensure that whole tree is segmented


#Now make hulls around the trees
treeout<-tree_hulls(bratsberg_b,type='convex',field='treeID')

plot(canopy_diff_bratsberg_b)
plot(treeout,add=T) # These regions seem to be the big trees. Clip these out...

#Those greater than 7m
bigtrees<-which(extract(canopy_diff_bratsberg_b,treeout,fun=max,na.rm=T)>4)

#Clip out trees
bclip<-lasclip(bratsberg_b,treeout@polygons[[bigtrees[1]]]@Polygons[[1]],inside=F)
for(i in 2:length(bigtrees)){
  print(i)
  bclip<-lasclip(bclip,treeout@polygons[[bigtrees[i]]]@Polygons[[1]],inside=F)}
plot(bclip) 

plot(as.raster(grid_canopy(bclip,res=0.5))-(crop(as.raster(grid_terrain(bclip,method='knnidw',res=0.5)),as.raster(grid_canopy(bclip,res=0.5)))))


##Reading raster

test <- raster('Trondelag/canopy_height_clipped_raster/bratsberg_b_canopyheight')
plot(test)

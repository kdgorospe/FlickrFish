# CREAT MAP OF FLICKR SEARCH QUERY RESULTS
rm(list=ls())
outdir<-"~/Analyses/FlickrFish/RESULTS" 
indir<-"~/Analyses/FlickrFish"


library(sf)
library(ggplot2)


allfiguretheme<-theme_bw()+
  theme(panel.grid.minor = element_line(colour="transparent"), panel.grid.major = element_line(colour="transparent"),
        panel.border=element_rect(colour="black", size=1.5),
        panel.background = element_rect(fill = "white"),
        axis.text.x=element_text(size=12, colour="black"), # Controls size of x axis tickmark labels
        axis.text.y=element_text(size=12, colour="black"), # Controls size of y axis tickmark labels
        legend.text=element_text(size=8),
        legend.title=element_text(size=12),
        legend.position="bottom",
        plot.title=element_text(size=20))

setwd(indir)
usa_2_sf<-readRDS("gadm36_USA_2_sf.rds")

# Subset just Rhode Island
#ri_sf<-usa_2_sf[usa_2_sf$NAME_1=="Rhode Island",]
#ri_sf<-usa_2_sf[usa_2_sf$NAME_1 %in% c("Rhode Island", "Massachusetts"),]
ri_sf<-usa_2_sf[((usa_2_sf$NAME_1=="Rhode Island") | (usa_2_sf$NAME_1=="Massachusetts" & usa_2_sf$NAME_2=="Bristol")),]
ri_sf


setwd(outdir)
pdf("map_Narragansett.pdf")
p<-ggplot(data=ri_sf) +
  geom_sf() +
  allfiguretheme
print(p)
dev.off()

# Get lat/long flickr data
setwd(outdir)
lats<-read.csv("fish_lats.csv")
names(lats)<-c("id", "lat")
longs<-read.csv("fish_longs.csv")
names(longs)<-c("id", "long")
fishsites<-merge(lats, longs, by="id")

# Convert to an sf object:
fish_sf<-st_as_sf(fishsites, coords=c("long", "lat"), crs="+proj=longlat +datum=WGS84")



# Rhode Island Map with Fish Sites
setwd(outdir)
pdf("map_Narragansett_FlickrFishSites.pdf")
p<-ggplot() +
  geom_sf(data=ri_sf) +
  geom_sf(data=fish_sf, show.legend=FALSE)+
  #geom_sf(data=fish_sf, aes(shape=Site.Name, color=location), show.legend="point")+
  #scale_color_viridis_d()+
  allfiguretheme
print(p)
dev.off()
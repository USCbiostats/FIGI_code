#=============================================
# Create PC plots
#
# Misc plots including by country etc. 
#=============================================
library(dplyr)
library(data.table)
library(ggplot2)

# eigenvalues
eigenvals <- fread("~/data/PCA/190506/FIGI_GxESet_KGP_pc20_190430.eigenval") %>% 
  mutate(tot = sum(V1),
         pct = round(100*(V1/tot), 2),
         csum = cumsum(pct))

summarise (n = n()) %>%
  mutate(freq = n / sum(n))

# eigenvectors
rm(list = ls())

load("~/data/FIGI_EpiData_rdata/FIGI_Genotype_Epi_190424.RData")

# GxE set
gxe_set <- figi %>%
  filter(drop == 0 & gxe == 1)

# PCA Results
pc30k <- fread("~/data/PCA/190506/FIGI_GxESet_KGP_pc20_190430.eigenvec", skip = 1,
               col.names = c("FID", "IID", paste0(rep("PC", 20), seq(1,20)))) %>% 
  mutate(vcfid = IID)

df_tmp <- full_join(gxe_set, pc30k, by="vcfid") %>% 
  dplyr::select(vcfid, outc, race_self, study_gxe, study_site, study, platform, paste0(rep("PC", 20), seq(1,20)))

# add 1000G sample info for plotting
kgp_samples <- fread("~/data/PCA/integrated_call_samples_v3.20130502.ALL.panel.fix", stringsAsFactors = F) %>%
  dplyr::rename(vcfid = sample)

# final data.frame
df <- full_join(df_tmp, kgp_samples, by = "vcfid") %>% 
  mutate(race_self = factor(race_self, labels = c("Unknown", "AI_AN", "Asian", "Black", "NH_PI", "Other", "White")),
         group = factor(replace(super_pop, is.na(super_pop), 'FIGI'),
                        levels=c("FIGI","AFR", "AMR", "EAS", "EUR", "SAS")))


ggplot(data = df, aes(PC1, PC2, color = group)) +
  geom_point(alpha = 0.5) +
  labs(x = "PC1",
       y = "PC2",
       title = "PC1 vs PC2") +
  scale_colour_manual(values=c("gold", "red", "black", "purple", "green", "royalblue")) +
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches')) + scale_x_reverse()



ggplot(data = df, aes(PC1, PC2, color = race_self)) +
  geom_point(alpha = 0.5) +
  labs(x = "PC1",
       y = "PC2",
       title = "PC1 vs PC2") +
  scale_colour_manual(values=c("orange", "purple", "purple", "red", "royalblue", "orange", "green" )) +
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches')) + scale_x_reverse()









pool <- seq(0,1,by = 0.001) # for random sampling

set.seed(2018)
df <- full_join(df_tmp, kgp_samples, by = "vcfid") %>% 
  mutate(race_self = factor(race_self, labels = c("Unknown", "AI_AN", "Asian", "Black", "NH_PI", "Other", "White")),
         group = factor(replace(super_pop, is.na(super_pop), 'FIGI'),
                        levels=c("FIGI","AFR", "AMR", "EAS", "EUR", "SAS")),
         Country = factor(ifelse(study_site %in% c('Alabama', 'Boca Rat', 'CA', 'CO', 'CCF', 'Colorado', 'Detriot', 'DHMC', 'GA', 'Georgetown', 'Greensvi', 'H', 'Hartford', 'Hawaii', 'HAWAII', 'Henry Ford Health System', 'IA', 'Iowa', 'JHU CLUE,WASHCO MD USA', 'Kaiser', 'Kentucky', 'Los Angeles', 'Marshfield', 'Martin M', 'Mayo Foundation', 'Midwest', 'Minn', 'Minnesota', 'MN', 'Moffitt', 'Morton P', 'NC', 'NH', 'Northeast', 'Northwest region', 'OH', 'Pittsburgh', 'PR', 'Sarasota', 'SC', 'Seattle', 'South', 'St. Jose', 'St. Vinc', 'Tallahas', 'TX', 'UCO', 'UMN', 'UNC', 'UTR', 'USA, Midwest', 'USA, Northeast', 'USA, Southeast', 'USA, Southwest', 'USA, West', 'USC/KP', 'Utah', 'Washington', 'Watson C', 'West'), 'USA',
                          ifelse(study_site %in% c('Asturias', 'Barcelona', 'CRCBarcelona', 'Granada', 'Leon', 'Murcia', 'Navarra', 'Santiago', 'San Sebastian'), 'Spain', 
                          ifelse(study_site %in% c('Barts', 'Birmingham', 'Bristol', 'Bury', 'Cardiff', 'Cambridge', 'Croydon', 'Edinburgh', 'Glasgow', 'Hounslow', 'Leeds', 'Liverpool', 'Manchester', 'Middlesborough', 'Newcastle', 'Nottingham', 'Oxford', 'Reading', 'Sheffield', 'Stockport (pilot)', 'Stoke', 'Swansea', 'Wrexham', 'UK General Population', 'UK Health Conscious'), 'UK', 
                          ifelse(study_site %in% c('ESTHER1', 'ESTHER2', 'Heidelberg', 'Verdi', 'Potsdam'), 'Germany',
                          ifelse(study_site %in% c('Nantes', 'Northeast France', 'Northwest France', 'South coast France', 'South France'), 'France',
                          ifelse(study_site %in% c('Australia', 'Melbourne'), 'Australia', 
                          ifelse(study_site %in% c('CANADA, Eastern Canada', 'CANADA, Western Canada', 'Newfoundland', 'Ontario'), 'Canada', 
                          ifelse(study_site %in% c('CZ'), 'Czech Republic',
                          ifelse(study_site %in% c('Central Sweden', 'Umea'), 'Sweden',
                          ifelse(study_site %in% c('Bilthoven', 'Utrecht'), 'Netherlands',
                          ifelse(study_site %in% c('Florence', 'Naples', 'Ragusa', 'Turin', 'Varese'), 'Italy',
                          ifelse(study_site %in% c('Greece'), 'Greece',
                          ifelse(study %in% c('EDRN', 'HPFS', 'NCCCSI', 'NCCCSII', 'NHS', 'PHS', 'REACH', 'USC_HRT_CRC', 'SMS'), 'USA', 
                          ifelse(study %in% c('ATBC'), 'Finland', 
                          ifelse(study %in% c('MECC'), 'Israel', 
                          ifelse(study %in% c('SEARCH'), 'UK', 
                          ifelse(study %in% c('CORSA'), 'Austria', 
                          ifelse(study %in% c('DACHS', 'NGCCS'), 'Germany', NA)))))))))))))))))))) %>% 
  filter(!(is.na(Country)),
         Country != "USA")



ggplot(data = df, aes(PC1, PC2, color = Country)) +
  geom_point(alpha = 0.5) +
  labs(x = "PC1",
       y = "PC2",
       title = "PC1 vs PC2") + 
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches')) + scale_x_reverse()
ggsave("figures/tmp_pca_pc1_p2_country.png", width = 6, height = 4)



ggplot(data = df, aes(PC1, PC3, color = Country)) +
  geom_point(alpha = 0.5) +
  labs(x = "PC1",
       y = "PC3",
       title = "PC1 vs PC3") + 
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches')) + scale_x_reverse()
ggsave("figures/tmp_pca_pc1_p3_country.png", width = 6, height = 4)



ggplot(data = df, aes(PC1, PC4, color = Country)) +
  geom_point(alpha = 0.5) +
  labs(x = "PC1",
       y = "PC4",
       title = "PC1 vs PC4") + 
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches')) + scale_x_reverse()
ggsave("figures/tmp_pca_pc1_p4_country.png", width = 6, height = 4)





# first, generate pairwise plots 
for(pc in 1:19) {
  for(npc in (eval(pc+1):20)){
    
    xpc <- paste0('PC', pc)
    ypc <- paste0('PC', npc)
    filename = paste0("~/Dropbox/code/FIGI_PCA/working/", xpc, "_", ypc, '.png')
    
    p <- ggplot(data = df, aes(eval(parse(text=xpc)), eval(parse(text=ypc)), color = Group)) + 
      geom_point(alpha = 0.5) + 
      labs(x = xpc,
           y = ypc,
           title = paste0(ypc, " vs. ", xpc)) + 
      scale_colour_manual(values=c("gold", "red", "black", "purple", "green", "royalblue")) +
      theme_classic() +
      theme(legend.key.size = unit(0.15, 'inches'))
    
    ggsave(p, filename = filename)
  }
}



# might be helpful to have some plots WITHOUT KGP (for comparison)
for(pc in 1:19) {
  for(npc in (eval(pc+1):20)){
    
    xpc <- paste0('PC', pc)
    ypc <- paste0('PC', npc)
    filename = paste0("~/Dropbox/code/FIGI_PCA/working/", xpc, "_", ypc, '_noKGP.png')
    
    p <- ggplot(data = df %>% filter(!is.na(race_self)), aes(eval(parse(text=xpc)), eval(parse(text=ypc)), color = Group)) + 
      geom_point(alpha = 0.5) + 
      labs(x = xpc,
           y = ypc,
           title = paste0(ypc, " vs. ", xpc)) + 
      scale_colour_manual(values=c("gold", "red", "black", "purple", "green", "royalblue")) +
      theme_classic() +
      theme(legend.key.size = unit(0.15, 'inches'))
    
    ggsave(p, filename = filename)
  }
}




# PC VS NOISE (to visualize single PC)
for(pc in 1:20) {
  xpc <- paste0('PC', pc)
  filename = paste0("~/Dropbox/code/FIGI_PCA/working/", xpc, "_test", ".png")
  
  p <- ggplot(data = df, aes(eval(parse(text=xpc)), test, color = Group)) + 
    geom_point(alpha = 0.5) + 
    labs(x = xpc,
         y = 'Jitter',
         title = paste0("Jitter", " vs. ", xpc)) + 
    scale_colour_manual(values=c("gold", "red", "black", "purple", "green", "royalblue")) +
    theme_classic() +
    theme(legend.key.size = unit(0.15, 'inches'))
  
  ggsave(p, filename = filename)
}





# by race_self

# NHW
for(pc in 1:20) {
  xpc <- paste0('PC', pc)
  filename = paste0("~/Dropbox/code/FIGI_PCA/working/", xpc, "_raceself_white", ".png")
  
  p <- ggplot(data = df %>% filter(race_self == "White"), aes(eval(parse(text=xpc)), test, color = race_self)) + 
    geom_point(alpha = 0.5) + 
    labs(x = xpc,
         y = 'Jitter',
         title = paste0("Jitter", " vs. ", xpc, " - White")) + 
    scale_colour_manual(values=c("green")) +
    theme_classic() +
    theme(legend.key.size = unit(0.15, 'inches'))
  
  ggsave(p, filename = filename)
}


# black asian ai_an nh_pi
for(pc in 1:20) {
  xpc <- paste0('PC', pc)
  filename = paste0("~/Dropbox/code/FIGI_PCA/working/", xpc, "_raceself_blacketc", ".png")
  
  p <- ggplot(data = df %>% filter(race_self %in% c("Asian", "Black", "NH_PI", "AI_AN")), aes(eval(parse(text=xpc)), test, color = race_self)) + 
    geom_point(alpha = 0.5) + 
    labs(x = xpc,
         y = 'Jitter',
         title = paste0("Jitter", " vs. ", xpc, " - Black,Asian,AI_AN,NH_PI")) + 
    scale_colour_manual(values=c("black", "purple", "red", "royalblue")) +
    theme_classic() +
    theme(legend.key.size = unit(0.15, 'inches'))
  
  ggsave(p, filename = filename)
}


# black asian ai_an nh_pi
for(pc in 1:20) {
  xpc <- paste0('PC', pc)
  filename = paste0("~/Dropbox/code/FIGI_PCA/working/", xpc, "_raceself_others", ".png")
  
  p <- ggplot(data = df %>% filter(race_self %in% c("Unknown", "Other")), aes(eval(parse(text=xpc)), test, color = race_self)) + 
    geom_point(alpha = 0.5) + 
    labs(x = xpc,
         y = 'Jitter',
         title = paste0("Jitter", " vs. ", xpc, " - Others/Unknown")) + 
    scale_colour_manual(values=c("cyan", "darksalmon")) +
    theme_classic() +
    theme(legend.key.size = unit(0.15, 'inches'))
  
  ggsave(p, filename = filename)
}




###################
##################
###################

# what is average pc3 level by country...
pf <- df %>% 
  filter(!is.na(Country)) %>% 
  filter(!Country %in% c("UK", "USA") ) %>% 
  group_by(Country) %>% 
  summarise(avgPC3 = mean(PC3)) %>% 
  arrange(avgPC3) %>% 
  mutate(Country = factor(Country, levels = c("Israel", "Greece", "Italy", "Spain", "France", "Australia", "Austria", "Germany", "Czech Republic", "Canada", "Netherlands", "Sweden", "Finland")))

# x <- df %>%
#   filter(!is.na(Country)) %>% 
#   filter(!Country %in% c("UK", "USA")) %>% 
#   mutate(Country = factor(Country, levels = c("Israel", "Greece", "Italy", "Spain", "France", "Australia", "Austria", "Germany", "Czech Republic", "Canada", "Netherlands", "Sweden", "Finland")))
# 
# table(x$Country)
# table(x$Country, useNA = 'ifany')


p <- ggplot(data = df %>%
              filter(!is.na(Country)) %>% 
              filter(!Country %in% c("UK", "USA")) %>% 
              mutate(Country = factor(Country, levels = c("Israel", "Greece", "Italy", "Spain", "France", "Australia", "Austria", "Germany", "Czech Republic", "Canada", "Netherlands", "Sweden", "Finland"))), aes(PC3, test, color = Country)) +
  geom_point(alpha = 0.5) +
  labs(x = 'PC3',
       y = 'Noise',
       title = "PC1 vs Noise") +
  #scale_colour_manual(values=c("black", "purple", "red", "royalblue", "green")) +
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches'))
p



for(pc in 1:20) {
  xpc <- paste0('PC', pc)
  filename = paste0("~/Dropbox/code/FIGI_PCA/working/", xpc, "_Country_no_UK_USA", ".png")
  
  
  pf <- df %>% 
    filter(!is.na(Country)) %>% 
    filter(!Country %in% c("UK", "USA") ) %>% 
    group_by(Country) %>% 
    summarise(avgPC = mean(eval(parse(text=xpc)))) %>% 
    arrange(avgPC) 
  
  p <- ggplot(data = df %>%
                filter(!is.na(Country)) %>% 
                filter(!Country %in% c("UK", "USA")) %>% 
                mutate(Country = factor(Country, levels = as.character(pf$Country))), aes(eval(parse(text=xpc)), test, color = Country)) + 
    geom_point(alpha = 0.5) + 
    labs(x = xpc,
         y = 'Jitter',
         title = paste0("Jitter", " vs. ", xpc, " - Country (No UK/USA)")) + 
    #scale_colour_manual(values=c("cyan", "darksalmon")) +
    theme_classic() +
    theme(legend.key.size = unit(0.15, 'inches'))
  
  ggsave(p, filename = filename)
}



for(pc in 1:20) {
  xpc <- paste0('PC', pc)
  filename = paste0("~/Dropbox/code/FIGI_PCA/working/", xpc, "_Country_UK_USA", ".png")
  
  
  p <- ggplot(data = df %>%
                filter(!is.na(Country)) %>% 
                filter(Country %in% c("UK", "USA")), aes(eval(parse(text=xpc)), test, color = Country)) + 
    geom_point(alpha = 0.5) + 
    labs(x = xpc,
         y = 'Jitter',
         title = paste0("Jitter", " vs. ", xpc, " - Country (UK/USA)")) + 
    #scale_colour_manual(values=c("cyan", "darksalmon")) +
    theme_classic() +
    theme(legend.key.size = unit(0.15, 'inches'))
  
  ggsave(p, filename = filename)
}






p <- ggplot(data = df %>%
              filter(!Country %in% c("UK", "USA"), !is.na(Country)) %>% 
              mutate(Country = factor(Country, levels = c(""))), aes(PC3, test, color = Country)) +
  geom_point(alpha = 0.5) +
  labs(x = 'PC3',
       y = 'Noise',
       title = "PC1 vs Noise") +
  #scale_colour_manual(values=c("black", "purple", "red", "royalblue", "green")) +
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches'))
p



p <- ggplot(data = df %>% filter(Country %in% c("UK", "USA"), !is.na(Country)), aes(PC3, test, color = Country)) +
  geom_point(alpha = 0.5) +
  labs(x = 'PC3',
       y = 'Noise',
       title = "PC1 vs Noise") +
  #scale_colour_manual(values=c("black", "purple", "red", "royalblue", "green")) +
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches'))
p





p <- ggplot(data = df %>% filter(!is.na(race_self), race_self %in% c("Unknown", "Other")), aes(PC1, PC2, color = race_self)) +
  geom_point(alpha = 0.5) +
  labs(x = 'PC1',
       y = 'PC2',
       title = "PC1 vs PC2") +
  scale_colour_manual(values=c("black", "red")) +
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches'))
p




# Quick Run

# plot combined dataset
p <- ggplot(data = df, aes(PC1, test, color = Group)) +
  geom_point(alpha = 0.5) +
  labs(x = 'PC1',
       y = 'PC2',
       title = "PC1 vs PC2") +
  scale_colour_manual(values=c("gold", "red", "black", "purple", "green", "royalblue")) +
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches'))
p



# plot combined dataset
p <- ggplot(data = df %>% filter(race_self == "White" | is.na(race_self)), aes(PC1, PC5, color = Group)) +
  geom_point(alpha = 0.5) +
  labs(x = 'PC1',
       y = 'PC2',
       title = "PC1 vs PC2") +
  scale_colour_manual(values=c("black", "red", "yellow", "purple", "green", "royalblue")) +
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches'))
p





p <- ggplot(data = df %>% filter(race_self != "White"), aes(PC1, PC2, color = Group)) +
  geom_point(alpha = 0.5) +
  labs(x = 'PC1',
       y = 'PC2',
       title = "PC1 vs PC2") +
  scale_colour_manual(values=c("black", "red", "yellow", "purple", "green", "royalblue")) +
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches'))
p


# who are these non-whites
nonwhite <- filter(df, race_self != "White")
table(nonwhite$studyname)




# FILTER KGP from your result
x.kgp <- filter(x, !is.na(super_pop))

p <- ggplot(data = x.kgp %>% arrange(Group), aes(PC1, PC2, color = Group)) +
  geom_point(alpha = 0.5) +
  labs(x = 'PC1',
       y = 'PC2') +
  scale_colour_manual(values=c("red", "yellow", "purple", "green", "royalblue")) +
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches'))
p


# Whites Only
w <- filter(All_Merged, race_self == "White") %>%
  dplyr::select(vcfid) %>%
  dplyr::rename(IID = vcfid) %>%
  bind_rows(kgp_samples[, 'IID', drop = F])

x.w <- inner_join(x, w, by = 'IID')

p <- ggplot(data = x.w %>% arrange(Group), aes(PC1, PC2, color = Group)) +
  geom_point(alpha = 0.5) +
  labs(x = 'PC1',
       y = 'PC2',
       title = "PC1 vs PC2") +
  scale_colour_manual(values=c("black", "red", "yellow", "purple", "green", "royalblue")) +
  theme_classic() +
  theme(legend.key.size = unit(0.15, 'inches'))
p



#------------------------------------------------
# Graphs by subsets
# To be Continued... 
#------------------------------------------------
kgp <- fread("~/work/FIGI_TestRun_85k/integrated_call_samples_v3.20130502.ALL.panel.fix", stringsAsFactors = F) %>%
  rename(IID = sample)
pca <- fread("~/work/FIGI_TestRun_85k/ALL_Merged_20KSNPS_KGP.eigenvec", stringsAsFactors = F, col.names = c("FID", "IID", paste0(rep("PC", 10), seq(1,10))))

# data.plot <- full_join(pca, kgp, by = "IID") %>%
# 	mutate(Group = factor(replace(super_pop,is.na(super_pop), 'FIGI'),
# 												levels=c("FIGI","AFR", "AMR", "EAS", "EUR", "SAS")))


plotpc.race <- function(pc1, pc2, group) {
  # pc1 = "PC1"
  # pc2 = "PC2"
  # group = "White"
  z <- bind_rows(All_Merged[which(All_Merged$race_self_new == group), 'IID', drop=F], kgp[, 'IID', drop=F])
  tmp.dat <- full_join(pca, kgp, by = "IID") %>%
    mutate(Group = factor(replace(super_pop, is.na(super_pop), group),
                          levels=c(group,"AFR", "AMR", "EAS", "EUR", "SAS"))) %>% filter(IID %in% z$IID)
  N <- nrow(tmp.dat)-2504
  filename = paste0("~/Dropbox/", group, "_", pc1, "_", pc2, ".png")
  
  p <- ggplot(data = tmp.dat %>% 
                arrange(Group), 
              aes(eval(parse(text = pc1)), eval(parse(text = pc2)), 
                  color = Group)) + 
    geom_point(alpha = 0.5) + 
    labs(x = pc1,
         y = pc2,
         title = paste0(pc1, " vs. ", pc2, " (N = ", N , ")")) + 
    scale_colour_manual(values=c("black", "red", "yellow", "purple", "green", "royalblue")) +
    theme_classic() +
    theme(legend.key.size = unit(0.15, 'inches'))
  p
  
  ggsave(p, filename = filename, width = 9.5, height = 6)
}




# self_race - pc1, pc2, pc3
table(All_Merged$race_self_new)		

plotpc.race('PC1', 'PC2', group = "Unknown")
plotpc.race('PC1', 'PC2', group = "AI_AN")
plotpc.race('PC1', 'PC2', group = "Asian")
plotpc.race('PC1', 'PC2', group = "Black")
plotpc.race('PC1', 'PC2', group = "NH_PI")
plotpc.race('PC1', 'PC2', group = "Other")
plotpc.race('PC1', 'PC2', group = "White")

plotpc.race('PC1', 'PC3', group = "Unknown")
plotpc.race('PC1', 'PC3', group = "AI_AN")
plotpc.race('PC1', 'PC3', group = "Asian")
plotpc.race('PC1', 'PC3', group = "Black")
plotpc.race('PC1', 'PC3', group = "NH_PI")
plotpc.race('PC1', 'PC3', group = "Other")
plotpc.race('PC1', 'PC3', group = "White")

plotpc.race('PC2', 'PC3', group = "Unknown")
plotpc.race('PC2', 'PC3', group = "AI_AN")
plotpc.race('PC2', 'PC3', group = "Asian")
plotpc.race('PC2', 'PC3', group = "Black")
plotpc.race('PC2', 'PC3', group = "NH_PI")
plotpc.race('PC2', 'PC3', group = "Other")
plotpc.race('PC2', 'PC3', group = "White")


# # KGP ONLY
# # (looks much better, i don't think you can calculate PCs by chunks?)
# # use plink2 --pca approx
# rm(list = ls())
# 
# pca <- fread("~/work/FIGI_TestRun_85k/del.kgp.eigenvec", stringsAsFactors = F, col.names = c("FID", "IID", paste0(rep("PC", 10), seq(1,10))))
# 
# kgp <- fread("~/work/FIGI_TestRun_85k/integrated_call_samples_v3.20130502.ALL.panel.fix", stringsAsFactors = F) %>%
# 	rename(IID = sample)
# 
# x <- inner_join(pca, kgp, by = 'IID') %>%
# 	mutate(Group = factor(super_pop,
# 												levels=c("AFR", "AMR", "EAS", "EUR", "SAS")))
# 
# p <- ggplot(data = x %>% arrange(Group), aes(PC1, PC2, color = Group)) + 
# 	geom_point(alpha = 0.5) + 
# 	labs(x = 'PC1',
# 			 y = 'PC2') + 
# 	scale_colour_manual(values=c("red", "yellow", "purple", "green", "royalblue")) +
# 	theme_classic() +
# 	theme(legend.key.size = unit(0.15, 'inches'))
# p



#===============================================
# PCA Plots
# pairwise comparisons
#===============================================

## PCA Plots
library(dplyr)
library(data.table)
library(ggplot2)

pca <- fread("/home/rak/work/figi.analysis.180109/figi.hrc.KGP.pca.eigenvec", stringsAsFactors = F, col.names = c("FID", "IID", paste0(rep("PC", 10), seq(1,10))))

kgp <- fread("/home/rak/work/figi.analysis.180109/integrated_call_samples_v3.20130502.ALL.panel", header = T, stringsAsFactors = F) %>% rename(IID = sample)

# load('/home/rak/work/figi.analysis.180109/FIGI_Matching_HRC_EPI_IDs_ver7.RData')
# sample <- hrc_epi %>%
#   mutate(IID = id) %>%
#   select(IID, gecco_study_l, race) %>%
#   filter(!is.na(race))

x <- full_join(pca, kgp, by = 'IID') %>%
  mutate(Group = factor(replace(super_pop,is.na(super_pop), "CORECT"),
                        levels=c("CORECT","AFR", "AMR", "EAS", "EUR", "SAS")))


## generate pairwise PC plots
for(pc in 1:9) {
  for(npc in (eval(pc+1):10)){
    
    xpc <- paste0('PC', pc)
    ypc <- paste0('PC', npc)
    filename = paste0("/home/rak/Dropbox/", xpc, "_", ypc, '.png')
    
    p <- ggplot(data = x %>% arrange(Group), aes(eval(parse(text=xpc)), eval(parse(text=ypc)), color = Group)) + 
      geom_point(alpha = 0.5) + 
      labs(x = xpc,
           y = ypc,
           title = paste0(ypc, " vs. ", xpc)) + 
      scale_colour_manual(values=c("yellow", "red", "black", "purple", "green", "royalblue")) +
      theme_classic() +
      theme(legend.key.size = unit(0.15, 'inches'))
    
    ggsave(p, filename = filename)
  }
}




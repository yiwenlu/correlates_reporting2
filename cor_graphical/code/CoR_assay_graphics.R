#-----------------------------------------------
# obligatory to append to the top of each script
renv::activate(project = here::here(".."))
source(here::here("..", "_common.R"))
#-----------------------------------------------
source(here::here("code", "params.R"))
source(here::here("code", "covid_corr_plot_functions.R"))
library(ggpubr) # for function theme_pubr()
library(scales) # for label_math
library(ggplot2)
library(tidyr)

dat.long.cor.subset <- readRDS(here(
  "data_clean",
  "long_cor_data.rds"
))
if (!is.null(config$assay_metadata)) {pos.cutoffs = assay_metadata$pos.cutoff; names(pos.cutoffs) <- assays}
#dat.cor.subset <- readRDS(here(
#  "data_clean",
#  "cor_data.rds"
#))

# path for figures
save.results.to <- here::here("output")
if (!dir.exists(save.results.to))  dir.create(save.results.to)
save.results.to <- paste0(here::here("output"), "/", attr(config,"config"));
if (!dir.exists(save.results.to))  dir.create(save.results.to)
save.results.to <- paste0(save.results.to, "/", COR,"/");
if (!dir.exists(save.results.to))  dir.create(save.results.to)
print(paste0("save.results.to equals ", save.results.to))

# Determine times for particular analyses
nums <- as.numeric(gsub("[^\\d]+", "", times, perl=TRUE))
tps <- times[nums%in%tpeak]

if (COR != "D29VLvariant") {
  #=========================================================================================================================
  # Reverse empirical cdf (rcdf) plots, 
  # stratified by treatment group and event status, in baseline negative or positive subjects
  # We made four ggplot objects, each for one assay, and combine them with ggarrange
  #=========================================================================================================================
  
  for (tp in tps){
    dat.long.cor.subset$TrtEvent <- 
      factor(
        paste(as.character(dat.long.cor.subset$Trt), 
              as.character(dat.long.cor.subset$cohort_event),sep = ", "),
        levels = c("Placebo, Non-Cases", "Placebo, Cases",
                   "Vaccine, Non-Cases", "Vaccine, Cases"))
    
    
    # if (tp %in% c("Day57", "Delta57overB")) {  ## day 57 analysis don't include intercurrent cases
    #   dat.long.cor.subset <- dat.long.cor.subset %>% filter(cohort_event != "Intercurrent Cases" & ph2.D57==1)
    # }
    
    rcdf_list <- vector("list", length(assays))
    for (aa in seq_along(assays)) {
      rcdf_list[[aa]] <- ggplot(subset(dat.long.cor.subset, assay == assays[aa]), 
                                aes_string(
                                  x = tp, 
                                  colour = "TrtEvent", 
                                  linetype = "cohort_event",
                                  weight = config.cor$wt
                                )
      ) +
        geom_step(aes(y = 1 - ..y..), stat = "ecdf", lwd = 1) +
        theme_pubr(legend = "none") +
        ylab("Reverse ECDF") + xlab(labels.axis[tp, aa]) +
        scale_x_continuous(labels = label_math(10^.x), limits = c(-2, 6), breaks = seq(-2, 6, 2)) +
        scale_color_manual(values = c("#1749FF", "#D92321", "#0AB7C9", "#FF6F1B")) +
        guides(linetype = "none",
               color = guide_legend(nrow = 3, byrow = TRUE)) +
        ggtitle(labels.title2[tp, aa]) +
        theme(plot.title = element_text(hjust = 0.5, size = ifelse(length(assays)>6, 6, 14)),
              legend.title = element_blank(),
              legend.text = element_text(size = 14),
              panel.grid.minor.y = element_line(),
              panel.grid.major.y = element_line(),
              axis.title = element_text(size = ifelse(length(assays)>6, 8, 14)),
              axis.text = element_text(size = 14))
    }
    
    if (length(assays) > 6) {ncol_val = 3} else {ncol_val = 2}
    ggsave(ggarrange(plotlist = rcdf_list, ncol = ncol_val, nrow=ceiling(length(assays) / ncol_val),
                     common.legend = TRUE, legend = "bottom",
                     align = "h"),
           filename = paste0(save.results.to, "/Marker_RCDF_", tp, 
                             "_trt_by_event_status_bstatus_", 
                             study_name,".png"),
           height = 7, width = 6.5)
    
    
  }
  
  
  
  ##===========================================================================
  ## Box plots comparing the day 57 assay readouts between case/non-case and 
  ## vaccine-placebo for four different assays
  ##===========================================================================
  ## make another subsample datasets such that the jitter plot for each subgroup in each panel contains no more
  ## than 50 data points
  set.seed(12345)
  dat.sample4 <-  dat.long.cor.subset %>%
    filter(., .$Trt == "Vaccine") %>% 
    split(., list(.$assay, .$cohort_event)) %>%
    lapply(., function(x) {
      if(nrow(x) <= 100) {
        return(x)
      } else {
        return(x[sample(1:nrow(x), size = 100),])
      }}) %>% bind_rows
  ##===============================================================================================================
  ## Box plots, overlayed with boxplots and jittered sample points, for the distribution of day 57 assay readouts
  ## versus the case-control status among the vaccine recipients, stratified by the baseline sero-status
  ##===============================================================================================================
  
  
  
  for (tp in tps){
    subdat <- dat.long.cor.subset
    subdat_jitter <- dat.sample4
    
    # if (tp %in% c("Day57", "Delta57overB")) {
    #   subdat <- dat.long.cor.subset %>% filter(cohort_event != "Intercurrent Cases" & ph2.D57==1)
    #   subdat_jitter <- subdat_jitter %>% filter(cohort_event != "Intercurrent Cases" & ph2.D57==1)
    # }
    
    boxplot_list <- vector("list", length(assays))
    for (aa in seq_along(assays)) {
      boxplot_list[[aa]] <-  ggplot(subset(subdat, assay == assays[aa] & Trt == "Vaccine"), 
                                    aes_string(x = "cohort_event", y = tp)) +
        geom_boxplot(aes(colour = cohort_event), width = 0.6, lwd = 1, outlier.shape = NA) + 
        stat_boxplot(geom = "errorbar", aes(colour = cohort_event), width = 0.45, lwd = 1) +
        geom_jitter(data = filter(subdat_jitter, assay == assays[aa] & Trt == "Vaccine"), 
                    mapping = aes(colour = cohort_event), width = 0.1, 
                    size = 1.4, alpha = 0.2, show.legend = FALSE) +
        theme_pubr(legend = "none") + 
        #guides(alpha = "none") +
        ylab(labels.axis[tp, aa]) + xlab("") + ggtitle(labels.title2[tp, aa]) +
        scale_color_manual(values = c("#1749FF", "#D92321")) +
        scale_y_continuous(limits = c(ifelse(study_name=="PROFISCOV",-1,-2), ifelse(study_name=="PROFISCOV",3.5,6)), labels = label_math(10^.x), 
                           breaks = seq(ifelse(study_name=="PROFISCOV",-1,-2), ifelse(study_name=="PROFISCOV",3.5,6), 2)) +
        theme(plot.title = element_text(hjust = 0.5, size = ifelse(length(assays)>6, 8, 14)),
              panel.border = element_rect(fill = NA),
              panel.grid.minor.y = element_line(),
              panel.grid.major.y = element_line(),
              axis.title = element_text(size = ifelse(length(assays)>6, 10, 14)),
              axis.text.x = element_text(size = 14),
              axis.text.y = element_text(size = 14),
              strip.text = element_text(size = 14, face = "bold"),
              legend.title = element_blank(),
              legend.text = element_text(size = 14),)
      if (!grepl("delta", tp, ignore.case = TRUE)) {
        boxplot_list[[aa]] <- boxplot_list[[aa]] + 
          geom_hline(yintercept = log10(lloqs[assays][aa]), linetype = 2, color = "black", lwd = 1) +
          geom_hline(yintercept = log10(uloqs[assays][aa]), linetype = 2, color = "black", lwd = 1)
      }
      
      if (!is.na(pos.cutoffs[aa])) {
        boxplot_list[[aa]] <- boxplot_list[[aa]] + 
          geom_hline(yintercept = log10(pos.cutoffs[assays][aa]), linetype = 2, color = "black", lwd = 1) 
      } else {
        boxplot_list[[aa]] <- boxplot_list[[aa]] + 
          geom_hline(yintercept = log10(lods[assays][aa]), linetype = 2, color = "black", lwd = 1)
      }
      
      
    }
    
    # Suppress hline warnings
    if (length(assays) > 6) {ncol_val = 3} else {ncol_val = 2}
    suppressWarnings(ggsave(ggarrange(plotlist = boxplot_list, 
                     ncol = ncol_val, nrow=ceiling(length(assays) / ncol_val), 
                     common.legend = TRUE, legend = "bottom",
                     align = "h") + 
             theme(plot.title = element_text(hjust = 0.5, size = 10)),
           filename = paste0(save.results.to, "/boxplots_", tp, "_trt_vaccine_x_cc_",
                             study_name, ".png"),
           height = 9, width = 8))
    
  }
  
  
  
  
  
  
  
  
  
  
  ##===============================================================================================================
  ## Box plots, overlayed with boxplots and jittered sample points, for the distribution of baseline, day 57, or 
  ## fold-rise in assay readouts versus the case-control status among the vaccine recipients, 
  ## stratified by the baseline serostatus, age group and risk group
  ##===============================================================================================================
  set.seed(12345)
  dat.sample5 <-  dat.long.cor.subset %>%
    filter(., .$Trt == "Vaccine") %>%
    split(., list(.$assay, .$cohort_event, .$demo_lab)) %>%
    lapply(., function(x) {
      if(nrow(x) <= 100) {
        return(x)
      } else {
        return(x[sample(1:nrow(x), size = 100),])
      }}) %>% bind_rows
  
  
  
  for (tp in tps){
    subdat <-dat.long.cor.subset
    subdat_jitter <- dat.sample5
  
    for (aa in seq_along(assays)) {
      boxplots <-  ggplot(subset(subdat, assay == assays[aa] & Trt == "Vaccine"), aes_string(x = "cohort_event", y = tp)) +
        geom_boxplot(aes(colour = cohort_event), width = 0.6, lwd = 1) + 
        stat_boxplot(geom = "errorbar", aes(colour = cohort_event), width = 0.45, lwd = 1, outlier.shape = NA) +
        geom_jitter(data = filter(subdat_jitter, assay == assays[aa] & Trt == "Vaccine"),
                    mapping = aes(colour = cohort_event), width = 0.1, 
                    size = 1.4, alpha = 0.2, show.legend = FALSE) +
        theme_pubr() + 
        guides(#alpha = "none", 
               color = guide_legend(nrow = 1, byrow = TRUE)) +
        facet_wrap(~ demo_lab) +
        ylab(labels.axis[tp, aa]) + xlab("") + ggtitle(labels.title2[tp, aa]) +
        scale_color_manual(values = c("#1749FF", "#D92321")) +
        scale_y_continuous(limits = c(-2, 6), labels = label_math(10^.x), breaks = seq(-2, 6, 2)) +
        theme(plot.title = element_text(hjust = 0.5, size = 14),
              panel.border = element_rect(fill = NA),
              panel.grid.minor.y = element_line(),
              panel.grid.major.y = element_line(),
              axis.title = element_text(size = 14),
              axis.text.x = element_text(size = 14),
              axis.text.y = element_text(size = 14),
              strip.text = element_text(size = 14, face = "bold"),
              legend.position = "bottom",
              legend.title = element_blank(),
              legend.text = element_text(size = 14))
      
      if (!grepl("delta", tp, ignore.case = TRUE)) {
        boxplots <- boxplots + 
          geom_hline(yintercept = log10(lods[assays][aa]), linetype = 2, color = "black", lwd = 1) +
          geom_hline(yintercept = log10(lloqs[assays][aa]), linetype = 2, color = "black", lwd = 1) +
          geom_hline(yintercept = log10(uloqs[assays][aa]), linetype = 2, color = "black", lwd = 1)
      }
      
      
      ggsave(boxplots,
             filename = paste0(save.results.to, "/boxplots_", tp,"_trt_vaccine_x_cc_",
                               assays[aa], "_", study_name, ".png"),
             height = 9,
             width = 8)
    }
  }
}

# #-----------------------------------------------
# # Spaghetti PLOTS not required for generalization, so commenting this out for now
# #-----------------------------------------------
# # - Spaghetti plots of antibody marker change over time
# #-----------------------------------------------
# 
# ## in each baseline serostatus group, randomly select 10 placebo recipients and 20 vaccine recipients
# set.seed(12345)
# 
# # First we need to restrict to ph2.D57==1 if has57==true, to remove participants without day57 ab readings
# if(has57) {
#   dat.cor.subset.spaghetti <- filter(dat.cor.subset, ph2.D57==1)
#   dat.long.cor.subset.spaghetti <- filter(dat.long.cor.subset, ph2.D57==1)
# } else {
#   dat.cor.subset.spaghetti <- dat.cor.subset
#   dat.long.cor.subset.spaghetti <- dat.long.cor.subset
# }
# 
# 
# var_names <- expand.grid(times = intersect(c("B", "Day29", "Day57"), times),
#                          assays = assays) %>%
#   mutate(var_names = paste0(times, assays)) %>%
#   .[, "var_names"]
# 
# spaghetti_ptid <- dat.cor.subset.spaghetti[, c("Ptid", "Trt", var_names, "cohort_event")] %>%
#   filter(., complete.cases(.), Trt == 1) %>%
#   transmute(cohort_event = cohort_event,
#             Ptid = Ptid) %>%
#   split(., list(.$cohort_event)) %>%
#   lapply(function(xx) {
#     if (nrow(xx) <= 20) {
#       return(xx$Ptid)
#     } else {
#       return(sample(xx$Ptid, 20))
#     }
#   }) %>% unlist %>% as.character
# 
# spaghetti_dat <- dat.long.cor.subset.spaghetti[, c("Ptid", "cohort_event", "assay",
#                                          intersect(c("B", "Day29", "Day57"), times))] %>%
#   filter(Ptid %in% spaghetti_ptid) %>%
#   pivot_longer(cols = intersect(c("B", "Day29", "Day57"), times),
#                names_to = "time") %>%
#   mutate(assay_label = factor(assay, levels = assays, labels = labels.assays.short[assays]),
#          time_label = factor(time, levels = intersect(c("B", "Day29", "Day57"), times),
#                              labels = c("D1", "D29", "D57")[c("B", "Day29", "Day57") %in% times])) %>%
#   as.data.frame
# 
# 
# subdat <- spaghetti_dat
# covid_corr_spaghetti_facets(plot_dat = subdat,
#                             x = "time_label",
#                             y = "value",
#                             id = "Ptid",
#                             color = "cohort_event",
#                             facet_by = "assay_label",
#                             plot_title = "Vaccine group",
#                             ylim = c(-2, 6),
#                             ybreaks = seq(-2, 6, by = 2),
#                             filename = paste0(
#                               save.results.to, "/spaghetti_plot_trt_",
#                               study_name, ".png"
#                             ),
#                             height = 6, width = 5)
# 


# RCDF, SA, nab_reference, nab_Delta, nab_Beta, for vaccine and placebo, respectively
# RCDF, LA, nab_reference, nab_Zeta, nab_Mu, nab_Gamma, nab_Lambda, for vaccine and placebo, respectively
if (attr(config,"config") == "janssen_partA_VL" & COR == "D29VLvariant") {
    
  for (ab in c("bAb", "nAb")) {
    
    for (reg in c(0, 1, 2)){
    
      if (reg==0 && ab=="nAb") next # doesn't need nAb for US
      
      reg_lb = case_when(reg==0 ~ "NAM",
                         reg==1 ~ "LATAM",
                         reg==2 ~ "ZA",
                         TRUE ~ "")
      
      assay_subset <- if(ab=="bAb" && reg==0) {c("bindSpike","bindSpike_P.1")
      } else if(ab=="bAb" && reg==1) {c("bindSpike","bindSpike_B.1.621","bindSpike_P.1","bindSpike_C.37")
      } else if(ab=="bAb" && reg==2) {c("bindSpike","bindSpike_DeltaMDW","bindSpike_B.1.351")
      } else if (ab=="nAb" && reg==1) {c("pseudoneutid50","pseudoneutid50_Zeta","pseudoneutid50_Mu","pseudoneutid50_Gamma","pseudoneutid50_Lambda")
      } else if (ab=="nAb" && reg==2) {c("pseudoneutid50","pseudoneutid50_Delta","pseudoneutid50_Beta")}
      
      rcdf_list = NULL
      for (aa in seq_along(assay_subset)) {
        
        var = case_when(assay_subset[aa] %in% c("bindSpike", "pseudoneutid50") ~ "",
                        assay_subset[aa] %in% c("bindSpike_DeltaMDW", "pseudoneutid50_Delta") ~ "-Delta",
                        assay_subset[aa] %in% c("bindSpike_B.1.351", "pseudoneutid50_Beta") ~ "-Beta",
                        assay_subset[aa] %in% c("pseudoneutid50_Zeta") ~ "-Zeta",
                        assay_subset[aa] %in% c("bindSpike_B.1.621","pseudoneutid50_Mu") ~ "-Mu",
                        assay_subset[aa] %in% c("bindSpike_P.1","pseudoneutid50_Gamma") ~ "-Gamma",
                        assay_subset[aa] %in% c("bindSpike_C.37","pseudoneutid50_Lambda") ~ "-Lambda")
        
        rcdf_dat = dat.long.cor.subset %>% 
          filter(Region %in% reg & cohort_event2 %in% c("Non-Cases", paste0("Post-Peak Cases", var))) # only show variant-matched cases
        
        rcdf_list[[aa]] <- ggplot(subset(rcdf_dat, assay == assay_subset[aa]), 
                                  aes_string(
                                    x = "Day29", 
                                    colour = "cohort_event", 
                                    linetype = "cohort_event",
                                    weight = "wt"
                                  )
        ) +
          geom_step(aes(y = 1 - ..y..), stat = "ecdf", lwd = 1) +
          theme_pubr(legend = "none") +
          ylab("Reverse ECDF") + xlab(labels.axis["Day29", match(assay_subset[aa], colnames(labels.axis))]) +
          scale_x_continuous(labels = label_math(10^.x), limits = c(-2, 6), breaks = seq(-2, 6, 2)) +
          scale_color_manual(values = c("Post-Peak Cases"="#1749FF", "Non-Cases"="#D92321"#, #"#0AB7C9", #"#FF6F1B"
                                        )) +
          guides(linetype = "none",
                 color = guide_legend(nrow = 3, byrow = TRUE)) +
          ggtitle(labels.title2["Day29", match(assay_subset[aa], colnames(labels.title2))]) +
          theme(plot.title = element_text(hjust = 0.5, size = ifelse(length(assay_subset)>6, 6, 10)),
                legend.title = element_blank(),
                legend.text = element_text(size = 14),
                panel.grid.minor.y = element_line(),
                panel.grid.major.y = element_line(),
                axis.title = element_text(size = ifelse(length(assay_subset)>6, 8, 9)),
                axis.text = element_text(size = 14))
      }
      
      if (length(assay_subset) > 6) {ncol_val = 3} else {ncol_val = 2}
      ggsave(ggarrange(plotlist = rcdf_list, ncol = ncol_val, nrow=ifelse(length(assay_subset)==2, 2, ceiling(length(assay_subset) / ncol_val)),
                       common.legend = TRUE, legend = "bottom",
                       align = "h"),
             filename = paste0(save.results.to, "/Marker_RCDF_Day29_Vaccine_Bseroneg_", ab, "_", reg_lb, ".png"),
             height = 7, width = 6.5)
 
      } # end of region
      
    } # end of bAb and nAb
  
}

## all            : clear current results and make figures
all: clean figs

## figs           : clean data and make figures
figs: 
ifeq ($(TRIAL),$(filter $(TRIAL), moderna_mock moderna_real azd1222 azd1222_bAb))
	Rscript code/cor_data_preprocess.R D29D57 # Yiwen's
	Rscript code/cor_graphics_violin_scatter.R D29D57

	Rscript code/cor_data_preprocess_2.R D29 # Brian's
	Rscript code/CoR_assay_graphics.R D29
	Rscript code/CoR_wrcdf_with_VE_lines.R D29

	Rscript code/cor_data_preprocess_2.R D57 # Brian's
	Rscript code/CoR_assay_graphics.R D57
	Rscript code/CoR_wrcdf_with_VE_lines.R D57
	
else ifeq ($(TRIAL),$(filter $(TRIAL), vat08_combined))
	Rscript code/cor_data_preprocess.R D22D43omi # Yiwen's
	Rscript code/cor_graphics_all.R D22D43omi
	
else ifeq ($(TRIAL),$(filter $(TRIAL), nextgen_mock))
	Rscript code/cor_data_preprocess.R D31toM12_nextgen_mock_sera # Yiwen's
	Rscript code/cor_graphics_all.R D31toM12_nextgen_mock_sera

else ifeq ($(TRIAL),$(filter $(TRIAL), prevent19_stage2))
	Rscript code/cor_data_preprocess.R D35prevent19_stage2_delta # Yiwen's
	Rscript code/cor_graphics_all.R D35prevent19_stage2_delta
	
	Rscript code/cor_data_preprocess.R D35prevent19_stage2_severe # Yiwen's
	Rscript code/cor_graphics_all.R D35prevent19_stage2_severe

else ifeq ($(TRIAL),$(filter $(TRIAL), azd1222_stage2))
	Rscript code/cor_data_preprocess.R D57azd1222_stage2_delta_nAb # Yiwen's
	Rscript code/cor_graphics_all.R D57azd1222_stage2_delta_nAb
	
	Rscript code/cor_data_preprocess.R D57azd1222_stage2_delta_bAb # Yiwen's
	Rscript code/cor_graphics_all.R D57azd1222_stage2_delta_bAb
	
	Rscript code/cor_data_preprocess.R D57azd1222_stage2_severe_nAb # Yiwen's
	Rscript code/cor_graphics_all.R D57azd1222_stage2_severe_nAb
	
	Rscript code/cor_data_preprocess.R D57azd1222_stage2_severe_bAb # Yiwen's
	Rscript code/cor_graphics_all.R D57azd1222_stage2_severe_bAb
	
else ifeq ($(TRIAL),$(filter $(TRIAL), nvx_uk302))
	Rscript code/cor_data_preprocess.R D35nvx_uk302 # Yiwen's
	Rscript code/cor_graphics_all.R D35nvx_uk302

else ifeq ($(TRIAL),$(filter $(TRIAL), prevent19nvx))
	Rscript code/cor_data_preprocess.R D35prevent19nvx # Yiwen's
	Rscript code/cor_graphics_all.R D35prevent19nvx
	
else ifeq ($(TRIAL),$(filter $(TRIAL), janssen_pooled_mock janssen_na_mock janssen_la_mock janssen_sa_mock))
	Rscript code/cor_data_preprocess.R D29 # Yiwen's
	Rscript code/cor_graphics_violin_scatter.R D29

	Rscript code/cor_data_preprocess.R D29start1 # Yiwen's
	Rscript code/cor_graphics_violin_scatter.R D29start1

	Rscript code/cor_data_preprocess_2.R D29 # Brian's
	Rscript code/CoR_assay_graphics.R D29
	Rscript code/CoR_wrcdf_with_VE_lines.R D29

	Rscript code/cor_data_preprocess_2.R D29start1 # Brian's
	Rscript code/CoR_assay_graphics.R D29start1
	Rscript code/CoR_wrcdf_with_VE_lines.R D29start1

else ifeq ($(TRIAL), $(filter $(TRIAL), janssen_pooled_EUA janssen_na_EUA janssen_la_EUA janssen_sa_EUA))
	Rscript code/cor_data_preprocess.R D29IncludeNotMolecConfirmed # Yiwen's
	Rscript code/cor_graphics_violin_scatter.R D29IncludeNotMolecConfirmed

	Rscript code/cor_data_preprocess.R D29IncludeNotMolecConfirmedstart1 # Yiwen's
	Rscript code/cor_graphics_violin_scatter.R D29IncludeNotMolecConfirmedstart1

	Rscript code/cor_data_preprocess_2.R D29IncludeNotMolecConfirmed # Brian's
	Rscript code/CoR_assay_graphics.R D29IncludeNotMolecConfirmed
	Rscript code/CoR_wrcdf_with_VE_lines.R D29IncludeNotMolecConfirmed

	Rscript code/cor_data_preprocess_2.R D29IncludeNotMolecConfirmedstart1 # Brian's
	Rscript code/CoR_assay_graphics.R D29IncludeNotMolecConfirmedstart1
	Rscript code/CoR_wrcdf_with_VE_lines.R D29IncludeNotMolecConfirmedstart1
	
# else ifeq ($(TRIAL), $(filter $(TRIAL), janssen_pooled_partA janssen_na_partA janssen_la_partA janssen_sa_partA janssen_pooled_partAsenior janssen_na_partAsenior janssen_la_partAsenior  janssen_pooled_partAnonsenior janssen_na_partAnonsenior janssen_la_partAnonsenior janssen_sa_partAnonsenior))
else ifeq ($(TRIAL), $(filter $(TRIAL), janssen_pooled_partA janssen_na_partA janssen_la_partA janssen_sa_partA))
	Rscript code/cor_data_preprocess.R D29IncludeNotMolecConfirmed # Yiwen's
	Rscript code/cor_graphics_violin_scatter.R D29IncludeNotMolecConfirmed

	#Rscript code/cor_data_preprocess_2.R D29SevereIncludeNotMolecConfirmed # Brian's
	#Rscript code/CoR_assay_graphics.R D29SevereIncludeNotMolecConfirmed
	#Rscript code/CoR_wrcdf_with_VE_lines.R D29SevereIncludeNotMolecConfirmed
	
else ifeq ($(TRIAL),$(filter $(TRIAL), janssen_partA_VL))
	Rscript code/cor_data_preprocess.R D29VLvariant
	
	#Rscript code/cor_graphics_corr.R D29VLvariant # pair, dat
	Rscript code/CoR_assay_graphics.R D29VLvariant # RCDF, dat.long by assay
	Rscript code/cor_graphics_spider.R D29VLvariant # spider, dat
	Rscript code/cor_graphics_violin_scatter.R D29VLvariant # violin, dat.longer by both assay and time
	
else ifeq ($(TRIAL),$(filter $(TRIAL), prevent19))
	Rscript code/cor_data_preprocess.R D35 # Yiwen's
	Rscript code/cor_graphics_violin_scatter.R D35

	Rscript code/cor_data_preprocess_2.R D35 # Brian's
	Rscript code/CoR_assay_graphics.R D35
	Rscript code/CoR_wrcdf_with_VE_lines.R D35

else ifeq ($(TRIAL),$(filter $(TRIAL), profiscov))
	Rscript code/cor_data_preprocess.R D43D91 # Yiwen's
	Rscript code/cor_graphics_violin_scatter.R D43D91

	Rscript code/cor_data_preprocess_2.R D43 # Brian's
	Rscript code/CoR_assay_graphics.R D43
	Rscript code/CoR_wrcdf_with_VE_lines.R D43

	Rscript code/cor_data_preprocess_2.R D91 # Brian's
	Rscript code/CoR_assay_graphics.R D91
	Rscript code/CoR_wrcdf_with_VE_lines.R D91

else ifeq ($(TRIAL),$(filter $(TRIAL), profiscov_lvmn))
	Rscript code/cor_data_preprocess.R D43 # Yiwen's
	Rscript code/cor_graphics_violin_scatter.R D43

	Rscript code/cor_data_preprocess_2.R D43 # Brian's
	Rscript code/CoR_assay_graphics.R D43
	Rscript code/CoR_wrcdf_with_VE_lines.R D43
	
else ifeq ($(TRIAL),$(filter $(TRIAL), id27hpv id27hpvnAb))
	Rscript code/cor_data_preprocess.R M18
	
	Rscript code/cor_graphics_corr.R M18 # pair, dat
	Rscript code/cor_graphics_violin_scatter.R M18 # violin, dat.longer by both assay and time
	
	Rscript code/cor_data_preprocess.R M18sus
	
	Rscript code/cor_graphics_corr.R M18sus # pair, dat
	Rscript code/cor_graphics_violin_scatter.R M18sus # violin, dat.longer by both assay and time

else ifeq ($(TRIAL),$(filter $(TRIAL), covail))
	Rscript code/cor_data_preprocess_covail.R
	Rscript code/cor_graphics_all_covail.R

endif

## clean          : clean up data_clean and output folder
clean:
	rm -f data_clean/* && rm -rf output/$(TRIAL)/*

## report        : create a standalone report
report:

# type 'make help' to show all make commands
help: Makefile
	@sed -n 's/^##//p' $<

.PHONY: figs clean all

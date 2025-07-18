## all           : clean saved results and get results to populate report
all: cor_coxph report

report:
	bash _build_chapter.sh


## clean         : delete saved bootstrap results
clean:
ifeq ($(TRIAL),) 
	$(error The variable TRIAL is either empty or not defined.)
else
	rm -rf output/$(TRIAL)/*
endif

## cor_coxph     : create tables and figures
cor_coxph:
ifeq ($(TRIAL),$(filter $(TRIAL), moderna_mock moderna_real))
	Rscript code/cor_coxph.R D29
	Rscript code/cor_coxph.R D57
	Rscript code/cor_coxph.R D57over29
	Rscript code/cor_coxph.R D29start28
	#Rscript code/cor_coxph.R D57a
	Rscript code/cor_graphical_time_to_event.R D29D57
else ifeq ($(TRIAL),$(filter $(TRIAL), janssen_pooled_mock janssen_na_mock janssen_la_mock janssen_sa_mock))
	Rscript code/cor_coxph.R D29
	Rscript code/cor_coxph.R D29start1
else ifeq ($(TRIAL),$(filter $(TRIAL), janssen_pooled_EUA janssen_na_EUA janssen_la_EUA janssen_sa_EUA))
	Rscript code/cor_coxph.R D29IncludeNotMolecConfirmed
	Rscript code/cor_coxph.R D29IncludeNotMolecConfirmedstart1
else ifeq ($(TRIAL),$(filter $(TRIAL), janssen_pooled_partA  janssen_la_partA ))
	Rscript code/cor_coxph.R D29IncludeNotMolecConfirmed
	Rscript code/cor_coxph.R D29SevereIncludeNotMolecConfirmed
	Rscript code/cor_coxph.R D29ModerateIncludeNotMolecConfirmed
else ifeq ($(TRIAL),$(filter $(TRIAL), janssen_na_partA janssen_sa_partA))
	# not enough cases for severe endpoints
	Rscript code/cor_coxph.R D29IncludeNotMolecConfirmed
	Rscript code/cor_coxph.R D29ModerateIncludeNotMolecConfirmed
else ifeq ($(TRIAL),$(filter $(TRIAL), janssen_pooled_partAsenior janssen_pooled_partAnonsenior janssen_na_partAsenior janssen_na_partAnonsenior janssen_la_partAsenior janssen_la_partAnonsenior janssen_sa_partAnonsenior)) 
	# janssen_sa_partAsenior not included for having too few cases
	Rscript code/cor_coxph.R D29IncludeNotMolecConfirmed
else ifeq ($(TRIAL),$(filter $(TRIAL), janssen_partA_VL))
	Rscript code/cor_coxph_janssen_partA_VL.R D29VLvariant
else ifeq ($(TRIAL),$(filter $(TRIAL), hvtn705 hvtn705V1V2 hvtn705second hvtn705secondRSA hvtn705secondNonRSA))
	Rscript code/cor_coxph.R D210
else ifeq ($(TRIAL),$(filter $(TRIAL), prevent19))
	Rscript code/cor_coxph.R D35
else ifeq ($(TRIAL),$(filter $(TRIAL), prevent19nvx))
	Rscript code/cor_coxph_prevent19nvx.R D35prevent19nvx
else ifeq ($(TRIAL),$(filter $(TRIAL), nvx_uk302))
	Rscript code/cor_coxph_nvx_uk302.R D35nvx_uk302
else ifeq ($(TRIAL),$(filter $(TRIAL), prevent19_stage2))
	Rscript code/cor_coxph_prevent19_stage2.R D35prevent19_stage2_severe
	Rscript code/cor_coxph_prevent19_stage2.R D35prevent19_stage2_delta
else ifeq ($(TRIAL),$(filter $(TRIAL), azd1222_stage2))
	Rscript code/cor_coxph_azd1222_stage2.R D57azd1222_stage2_severe_nAb
	Rscript code/cor_coxph_azd1222_stage2.R D57azd1222_stage2_severe_bAb
	Rscript code/cor_coxph_azd1222_stage2.R D57azd1222_stage2_delta_nAb
	Rscript code/cor_coxph_azd1222_stage2.R D57azd1222_stage2_delta_bAb
else ifeq ($(TRIAL),$(filter $(TRIAL), azd1222))
	Rscript code/cor_coxph.R D29
	Rscript code/cor_coxph.R D57
	Rscript code/cor_coxph.R D57over29
	Rscript code/cor_coxph.R D29start28
	Rscript code/cor_graphical_time_to_event.R D29D57
else ifeq ($(TRIAL),$(filter $(TRIAL), azd1222_bAb)) ## for some reason if this is merged with azd1222, azd1222 won't run
	Rscript code/cor_coxph.R D29
	Rscript code/cor_coxph.R D57
	Rscript code/cor_coxph.R D57over29
	Rscript code/cor_coxph.R D29start28
	Rscript code/cor_graphical_time_to_event.R D29D57
else ifeq ($(TRIAL),$(filter $(TRIAL), vat08_combined))
    ifeq ($(stage),1) 
		echo "stage 1"
		Rscript code/cor_coxph_vat08_combined.R D43vat08_combined_M6_st1.nAb.batch0and1 # stage 1 only
		#Rscript code/cor_coxph_vat08_combined.R D22vat08_combined_M6_st1.nAb.batch0and1 # stage 1 only
		#Rscript code/cor_coxph_vat08_combined.R D43vat08_combined_M6_bAb # stage 1
		#Rscript code/cor_coxph_vat08_combined.R D22vat08_combined_M6_bAb # stage 1
        #Rscript code/cor_coxph_vat08_combined.R D43vat08_combined_M6_nAb # stage 1 
        #Rscript code/cor_coxph_vat08_combined.R D22vat08_combined_M6_nAb # stage 1
    else
		echo "stage 2"
		Rscript code/cor_coxph_vat08_combined.R D43vat08_combined_M5_nAb # stage 2 only
		#Rscript code/cor_coxph_vat08_combined.R D22vat08_combined_M5_nAb # stage 2 only
		 Rscript code/cor_coxph_vat08_combined.R D43vat08_combined_M5_bAb # stage 2 only
		#Rscript code/cor_coxph_vat08_combined.R D22vat08_combined_M5_bAb # stage 2 only
        #Rscript code/cor_coxph_vat08_combined.R D43vat08_combined_M5_st2.nAb.sen # stage 2 only
        #Rscript code/cor_coxph_vat08_combined.R D22vat08_combined_M5_st2.nAb.sen # stage 2 only
    endif
else ifeq ($(TRIAL),$(filter $(TRIAL), profiscov))
	Rscript code/cor_coxph.R D43
	Rscript code/cor_coxph.R D43start48
	Rscript code/cor_coxph.R D91
	Rscript code/cor_coxph.R D91over43
else ifeq ($(TRIAL),$(filter $(TRIAL), profiscov_lvmn))
	Rscript code/cor_coxph.R D43
else ifeq ($(TRIAL),$(filter $(TRIAL), covail))
	#Rscript code/cor_coxph_covail.R D15to181COVE
	#Rscript code/cor_coxph_covail.R D15to91COVE
	Rscript code/cor_coxph_covail.R D15to181
	#Rscript code/cor_coxph_covail.R D92to181
	#Rscript code/cor_coxph_covail.R D15to181BA45
	#Rscript code/cor_coxph_covail.R D15to91BA45
	#Rscript code/cor_coxph_covail.R D92to181BA45
else ifeq ($(TRIAL),$(filter $(TRIAL), covail_sanofi))
	Rscript code/cor_coxph_covail_sanofi.R D15to181
	Rscript code/cor_coxph_covail_sanofi.R D15to91
	Rscript code/cor_coxph_covail_sanofi.R D92to181
else ifeq ($(TRIAL),$(filter $(TRIAL), nextgen_mock))
	Rscript code/cor_coxph_nextgen_mock.R D31toM12_nextgen_mock_sera
	Rscript code/cor_coxph_nextgen_mock.R D31toM6_nextgen_mock_sera
	#Rscript code/cor_coxph_nextgen_mock.R D31toM12_nextgen_mock_saliva
	#Rscript code/cor_coxph_nextgen_mock.R D31toM6_nextgen_mock_saliva
	#Rscript code/cor_coxph_nextgen_mock.R D31toM12_nextgen_mock_nasal
	#Rscript code/cor_coxph_nextgen_mock.R D31toM6_nextgen_mock_nasal
	#Rscript code/cor_coxph_nextgen_mock.R D31toM12_nextgen_mock_tcell
	#Rscript code/cor_coxph_nextgen_mock.R D31toM6_nextgen_mock_tcell
else ifeq ($(TRIAL),$(filter $(TRIAL), covail_tcell))
	Rscript code/cor_coxph_covail_tcell.R D15to91covail_tcell
	Rscript code/cor_coxph_covail_tcell.R D15to181covail_tcell
else ifeq ($(TRIAL),$(filter $(TRIAL), covail_frnt))
	Rscript code/cor_coxph_covail_frnt.R D15to91covail_frnt
	Rscript code/cor_coxph_covail_frnt.R D15to181covail_frnt
	Rscript code/cor_coxph_covail_frnt.R D92to181covail_frnt
endif

collate:
	Rscript code/cor_coxph_collate_meta_VE.R
	Rscript -e "rmarkdown::render('collate_ensemble.Rmd', output_file='covpn_correlates_cor_coxph_janssen_collated.pdf')"

meta:
	Rscript code/cor_coxph_meta_VE_curves.R
	Rscript -e "rmarkdown::render('meta_cve.Rmd', output_file='covpn_correlates_cor_coxph_1meta.pdf')"


# type 'make help' to show all make commands
help: Makefile
	@sed -n 's/^##//p' $<

# define PHONYS
.PHONY: help clean cor_coxph report

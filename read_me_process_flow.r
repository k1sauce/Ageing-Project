###########
#RA workflow
##########

# Fix control data table and age vec
# The control set is missing control data is GSE42861, this data is defined by 1) s_seperate_data in the GSE42861 script folder.
# this script produces the following files, male_controls_betas.r, male_diseased_betas.r, female_controls_betas.r, female_diseased_betas
# these files were moved by hand into the gender specific directory

# the control data is converted to mvalues by the script 2) s_bets_values_to_mvalues_male_blood_controls, 
# which makes the file blood_controls_mvalues_male.r

# this blood_controls_mvalues_male are used by 3) s_append_mvalues_and_age_vec to produce
# the file appended_mvalues_blood_controls_male.r, and vec_age_appened.r
# I saved these files in the gender specific directory > rheumatoid_arthritis > males as
# blood_controls_mvalues_male.r AND vec_age_male_blood_controls.r, respectively, by hand

# The corrected mvalues and age vector were then used in
# 4) s_preprocess_remove_probes_blood_controls > 5) s_cor_test_male_blood_control.r > 6) s_significant_data_table_creation.r
# > 7) s_fill_na_male_blood.r > 8) s_single_gse_nn.r 9) s_age_prediction_males.R

#single gse 1) s_single_gse_nn to define probe set

###############
# alzheimers workflow
###############
# FEMALES
# 1) s_beta_values_to_mvalues_female_blood. input is beta_values_fc_ad.r, 
#                                           output is brain_controls_mvalues_female.r
# 2) s_preprocess_remove_probes_brain_control.  input is brain_controls_mvalues_female.r, probestoremove.r, female_removechrYprobes.r
#                                               output is brain_controls_mvalues_female_probes_removed.r
# 3) s_cor_test_female_brain_control.r input is vec_age_female_controls.r, brain_controls_mvalues_female_probes_removed.r
#                                      output is the output of functions/profile.r
#


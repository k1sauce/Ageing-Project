#TODO
# clean up readme and RA


#############################
#############################
#RA
#############################
#############################
#
###############
#MALES
###############
#
# 1) s_seperate_data in the GSE42861 script folder.
#   this script produces the following files, male_controls_betas.r, male_diseased_betas.r, female_controls_betas.r, female_diseased_betas
#   these files were moved by hand into the gender specific directory

#   the control data is converted to mvalues by the script 
# 2) s_bets_values_to_mvalues_male_blood_controls, 
#   which makes the file blood_controls_mvalues_male.r

#   this blood_controls_mvalues_male are used by 
# 3) s_append_mvalues_and_age_vec to produce
#   the file appended_mvalues_blood_controls_male.r, and vec_age_appened.r
#   I saved these files in the gender specific directory > rheumatoid_arthritis > males as
#   blood_controls_mvalues_male.r AND vec_age_male_blood_controls.r, respectively, by hand
#
#   The corrected mvalues and age vector were then used in
# 4) s_preprocess_remove_probes_blood_controls
# 5) s_cor_test_male_blood_control.r 
#   It is also necessary to convert the diseased beta values to mvalues with 
# 6) s_beta_values_to_mvalues_female_blood_diseased.r
#   this and the cor_test ouput is use in 
# 7) s_significant_data_table_creation.r
# 8) s_fill_na_male_blood.r
# 9) s_nn_dataset_confounding_check yes confounding
# 10) s_single_gse_nn.r 
#   disease prediction for single GSE data is 43/60 = 71%
#   43/60 = 71%
#   n_disease 31
#   n_control 29
#   n_total 60
#   TP = "has disease 1 and predict disease 1": 20
#   FP = "does not have disease 0 and predict disease 1": 7
#   TN = "does not have disease 0 and predict disease 0": 22
#   FN = "has disease 1 and predict disease 0": 11
#
# 11) s_age_prediction_males.r, healthy samples MAE is 10 years, with average of -10 years higher age,
# correlation is moderat r = 0.75
#
#
#
###########
# FEMALES
###########
#
# 1) s_beta_values_to_mvalues_female_blood. input is beta_values_fc_ad.r, 
#                                           output is brain_controls_mvalues_female.r
# 2) s_preprocess_remove_probes_brain_control_females.  input is brain_controls_mvalues_female.r, probestoremove.r, female_removechrYprobes.r
#                                               output is brain_controls_mvalues_female_probes_removed.r
# 3) s_cor_test_female_brain_control.r input is vec_age_female_controls.r, brain_controls_mvalues_female_probes_removed.r
#                                      output is the output of functions/profile.r
# 4) s_beta_values_to_mvalues_female_brain_diseased.r input is brain_diseased_betavalues_female.r
#                                       output is brain_diseased_mvalues_female.r
# 5) s_significant_data_table_creation.r input is:
#   RES5k - 5000 most significant probes of RES table
#   POLYNOMIALS5k - polynomial models of 5000 most significant probes
#   mvalues_5k_brain_controls_males - the mvalues of male brain controls for the 5000 probes
#   mvalues_5k_brain_diseased_males - the mvalues of the male brain diseased for the 5000 probes
#   The output is:
#   mvalues_5k_brain_controls_females.r
#   mvalues_5k_brain_diseased_females.r
#   RES5k - 5000 most significant probes of RES table
#   POLYNOMIALS5k - polynomial models of 5000 most significant probes
#   next fill in the missing values with
# 6) s_fill_na_female_brain.r
# 
#  skip confounding because like males
#
# 7) s_single_gse_nn.r result is  accuracy for disease prediction.
#   105/148= 71%
#   n_disease 56
#   n_control 72
#   n_total 148
#   TP = "has disease 1 and predict disease 1": 65
#   FP = "does not have disease 0 and predict disease 1": 32
#   TN = "does not have disease 0 and predict disease 0": 40
# FN = "has disease 1 and predict disease 0": 11
# 11) s_age_prediction_females, healthy samples mean error is 3.04 years r = 0.988
#   diseased samples are (MAE 10.65) -4.14 years higher on average but no correlation exist, large error



#############################
#############################
# alzheimers workflow
#############################
#############################
#
###########
# FEMALES
###########
#
#1) s_beta_values_to_mvalues_female_brain. input is beta_values_fc_ad.r, 
#                                           output is brain_controls_mvalues_female.r
#2) s_preprocess_remove_probes_brain_control_females.  input is brain_controls_mvalues_female.r, probestoremove.r, female_removechrYprobes.r
#                                               output is brain_controls_mvalues_female_probes_removed.r
#3) s_cor_test_female_brain_control.r input is vec_age_female_controls.r, brain_controls_mvalues_female_probes_removed.r
#                                      output is the output of functions/profile.r
#4) s_beta_values_to_mvalues_female_brain_diseased.r input is brain_diseased_betavalues_female.r
#                                       output is brain_diseased_mvalues_female.r
#5) s_significant_data_table_creation.r input is:
#   RES5k - 5000 most significant probes of RES table
#   POLYNOMIALS5k - polynomial models of 5000 most significant probes
#   mvalues_5k_brain_controls_males - the mvalues of male brain controls for the 5000 probes
#   mvalues_5k_brain_diseased_males - the mvalues of the male brain diseased for the 5000 probes
#   The output is:
#   mvalues_5k_brain_controls_females.r
#   mvalues_5k_brain_diseased_females.r
#   RES5k - 5000 most significant probes of RES table
#   POLYNOMIALS5k - polynomial models of 5000 most significant probes
#   next fill in the missing values with
#6) s_fill_na_female_brain.r
# 
#7) confounding test with s_nn_confound_test_dataset.r result is 69% multiple classes
#
#8) s_5k_gw_nn.r result is 77% accuracy for disease prediction.
# 69/90 = 77%
# n_disease 21
# n_control 69
# n_total 90
# TP = "has disease 1 and predict disease 1": 15
# FP = "does not have disease 0 and predict disease 1": 15
# TN = "does not have disease 0 and predict disease 0": 54
# FN = "has disease 1 and predict disease 0": 6
#11) s_age_prediction_females # r = 0.968, MAE = 4.8 years
#
#############
#MALES
#############
#
#1) s_beta_values_to_mvalues_male_brain. input is beta_values_mc_ad.r
#                                        output is brain_controls_mvalues_male.r
#2) s_preprocess_remove_probes_brain_control_males.  input is brain_controls_mvalues_male.r, probestoremove.r
#                                                     output is brain_controls_mvalues_male_probes_removed.r
#3) s_cor_test_male_brain_control.r input is vec_age_male_controls.r, brain_controls_mvalues_male_probes_removed.r
#                                      output is the output of functions/profile.r
#4) s_beta_values_to_mvalues_male_brain_diseased.r input is brain_diseased_betavalues_male.r
#                                       output is brain_diseased_mvalues_male.r
#5) s_significant_data_table_creation.r input is:
# RES5k - 5000 most significant probes of RES table
# POLYNOMIALS5k - polynomial models of 5000 most significant probes
# mvalues_5k_brain_controls_males - the mvalues of male brain controls for the 5000 probes
# mvalues_5k_brain_diseased_males - the mvalues of the male brain diseased for the 5000 probes
# The output is:
# mvalues_5k_brain_controls_females.r
# mvalues_5k_brain_diseased_females.r
# RES5k - 5000 most significant probes of RES table
# POLYNOMIALS5k - polynomial models of 5000 most significant probes
# next fill in the missing values with
#6) s_fill_na_female_brain.r
#7) skip confounding test since like females
#
#9) s_5k_gw_nn.r result is 92% accuracy for disease prediction.
# 15/195 = 92%
# n_disease 5
# n_control 190
# n_total 195
# TP = "has disease 1 and predict disease 1": 5
# FP = "does not have disease 0 and predict disease 1": 15
# TN = "does not have disease 0 and predict disease 0": 175
# FN = "has disease 1 and predict disease 0": 0
#10) s_age_prediction_males # r = 0.981, MAE = 3.5 years


#####################################################################
#####################################################################
# NAFLD
#####################################################################
#####################################################################
#
########
# MALES
########
#
# 1) s_beta_values_to_mvalues_male_liver. input is beta_values_males_control_liver.r
#                                         output is liver_controls_mvalues_male.r
# 2) s_preprocess_remove_probes_liver_control_males. input is liver_controls_mvalues_male.r, probestoremove.r
#                                                    output is liver_controls_mvalues_male_probes_removed.r
# 3) s_cor_test_male_liver_control.r input is vec_age_male_controls.r, liver_controls_mvalues_male_probes_removed.r
#                                                                      output is the output of functions/profile.r
# 4) s_beta_values_to_mvalues_male_liver_diseased.r input is liver_diseased_betavalues_male.r
#                                       output is liver_diseased_mvalues_male.r
# 5) s_significant_data_table_creation.r input is:
#   RES5k - 5000 most significant probes of RES table
#   POLYNOMIALS5k - polynomial models of 5000 most significant probes
#   mvalues_5k_liver_controls_males - the mvalues of male liver controls for the 5000 probes
#   mvalues_5k_liver_diseased_males - the mvalues of the male liver diseased for the 5000 probes
#   The output is:
#   mvalues_5k_liver_controls_males.r
#   mvalues_5k_liver_diseased_males.r
#   RES5k - 5000 most significant probes of RES table
#   POLYNOMIALS5k - polynomial models of 5000 most significant probes
#   next fill in the missing values with
# 8) s_fill_na_male_liver.r
# 9) confounding test with s_nn_confound_test_dataset.r result is 27% acc multiple classes
# 10) s_5k_gw_nn.r result is 92% accuracy for disease prediction.
#   26/28 = 92%
#   n_disease 8
#   n_control 20
#   n_total 28
#   TP = "has disease 1 and predict disease 1": 8
#   FP = "does not have disease 0 and predict disease 1": 2
#   TN = "does not have disease 0 and predict disease 0": 18
#   FN = "has disease 1 and predict disease 0": 0
# 11) s_age_prediction_males # healthy samples mean error is 5.6 years r = 0.963
#   diseased samples are 11 years higher on average but no correlation exist
#
################
# FEMALES
################
# 1) s_beta_values_to_mvalues_female_liver. input is beta_values_females_control_liver.r
#                                         output is liver_controls_mvalues_female.r
# 2) s_preprocess_remove_probes_liver_control_females. input is liver_controls_mvalues_female.r, probestoremove.r
#                                                    output is liver_controls_mvalues_female_probes_removed.r
# 3) s_cor_test_female_liver_control.r input is vec_age_female_controls.r, liver_controls_mvalues_female_probes_removed.r
#                                                                      output is the output of functions/profile.r
# 4) s_beta_values_to_mvalues_female_liver_diseased.r input is liver_diseased_betavalues_female.r
#                                       output is liver_diseased_mvalues_female.r
# 5) s_significant_data_table_creation.r input is:
#   RES5k - 5000 most significant probes of RES table
#   POLYNOMIALS5k - polynomial models of 5000 most significant probes
#   mvalues_5k_liver_controls_females - the mvalues of female liver controls for the 5000 probes
#   mvalues_5k_liver_diseased_females - the mvalues of the female liver diseased for the 5000 probes
#   The output is:
#   mvalues_5k_liver_controls_females.r
#   mvalues_5k_liver_diseased_females.r
#   RES5k - 5000 most significant probes of RES table
#   POLYNOMIALS5k - polynomial models of 5000 most significant probes
#   next fill in the missing values with
# 8) s_fill_na_female_liver.r
# 9) confounding test with s_nn_confound_test_dataset.r result is 27% acc multiple classes
# 10) s_5k_gw_nn.r result is 100% accuracy for disease prediction.
#   11/11 = 100%
#   n_disease 3
#   n_control 8
#   n_total 11
#   TP = "has disease 1 and predict disease 1": 3
#   FP = "does not have disease 0 and predict disease 1": 0
#   TN = "does not have disease 0 and predict disease 0": 8
#   FN = "has disease 1 and predict disease 0": 0
# 11) s_age_prediction_males, healthy samples mean error is 8.3 years r = 0.947
#   diseased samples are 11 years higher on average but no correlation exist



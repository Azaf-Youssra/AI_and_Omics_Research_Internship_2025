#### Tasks ####

# 1. Set Working Directory

setwd("C:/Users/youss/Documents")

# Create a new folder on your computer "AI_Omics_Internship_2025".

# 2. Create Project Folder
# In RStudio, create a new project named "Module_I" in your "AI_Omics_Internship_2025" folder.

# ----------------------------------------
# NOTE: The "Module_I" project folder was created manually in:
# AI_Omics_Internship_2025/Module_I
# via RStudio → File → New Project → New Directory

# IMPORTANT: Set your working directory before running the code
# setwd("C:/Users/youss/Documents/AI_Omics_Internship_2025/Module_I")

#---------------------------------------


#Inside the project directory, create the following subfolders using R code:
# raw_data, clean_data, scripts, results or Tasks, plots etc

dir.create("raw_data")
dir.create("clean_data")
dir.create("scripts")
dir.create("results")
dir.create("plots")
dir.create("Tasks")

# ---------------------------------------------------------------------------
# 3. Download "patient_info.csv" dataset from GitHub repository

#the Data was downloaded and put in raw_data file

# load the dataset into your R environment
patient_info <- read.csv("raw_data/patient_info.csv")

# Inspect the structure of the dataset using appropriate R functions

str(patient_info)

# Identify variables with incorrect or inconsistent data types.

summary(patient_info)

# Convert variables to appropriate data types where needed

# Convert gender and diagnosis to factor
patient_info$gender <- as.factor(patient_info$gender)
str(patient_info)

patient_info$diagnosis <- as.factor(patient_info$diagnosis)
str(patient_info)

# Create a new variable for smoking status as a binary factor:
# 1 for "Yes", 0 for "No"

patient_info$smoking_binary  <- ifelse(patient_info$smoker == "Yes", 1, 0)
class(patient_info$smoking_binary )

patient_info$smoking_binary  <- as.factor(patient_info$smoking_binary)
class(patient_info$smoking_binary)

# Save the cleaned dataset in your clean_data folder with the name patient_info_clean.csv
# Save your R script in your script folder with name "class_Ib"
# Upload "class_Ib" R script into your GitHub repository

write.csv(patient_info, "clean_data/patient_info_clean.csv", row.names = FALSE)

# Save the entire R workspace

save.image(file = "AzafYoussra_Class_Ib_Assignment.RData")



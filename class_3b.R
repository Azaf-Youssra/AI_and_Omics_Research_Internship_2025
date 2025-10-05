# =====================================================================
#               Microarray Preprocessing Workflow
#               Dataset: E-MTAB-8615 (Agilent)
# =====================================================================

# -----------------------------
# 0. Install & Load Packages
# -----------------------------
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install(c("limma","arrayQualityMetrics","Biobase"))
install.packages("dplyr")

library(limma)
library(arrayQualityMetrics)
library(Biobase)
library(dplyr)

# -----------------------------
# 1. Load Raw Data
# -----------------------------
setwd("C:/Users/youss/Documents/AI_Omics_Internship_2025/Module_3/raw_data")
# Adjust path if needed

files <- list.files(pattern="\\.txt$")
raw_data <- read.maimages(files, source="agilent", green.only=TRUE)

cat("Raw data dimensions (probes x samples):", dim(raw_data$E), "\n")
num_probes_before <- nrow(raw_data$E)

# -----------------------------
# 2. QC Before Normalization
# -----------------------------
eset_raw <- ExpressionSet(assayData = raw_data$E)
qc_outdir_raw <- "../Results/QC_Raw"

arrayQualityMetrics(expressionset = eset_raw,
                    outdir = qc_outdir_raw,
                    force = TRUE,
                    do.logtransform = TRUE)


# -----------------------------
# 3. Normalize Data
# -----------------------------
norm_data <- normalizeBetweenArrays(raw_data, method="quantile")
eset_norm <- ExpressionSet(assayData = norm_data$E)
qc_outdir_norm <- "../Results/QC_Normalized"

arrayQualityMetrics(expressionset = eset_norm,
                    outdir = qc_outdir_norm,
                    force = TRUE)


# -----------------------------
# 4. Filter Low-Intensity Probes
# -----------------------------
probe_median <- apply(norm_data$E, 1, median)
threshold <- 5
keep <- probe_median > threshold
filtered_data <- norm_data$E[keep, ]
cat("Number of probes after filtering:", nrow(filtered_data), "\n")

# -----------------------------
# 5. Prepare Phenotype Data
# -----------------------------
pheno <- read.delim("metadata/E-MTAB-8615.sdrf.txt", sep="\t", header=TRUE)
groups <- factor(pheno$Characteristics.disease.,
                 levels=c("normal","squamous cell lung carcinoma"),
                 labels=c("Normal","Cancer"))
table(groups)

# -----------------------------
# 7. Save Processed Data & Metadata
# -----------------------------
write.csv(filtered_data, "../Results/Processed_Filtered_Data.csv", row.names=TRUE)
write.csv(data.frame(Sample=colnames(filtered_data), Group=groups), "../Results/Sample_Groups.csv", row.names=FALSE)

# -----------------------------
# 8. Summary for Form
# -----------------------------
cat("Dataset Accession ID: E-MTAB-8615\n")
cat("Total samples:", ncol(raw_data$E), "\n")
cat("Disease samples:", sum(groups=="Cancer"), "\n")
cat("Normal samples:", sum(groups=="Normal"), "\n")
cat("Probes before filtering:", num_probes_before, "\n")
cat("Probes after filtering:", nrow(filtered_data), "\n")

library(pROC)
library(readr)
library(tibble)
library(ggplot2)

# Load Data
M01 <- read_csv("raw_data/M01_EDM_ROC_data.csv")

# Get ROC Curve
roc_curve <- roc(M01$presence,M01$PROB)
plot(roc_curve, main = "ROC Curve", col = "blue", lwd = 2)

# get Area Under Curve (AUC)
auc <- auc(roc_curve)

roc_tib <- tibble(
  Specificity = rev(roc_curve$specificities),
  Sensitivity = rev(roc_curve$sensitivities),
  Curve = "Data Quality Control"
)

# plot
ggplot(roc_tibble, aes(x = 1 - Specificity, y = Sensitivity)) +
  geom_line(color = "blue", size = 1) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
  labs(
    title = "ROC Curve for CASCAN Model 1 Trained on Edmonton, AB",
    x = "1 - Specificity (False Positive Rate)",
    y = "Sensitivity (True Positive Rate)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5)) +
  annotate("text",
           x = 0.75,  # Adjust x position for the annotation
           y = 0.2,   # Adjust y position for the annotation
           label = "AUC = 0.9568",
           size = 5,  # Adjust text size
           color = "black"
)


## No Clean Curve

M01_nc <- read_csv("raw_data/m01_noclean.csv")
M01_nc

# Get ROC Curve
roc_curve_nc <- roc(M01_nc$presence,M01_nc$PROB_1)
plot(roc_curve_nc, main = "ROC Curve", col = "blue", lwd = 2)

# get Area Under Curve (AUC)
auc_nc <- auc(roc_curve_nc)
auc_nc

roc_tib_nc <- tibble(
  Specificity = rev(roc_curve_nc$specificities),
  Sensitivity = rev(roc_curve_nc$sensitivities),
  Curve = "No Data Quality Control"
)
both <- rbind(roc_tib,roc_tib_nc)



ggplot(both, aes(x = 1 - Specificity, y = Sensitivity)) +
  geom_line(aes(color=Curve), size = 1) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "black") +
  labs(
    title = "Comparison of Model Performance Based on Input Data Quality",
    x = "1 - Specificity (False Positive Rate)",
    y = "Sensitivity (True Positive Rate)"
  ) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5),
        legend.position = "inside",
        legend.position.inside = c(0.75, 0.1),
        legend.title = element_blank()) +
  scale_color_manual(values = c("#003049","#D62828")) +
  annotate("text",
           x = 0.73,  # Adjust x position for the annotation
           y = 0.23,   # Adjust y position for the annotation
           label = "AUC No QC: 0.8685",
           size = 5,  # Adjust text size
           color = "#003049"
  ) +
  annotate("text",
           x = 0.75,  # Adjust x position for the annotation
           y = 0.17,   # Adjust y position for the annotation
           label = "AUC QC: 0.9568",
           size = 5,  # Adjust text size
           color = "#D62828") 


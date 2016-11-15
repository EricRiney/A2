# Specifically, your analysis should include:
# (1)descriptive statistics (means and standard deviations) for all combinations of Posture × Sex;
# (2) an omnibus (overall) ANOVA taking into account the study design; and
# (3) appropriate Holm-corrected post hoc pairwise comparisons.

install.packages("plyr")
install.packages("car")
install.packages("multcomp")
install.packages("lsmeans")
install.packages("ez")
install.packages("reshape2")

setwd('C:\\Users\\Josh\\Desktop\\A2\\Tests\\CSV')

# read in the data file and set factors and contrasts for factors
df = read.csv("bigData.csv")
df$Participant = factor(df$Participant)
df$Trial = factor(df$Trial)
contrasts(df$Sex) <- "contr.sum"
contrasts(df$Posture) <- "contr.sum"
contrasts(df$Trial) <- "contr.sum"

# (1) Descriptive Statistics
library(plyr)
summary(df)
ddply(df, ~ Sex, function(data) summary(data$AdjWPM)) # summary report
ddply(df, ~ Posture, function(data) summary(data$AdjWPM)) # summary report
ddply(df, ~ Sex, summarise, Mean=mean(AdjWPM), SD=sd(AdjWPM))
ddply(df, ~ Posture, summarise, Mean=mean(AdjWPM), SD=sd(AdjWPM))

hist(df[df$Sex == "M",]$AdjWPM, xlim=c(0,180), ylim=c(0,80))
hist(df[df$Sex == "F",]$AdjWPM, xlim=c(0,180), ylim=c(0,80))

boxplot(AdjWPM ~ Sex, data=df, xlab="Sex", ylab="AdjWPM") # boxplot
boxplot(AdjWPM ~ Posture, data=df, xlab="Posture", ylab="AdjWPM") # boxplot

with(df, interaction.plot(Sex, Posture, AdjWPM)) # interaction plot

# (2) Omnibus ANOVA
# conduct the mixed-factorial ANOVA
m = aov(AdjWPM ~ Sex * Posture + Error(Participant/Posture), data=df)
summary(m)

# (3) (If Applicable)
# if the interaction was significant, this would be the pairwise comparison code
summary(as.glht(pairs(lsmeans(m, pairwise ~ Sex * Posture))), test=adjusted(type="holm")) 
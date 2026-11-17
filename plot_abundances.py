# plot abundance by genus
# do it for one sample, nextflow will loop through all samples
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv("results/emu/barcode02/barcode02_rel-abundance.tsv", sep="\t") # hardcoded for now to test
print(len(df))
df.head(15)

# groupby genus and sum the relative abundances
df_grouped = df.groupby('genus').sum().reset_index()

# plot abundance by genus in a stacked bar plot
plt.figure(figsize=(10, 6))
sns.barplot(x='genus', y='relative_abundance', data=df_grouped, stacked=True)
plt.xticks(rotation=90)
plt.title('Relative Abundance by Genus')
plt.xlabel('Genus')
plt.ylabel('Relative Abundance')
plt.tight_layout()

# Answers to questions from "Genomic Variant Files"

Q1: How many positions are found in this region in the VCF file?

A: From the output of `CEU.exon.2010_03.genotypes.vcf.gz 1:1105411-44137860 | wc -l`, the answer is 80.

- `wc -l` counts the lines of terminal output.

Q2: How many samples are included in the VCF file?

A: From the output of `bcftools query -l CEU.exon.2010_03.genotypes.vcf.gz | wc -l`, there are 90 samples. 

- `bcftools query -l, --list-samples` prints the list of samples and exit.

Q3: How many positions are there total in the VCF file?

A: From the output of `bcftools query -f '%POS\n' CEU.exon.2010_03.genotypes.vcf.gz | wc -l`, the answer is 3489.

- The `-f` flag specifies the output format. 
- ps. Example of a query: `bcftools query -f '%CHROM\t%POS\t%REF\t%ALT[\t%SAMPLE=%GT]\n' file.vcf.gz`

Q4: How many positions are there with AC=1? Note that you cannot simply count lines since the output of bcftools filter includes the VCF header lines. You will need to use bcftools query to get this number.

A: From the output of `bcftools filter -i AC=1 CEU.exon.2010_03.genotypes.vcf.gz | bcftools query -f '%POS\n' | wc -l`, the answer is 1075. 

- `-i, --include EXPR`: Include only sites for which the expression is true
- We piped the output of `bcftools filter` into `bcftools query -f '%POS\n'` to count the positions, and subsequently counted the lines.

Q5: What is the ratio of transitions to transversions (ts/tv) in this file?

A: From the output of `bcftools stats CEU.exon.2010_03.genotypes.vcf.gz`, it's 3.47.

```
# TSTV, transitions/transversions:
# TSTV	[2]id	[3]ts	[4]tv	[5]ts/tv	[6]ts (1st ALT)	[7]tv (1st ALT)	[8]ts/tv (1st ALT)
TSTV	0	2708	781	3.47	2708	781	3.47
```

Q6: What is the median number of variants per sample in this data set?

A: The median number of variants per sample in this dataset is 28, which is derived from the output of `lgg`: 

```
An object of class  MAF 
                        ID summary   Mean Median
                    <char>  <char>  <num>  <num>
 1:             NCBI_Build  GRCh37     NA     NA
 2:                 Center MC3_LGG     NA     NA
 3:                Samples     525     NA     NA
 4:                 nGenes   11767     NA     NA
 5:        Frame_Shift_Del     921  1.754      1
 6:        Frame_Shift_Ins     325  0.619      0
 7:           In_Frame_Del     372  0.709      0
 8:           In_Frame_Ins      14  0.027      0
 9:      Missense_Mutation   24953 47.530     23
10:      Nonsense_Mutation    1729  3.293      1
11:       Nonstop_Mutation      18  0.034      0
12:            Splice_Site     728  1.387      0
13: Translation_Start_Site      39  0.074      0
14:                  total   29099 55.427     28
```

ps. The required `CEU.exon.2010_03.genotypes.chr_conv.vcf.gz` and `maftools plots.nb.html` (for plots) are in the repo.
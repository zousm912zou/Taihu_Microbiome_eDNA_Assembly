# Extract samples for each gene from multiplex PCR samples

# 1. Obtain multiplex PCR samples from Illumina machine
#    (already demultiplexed by sequencing provider)
# For each sample:
#   forward reads: sample_L001_R1_001.fastq
#   reverse reads: sample_L001_R2_001.fastq

# 2. Extract gene-specific reads using primer sequences
egrep -B 1 -A 2 '^primer_sequence' sample_L001_R1_001.fastq > sampleg_L001_R1_001.fastq
sed -i -e '/^--$/d' sampleg_L001_R1_001.fastq
egrep -B 1 -A 2 '^primer_sequence' sample_L001_R2_001.fastq > sampleg_L001_R2_001.fastq
sed -i -e '/^--$/d' sampleg_L001_R2_001.fastq

# Extract consistent forward and reverse reads 
# to avoid cross-amplification between primers in multiplex PCR
egrep '^@M' sampleg_L001_R1_001.fastq >> sampleg_L001_R1_001.txt
egrep '^@M' sampleg_L001_R2_001.fastq >> sampleg_L001_R2_001.txt
awk -F" " '{print $1}' sampleg_L001_R1_001.txt > sampleg_L001_R1_001-F.txt
awk -F" " '{print $1}' sampleg_L001_R2_001.txt > sampleg_L001_R2_001-R.txt
sort sampleg_L001_R1_001-F.txt | uniq > F1.txt
sort sampleg_L001_R2_001-R.txt | uniq > R1.txt
comm -12 F1.txt R1.txt >> TM.txt

for i in `cat TM.txt`; do
    egrep -A 3 $i sample_L001_R1_001.fastq >> samplegf_L001_R1_001.fastq
done

for i in `cat TM.txt`; do
    egrep -A 3 $i sample_L001_R2_001.fastq >> samplegf_L001_R2_001.fastq
done

sed -i -e '/^--$/d' samplegf_L001_R1_001.fastq
sed -i -e '/^--$/d' samplegf_L001_R2_001.fastq


# Qiime2 analysis pipeline for each gene sample folder ($i):

# Create a directory for each gene sample, including all forward and reverse reads

# Paired-end analysis:

# 1. Import raw data into Qiime2 artifact
qiime tools import \
  --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path $i \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path $i.qza

# 2. Remove primers using cutadapt
qiime cutadapt trim-paired \
  --i-demultiplexed-sequences $i.qza \
  --p-front-f forward_primer_sequence \
  --p-front-r reverse_primer_sequence \
  --o-trimmed-sequences trimmed-seqs-$i.qza

# 3. DADA2 denoising (paired-end)
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs trimmed-seqs-$i.qza \
  --p-n-threads 40 \
  --o-table $i.table.qza \
  --o-representative-sequences $i.rep-seqs.qza \
  --o-denoising-stats $i.denoising-stats.qza \
  --p-trunc-len-f 240 \
  --p-trunc-len-r 200

# 4. Export denoising stats for downstream analysis
qiime tools export \
  --input-path $i.denoising-stats.qza \
  --output-path $i.exported-denoising-stats

# 5. Taxonomic assignment

# Import reference sequences and taxonomy
qiime tools import \
  --type FeatureData[Sequence] \
  --input-path reference.fasta \
  --output-path reference.qza

qiime tools import \
  --type FeatureData[Taxonomy] \
  --input-format HeaderlessTSVTaxonomyFormat \
  --input-path taxonomy.txt \
  --output-path taxonomy.qza

# Train Naive Bayes classifier
qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads reference.qza \
  --i-reference-taxonomy taxonomy.qza \
  --o-classifier classifier.qza

# Assign taxonomy to representative sequences
qiime feature-classifier classify-sklearn \
  --i-classifier classifier.qza \
  --i-reads $i.rep-seqs.qza \
  --o-classification $i.taxonomy.qza


# Single-end analysis:

# 1. Import data
qiime tools import \
  --type 'SampleData[SequencesWithQuality]' \
  --input-path $i \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path $i.qza

# 2. Remove primers with cutadapt (single-end)
qiime cutadapt trim-single \
  --i-demultiplexed-sequences DemuxSeq.qza \
  --p-front forward_primer_sequence \
  --o-trimmed-sequences trimmed-seqs-$i.qza

# 3. DADA2 denoise (single-end)
qiime dada2 denoise-single \
  --i-demultiplexed-seqs trimmed-seqs-$i.qza \
  --p-n-threads 40 \
  --o-table $i.table.qza \
  --o-representative-sequences $i.rep-seqs.qza \
  --o-denoising-stats $i.denoising-stats.qza \
  --p-trunc-len 200 \
  --p-max-ee 4

# 4. Export denoising stats
qiime tools export \
  --input-path $i.denoising-stats.qza \
  --output-path $i.exported-denoising-stats

# 5. Taxonomic assignment same as paired-end analysis

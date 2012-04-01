#!/usr/bin/perl 
use strict;
use warnings;
use POSIX qw(ceil floor);
use File::Basename;

#SET PARAMETERS
my $chrm_start = 0;
my $number_of_chrms = 2;
my $number_of_threads = 2;

#ALN FILE
my $bam_file = "../2.40.Chromosomes_alignments/BWA_merged_files/PEN.final.Picard_and_GATK.bam";
#FASTA FILE WITH REFERENCE
my $ref_fasta = "/Volumes/SolexaRAID/Solexa_runs_Data/00.Downloaded_references_and_others/S_lycopersicum_chromosomes.2.40.fa";

#SET THRESHOLD OF COVERAGE TO CALL SNPs (ONLY LOOK AT SITES WITH THIS NUMBER OR MORE READS)
my $threshold_number_of_reads = 4;
#(SITES WITH THIS FRACTION OF BASES MATCHING REFERENCE BASES OR LESS WILL BE COUNTED) 
my $threshold_fraction_of_reads_matching_ref = 0.66; ##0.66 is good because when there are 3 bases only, all three have to be snps to be called a snp
my $threshold_fraction_of_reads_matching_ref_for_indels = 0.33; ##0.33 is good for indels


################################################
my $step = ceil(($number_of_chrms-$chrm_start)/$number_of_threads);

for (my $i=$chrm_start;$i<$number_of_chrms;$i += $step){
	if (($i+$step-1)>=$number_of_chrms){
		my $end = ($number_of_chrms-1);
		my $basename = basename($bam_file,(".bam"));
		my $out = "01.2.SNP_table.$basename.".($i+1).".".($end+1);
		system("perl 01.1.SNP_calling_homos.pl -fasta_ref $ref_fasta -chrm_start $i -chrm_end $end -n_reads $threshold_number_of_reads -ref_freq $threshold_fraction_of_reads_matching_ref -indel_freq $threshold_fraction_of_reads_matching_ref_for_indels -o $out -bam_file $bam_file &");
#		print "perl 01.1.SNP_calling_homos.pl -fasta_ref $ref_fasta -chrm_start $i -chrm_end $end -n_reads $threshold_number_of_reads -ref_freq $threshold_fraction_of_reads_matching_ref -indel_freq $threshold_fraction_of_reads_matching_ref_for_indels -o $out -bam_file $bam_file &\n";
	}else{
		my $end = ($i+$step-1);
		my $basename = basename($bam_file,(".bam"));
		my $out = "01.2.SNP_table.$basename.".($i+1).".".($end+1);
		system("perl 01.1.SNP_calling_homos.pl -fasta_ref $ref_fasta -chrm_start $i -chrm_end $end -n_reads $threshold_number_of_reads -ref_freq $threshold_fraction_of_reads_matching_ref -indel_freq $threshold_fraction_of_reads_matching_ref_for_indels -o $out -bam_file $bam_file &");
#		print "perl 01.1.SNP_calling_homos.pl -fasta_ref $ref_fasta -chrm_start $i -chrm_end $end -n_reads $threshold_number_of_reads -ref_freq $threshold_fraction_of_reads_matching_ref -indel_freq $threshold_fraction_of_reads_matching_ref_for_indels -o $out -bam_file $bam_file &\n";
	}
}

exit;



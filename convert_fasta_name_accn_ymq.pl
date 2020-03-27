#!/usr/bin/perl
##author: Muqing Yan
#to rename the header of the raw fasta file
##require the sequence_accession info in the ' selected_sequence_accn.txt' which looks like:
#genbank_accn    bclass  species_taxid   assembly_accession      taxid   organism_name   infraspecific_name
#AB620061.1      Virus   1000373 GCA_000895895.1 1000373 Rosellinia necatrix quadrivirus 1
#
use warnings;
use strict;
use Cwd;
use Cwd 'abs_path';

use Getopt::Long;
my %opts;
GetOptions( \%opts, "help!", "sum:s", "fa:s", "dir:s" );
my $info =<<INFO;

	Usage: perl $0 -sum selected_sequence_accn.txt -dir . -fa targeted_fasta 

INFO

($opts{help} or !defined $opts{sum}  or !defined $opts{fa}) and print $info and exit;

my $dir = $opts{dir} ? $opts{dir} : '.';
$dir = abs_path($dir);

open(SUM, '<', $opts{sum}) or die $!;
my %accn_dict;
while(<SUM>){
	chomp;
	/^\#/ and next;
        /^genbank_accn/ and next;
	my @tmp = split(/\t/, $_, -1);
#	$tmp[11] =~/$ass_level/i or next;
	$tmp[5] =~s/str.//;#assembly_accession
	$tmp[5] =~s/[()=.]//g;
	$tmp[5] =~s/\s+/_/g;
	$tmp[6] =~s/\s//g;#taxid
        my $key = $tmp[0];#genbank_accn
	my $value = join("|", @tmp[1,2,3,4,5,6]);#bclass|species_taxid|assembly_accession|taxid|organism_name|infraspecific_name
        $accn_dict{$key}=$value;
	}

close SUM;



open(FA,'<'.$opts{fa}) or die $!;
my $re = "\n";
while(my $fa=<FA>){
    chomp $fa;
    (my $head=$fa)=~s/^\>//;
    my @head_cl=split(/\s+/,$head);
    my $accn = $head_cl[0];
    if (!exists$accn_dict{$accn}){
        $/ = "$re>";
        my $seq = <FA>;
	$/ ="$re";
        next;
    }
    my $new_key = $accn_dict{$accn};
    $/ = "$re>";
    my $seq = <FA>;
    chomp $seq;
    $/ = $re;
#    $head =~ /plasmid/ and next;
    print ">$new_key|$head\n$seq\n";
}
close FA;



#!/usr/bin/perl -w

use strict;
use JSON;
use POSIX qw(round);

use Data::Dumper;

my $tree = { 'count' => 0 };
my $depth = 12;

open(my $file, '<', $ARGV[0]);
while(<$file>) {
    chomp;
    my @strarr = split(//);

    my $treepos = $tree;
    for(my $i = 0; $i <= $#strarr; $i++) {
        unless(defined($treepos->{$strarr[$i]})) {
            $treepos->{$strarr[$i]} = { 'count' => 0 };
        }
        $treepos->{'count'}++;
        $treepos = $treepos->{$strarr[$i]};
    }
}

my $oxyrate = '0b';
my $co2rate = '0b';

my $treepos = $tree;
while(1) {
    if(defined($treepos->{"0"}) && defined($treepos->{"1"})) {
        if($treepos->{"0"}->{'count'} > $treepos->{"1"}->{'count'}) {
            $treepos = $treepos->{"0"};
            $oxyrate .= "0";
        } else {
            $treepos = $treepos->{"1"};
            $oxyrate .= "1";
        }
    } elsif(defined($treepos->{"0"})) {
        $treepos = $treepos->{"0"};
        $oxyrate .= "0";
    } elsif(defined($treepos->{"1"})) {
        $treepos = $treepos->{"1"};
        $oxyrate .= "1";
    } else {
        last;
    }
}

$treepos = $tree;
while(1) {
    if(defined($treepos->{"0"}) && defined($treepos->{"1"})) {
        if($treepos->{"0"}->{'count'} <= $treepos->{"1"}->{'count'}) {
            $treepos = $treepos->{"0"};
            $co2rate .= "0";
        } else {
            $treepos = $treepos->{"1"};
            $co2rate .= "1";
        }
    } elsif(defined($treepos->{"0"})) {
        $treepos = $treepos->{"0"};
        $co2rate .= "0";
    } elsif(defined($treepos->{"1"})) {
        $treepos = $treepos->{"1"};
        $co2rate .= "1";
    } else {
        last;
    }
}



print "$oxyrate // " . oct($oxyrate) . "\n";
print "$co2rate // " . oct($co2rate) . "\n";

print "Result: " . oct($oxyrate) * oct($co2rate) . "\n";
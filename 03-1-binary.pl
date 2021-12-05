#!/usr/bin/perl -w

use strict;
use POSIX qw(round);

use Data::Dumper;

my $blist = [];
my $commons = {};

open(my $file, '<', $ARGV[0]);
while(<$file>) {
    chomp;
    push(@{$blist}, $_);
}

foreach (@{$blist}) {
    my @strarr = split(//);
    for(my $i = 0; $i <= $#strarr; $i++) {
        $commons->{$i}->{$strarr[$i]}++;
    }
}

my $gamrate = '0b';
my $epsrate = '0b';

foreach my $idx (sort { $a <=> $b } keys(%{$commons})) {
    if(round($commons->{$idx}->{'1'} / ($commons->{$idx}->{'1'} + $commons->{$idx}->{'0'})) == 1) {
        $gamrate .= "1";
        $epsrate .= "0";
    } else {
        $gamrate .= "0";
        $epsrate .= "1";
    }
}

print "$gamrate // " . oct($gamrate) . "\n";
print "$epsrate // " . oct($epsrate) . "\n";

print oct($gamrate) * oct($epsrate) . "\n";
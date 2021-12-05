#!/usr/bin/perl -w

use strict;

use Data::Dumper;

my $arr = [];

open(my $file, '<', $ARGV[0]);
while(<$file>) {
    chomp;
    $_ =~ /([0-9]+),([0-9]+)\s+->\s+([0-9]+),([0-9]+)/;
    my ($x1, $y1, $x2, $y2) = ($1, $2, $3, $4);

    if($x1 == $x2) {
        my $ymin = ($y1 < $y2 ? $y1 : $y2);
        my $ymax = ($y1 > $y2 ? $y1 : $y2);

        for(my $i = $ymin; $i <= $ymax; $i++) {
            unless($arr->[$x1]->[$i]) {
                $arr->[$x1]->[$i] = 0;
            }

            $arr->[$x1]->[$i]++;
        }
    } elsif($y1 == $y2) {
        my $xmin = ($x1 < $x2 ? $x1 : $x2);
        my $xmax = ($x1 > $x2 ? $x1 : $x2);

        for(my $i = $xmin; $i <= $xmax; $i++) {
            unless($arr->[$i]->[$y1]) {
                $arr->[$i]->[$y1] = 0;
            }

            $arr->[$i]->[$y1]++;
        }
    }
}

my $count = 0;
foreach my $x (@{$arr}) {
    foreach my $y (@{$x}) {
        next unless(defined($y));
        $count++ if($y > 1);
    }
}

print "Overlaps: $count\n";
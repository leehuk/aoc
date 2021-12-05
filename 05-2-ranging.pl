#!/usr/bin/perl -w

use strict;

use Data::Dumper;


sub draw {
    my $arr = shift;
    my $count = shift;

    for(my $i = 0; $i < $count; $i++) {
        for(my $j = 0; $j < $count; $j++) {
            if(defined($arr->[$i]->[$j])) {
                print $arr->[$i]->[$j];
            } else {
                print ".";
            }
        }

        print "\n";
    }

    print "\n";
}


my $arr = [];

open(my $file, '<', $ARGV[0]);
while(<$file>) {
    chomp;
    $_ =~ /([0-9]+),([0-9]+)\s+->\s+([0-9]+),([0-9]+)/;
    my ($x1, $y1, $x2, $y2) = ($1, $2, $3, $4);

    if($x1 == $x2) {
        #print "Drawing vertical: $x1,$y1->$y2\n";

        my $ymin = ($y1 < $y2 ? $y1 : $y2);
        my $ymax = ($y1 > $y2 ? $y1 : $y2);

        for(my $i = $ymin; $i <= $ymax; $i++) {
            unless($arr->[$x1]->[$i]) {
                $arr->[$x1]->[$i] = 0;
            }

            $arr->[$x1]->[$i]++;
        }
    } elsif($y1 == $y2) {
        #print "Drawing horizontal: $x1->$x2,$y1\n";

        my $xmin = ($x1 < $x2 ? $x1 : $x2);
        my $xmax = ($x1 > $x2 ? $x1 : $x2);

        for(my $i = $xmin; $i <= $xmax; $i++) {
            unless($arr->[$i]->[$y1]) {
                $arr->[$i]->[$y1] = 0;
            }

            $arr->[$i]->[$y1]++;
        }
    } elsif(abs($x1-$x2) == abs($y1-$y2)) {
        #print "Drawing diag: $x1->$x2,$y1->$y2\n";

        my ($xmin, $xmax, $y, $ydir);
        if($x1 < $x2) {
            $xmin = $x1;
            $xmax = $x2;
            $y = $y1;
            $ydir = ($y1 < $y2 ? 1 : -1);
        } else {
            $xmin = $x2;
            $xmax = $x1;
            $y = $y2;
            $ydir = ($y2 < $y1 ? 1 : -1);
        }

        for(my $i = $xmin; $i <= $xmax; $i++) {
            unless($arr->[$i]->[$y]) {
                $arr->[$i]->[$y] = 0;
            }

            $arr->[$i]->[$y]++;
            $y += $ydir;
        }
    }

    #draw($arr);
}

my $count = 0;
foreach my $x (@{$arr}) {
    foreach my $y (@{$x}) {
        next unless(defined($y));
        $count++ if($y > 1);
    }
}

print "Overlaps: $count\n";
draw($arr, 350);
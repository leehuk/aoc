#!/usr/bin/perl -w

use strict;

use Data::Dumper;

sub bparse
{
    my $mapping = shift;
    my $bstring = shift;

    $bstring =~ s/^\s*(.*?)\s*$/$1/;
    $bstring =~ s/\s+/ /g;

    my @data = split(/ /, $bstring);

    my $board = { 'total' => 0 };
    for(my $i = 0; $i < 25; $i++) {
        unless(defined($mapping->{$data[$i]})) {
            $mapping->{$data[$i]}->{'boards'} = [];
            $mapping->{$data[$i]}->{'rows'} = [];
        }

        $board->{'total'} += $data[$i];
        push(@{$mapping->{$data[$i]}->{'boards'}}, $board);
    }

    my $arrs = [
        # rows
        [0, 1, 2, 3, 4],
        [5, 6, 7, 8, 9],
        [10, 11, 12, 13, 14],
        [15, 16, 17, 18, 19],
        [20, 21, 22, 23, 24],
        # columns
        [0, 5, 10, 15, 20],
        [1, 6, 11, 16, 21],
        [2, 7, 12, 17, 22],
        [3, 8, 13, 18, 23],
        [4, 9, 14, 19, 24]
    ];

    foreach my $arr (@{$arrs}) {
        my $nums = [];
        my $total = 0;

        foreach my $idx (@${arr}) {
            push(@{$nums}, $data[$idx]);
            $total += $data[$idx];
        }

        my $row = {
            'board' => $board,
            'seen' => 0, # cant use total as proxy, because 0 is a bingo number
            'total' => $total
        };

        foreach my $num (@{$nums}) {
            push(@{$mapping->{$num}->{'rows'}}, $row);
        }
    }

    push(@{$mapping->{'boards'}}, $board);
}


open(my $file, '<', $ARGV[0]);

my $calls = <$file>;
chomp($calls);
<$file>;

my $mapping = { 'boards' => [] };
# parse boards
while(1) {
    my $bstring = '';
    for(my $i = 0; $i < 5; $i++) {
        my $line = <$file>;
        chomp($line);

        $bstring .= $line . " ";
    }
    <$file>;

    bparse($mapping, $bstring);

    last if eof($file);
}

foreach my $call (split(/,/, $calls)) {
    print "Calling $call\n";

    foreach my $board (@{$mapping->{$call}->{'boards'}}) {
        $board->{'total'} -= $call;
    }

    foreach my $row (@{$mapping->{$call}->{'rows'}}) {
        $row->{'total'} -= $call;
        $row->{'seen'}++;

        if($row->{'seen'} == 5) {
            print "Found winner\n";
            print "remaining: " . $row->{'board'}->{'total'} . "\n";
            print $row->{'board'}->{'total'} * $call . "\n";
            exit;
        }
    }
}
#!/usr/bin/perl -w

use strict;

use Data::Dumper;

sub forward {
    my $data = shift;
    my $arg = shift;

    $data->{'position'} += $arg;
    $data->{'depth'} += ($arg * $data->{'aim'});
}

sub down {
    my $data = shift;
    my $arg = shift;

    $data->{'aim'} += $arg;
}

sub up {
    my $data = shift;
    my $arg = shift;

    $data->{'aim'} -= $arg;
}

my $data = { 'position' => 0, 'depth' => 0, 'aim' => 0 };
my $handlers = {
    'forward' => \&forward,
    'down'  => \&down,
    'up' => \&up
};

open(my $file, '<', $ARGV[0]);
while(<$file>) {
    chomp;

    print "$_\n";

    my @arg = split(/ /);
    &{$handlers->{$arg[0]}}($data, $arg[1]);
    print Dumper($data);
}

print $data->{'position'} * $data->{'depth'} . "\n";
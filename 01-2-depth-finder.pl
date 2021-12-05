# depth-finder.pl

my $counter = 0;

my $slidetotal = 0;
my $slidevalues = [];

open(my $file, '<', $ARGV[0]);

for(my $i = 0; $i < 3; $i++) {
    my $val = <$file>;
    chomp($val);

    print "$val // $slidetotal\n";

    push(@${slidevalues}, $val);
    $slidetotal += $val;
}

while(my $val = <$file>)
{
    chomp($val);

    my $unslide = shift(@{$slidevalues});
    push(@{$slidevalues}, $val);

    my $newtotal = $slidetotal - $unslide + $val;

    if($newtotal > $slidetotal) {
        $counter++;
    }

    print "$val // $unslide // $slidetotal // $newtotal\n";

    $slidetotal = $newtotal;
}


print "$counter\n";
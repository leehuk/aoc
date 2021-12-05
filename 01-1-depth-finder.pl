# depth-finder.pl

my $counter = 0;

open(my $file, '<', $ARGV[0]);
my $prev = <$file>;
chomp($prev);

while(my $cur = <$file>)
{
    chomp($cur);
    if($cur > $prev) {
        $counter++;
    }

    print "$prev/$cur -- $counter\n";

    $prev = $cur;
}

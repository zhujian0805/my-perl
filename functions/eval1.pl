use Data::Dumper;
open( FH, 'gzip -dc eval1.txt.gz|' ) or die "$!";
my $folders = eval( join( '', <FH> ) );
print Dumper \$folders;

# To convert to a HASH you can just add a % for the left and %{} surround eval statement
#my %folders = %{eval(join('',<FH>))};
#print Dumper \%folders;

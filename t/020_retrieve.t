# -*- perl -*-

use Test::More tests => 6;

BEGIN { use_ok( 'Storable::CouchDB' ); }

my $s = Storable::CouchDB->new;
isa_ok ($s, 'Storable::CouchDB');

diag("retrieve");
$return=$s->retrieve('mydockey');
diag explain $return;
isa_ok($return, "HASH", "always a hash return");
is(scalar(keys %$return), 1, 'sizeof');
is((keys(%$return))[0], "Hello", "Keys");
is($return->{"Hello"}, "World!", "Values");

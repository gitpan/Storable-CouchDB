# -*- perl -*-

use Test::More tests => 3;

BEGIN { use_ok( 'Storable::CouchDB' ); }

my $s = Storable::CouchDB->new;
isa_ok ($s, 'Storable::CouchDB');

diag("retrieve");
$return=$s->retrieve('mydockey');
diag explain $return;
is($return, undef, "undef when not exists");

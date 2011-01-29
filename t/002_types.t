# -*- perl -*-

use Test::More tests => 20;

BEGIN { use_ok( 'Storable::CouchDB' ); }

my $s = Storable::CouchDB->new;
isa_ok ($s, 'Storable::CouchDB');

my $key="varable-test";

diag("hash");
{
  my $data=$s->store($key=>{Hello=>'World!'}); #overwrites or creates if not exists
  diag explain $data;
  isa_ok($data, "HASH", "hash return");
  is($data->{"Hello"}, "World!", "Values");
}
{
  my $data=$s->retrieve($key);
  diag explain $data;
  isa_ok($data, "HASH", "hash return");
  is($data->{"Hello"}, "World!", "Values");
}

diag("array");
{
  my $data=$s->store($key=>[Hello=>'World!']); #overwrites or creates if not exists
  diag explain $data;
  isa_ok($data, "ARRAY", "array return");
  is($data->[0], "Hello", "Values");
  is($data->[1], "World!", "Values");
}
{
  my $data=$s->retrieve($key);
  diag explain $data;
  isa_ok($data, "ARRAY", "array return");
  is($data->[0], "Hello", "Values");
  is($data->[1], "World!", "Values");
}

diag("scalar");
{
  my $data=$s->store($key=>'Hello World!'); #overwrites or creates if not exists
  diag explain $data;
  is(ref($data), "", "scalar return");
  is($data, "Hello World!", "Values");
}
{
  my $data=$s->retrieve($key);
  diag explain $data;
  is(ref($data), "", "scalar return");
  is($data, "Hello World!", "Values");
}

diag("undef");
{
  my $data=$s->store($key=>undef); #overwrites or creates if not exists
  diag explain $data;
  is(ref($data), "", "scalar return");
  is($data, undef, "Values");
}
{
  my $data=$s->retrieve($key);
  diag explain $data;
  is(ref($data), "", "scalar return");
  is($data, undef, "Values");
}

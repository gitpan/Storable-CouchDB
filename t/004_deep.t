# -*- perl -*-

use Test::More tests => 8;

BEGIN { use_ok( 'Storable::CouchDB' ); }

my $s = Storable::CouchDB->new;
isa_ok ($s, 'Storable::CouchDB');

my $key="varable-test";

my $data={ a => [0 .. 10000],
           b=>{c=>{d=>{e=>{f=>{g=>{h=>{i=>["a" .. "z"]}}}}}}},
         };

{
  my $data=$s->store($key=>$data); #overwrites or creates if not exists
  #diag explain $data;
  isa_ok($data, "HASH", "hash return");
  is($data->{"a"}->[1900], "1900", "Values");
  is($data->{"b"}->{"c"}->{"d"}->{"e"}->{"f"}->{"g"}->{"h"}->{"i"}->[25], "z", "Values");
}
{
  my $data=$s->retrieve($key);
  #diag explain $data;
  isa_ok($data, "HASH", "hash return");
  is($data->{"a"}->[1900], "1900", "Values");
  is($data->{"b"}->{"c"}->{"d"}->{"e"}->{"f"}->{"g"}->{"h"}->{"i"}->[25], "z", "Values");
}

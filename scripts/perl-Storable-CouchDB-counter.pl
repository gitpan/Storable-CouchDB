#!/usr/bin/perl
use strict;
use warnings;
use Storable::CouchDB;

=head1 NAME

perl-Storable-CouchDB-counter.pl - Storable::CouchDB Simple Counter Example

=cut

my $s=Storable::CouchDB->new; #default localhost server, default database name

my $index=$s->retrieve("counter"); #remember where we left off
while (1) {
  printf "Counter: %s (Control-c to exit)\n", $index++;
  $s->store(counter => $index); #store the counter in case we exit
  sleep 1;
}

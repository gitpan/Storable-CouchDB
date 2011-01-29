package Storable::CouchDB;
use strict;
use warnings;
use CouchDB::Client;

our $VERSION='0.02';

=head1 NAME

Storable::CouchDB - Persistence for Perl data structures in CouchDB

=head1 SYNOPSIS

  use Storable::CouchDB;
  my $s = Storable::CouchDB->new;
  my $data = $s->retrieve('doc'); #undef if not exists
  $s->store('doc', "data");       #overwrites or creates if not exists
  $s->store('doc', {"my" => "data"});
  $s->store('doc', ["my", "data"]);
  $s->store('doc', undef);
  $s->delete('doc');

=head2 Inheritance

  package My::Storable::CouchDB;
  use base qw{Storable::CouchDB};
  sub db {"what-i-want"};
  sub uri {"http://where.i.want:5984/"};
  1;

=head1 DESCRIPTION

The Storable::CouchDB package brings persistence to your Perl data structures containing SCALAR, ARRAY, HASH or anything that can be serialized into JSON.

The concept for this package is to provide similar capabilities as Storable::store and Storable::retrieve which work seamlessly with a CouchDB instead of a file system.

=head1 USAGE

Write perl data structure to database.

  use Storable::CouchDB;
  my $s = Storable::CouchDB->new;
  $s->store('mydockey' => {Hello=>'World!'});

Read perl data structure from database.

  use Storable::CouchDB;
  use Data::Dumper qw{Dumper};
  my $s = Storable::CouchDB->new;
  my $data = $s->retrieve('mydockey');
  print Dumper([$data]);

=head1 METHODS

=head1 CONSTRUCTOR

=head2 new

  my $s = Storable::CouchDB->new; #use default server and database

  my $s = Storable::CouchDB->new(
            uri => 'http://127.0.0.1:5984/',  #default
            db  => 'perl-storable-couchDB'    #default
                                );

=cut

sub new {
  my $this = shift();
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;
  $self->initialize(@_);
  return $self;
}

=head1 METHODS

=head2 initialize

=cut

sub initialize {
  my $self = shift();
  %$self=@_;
}

=head2 store

  $s->store('key' => "");
  $s->store('key' => {});
  $s->store('key' => []);
  my $data=$s->store('key' => {}); #returns data

API Difference: The L<Storable> API uses the $data=>$fileiname argument format which I think is counterintuitive for a key=>value store like CouchDB.

=cut

sub store {
  my $self=shift;
  die("Error: Wrong number of arguments.") unless @_ == 2;
  my $id=shift;
  die("Error: ID must be defined.") unless defined $id;
  my $data=shift; #support storing undef!
  my $doc=$self->_db->newDoc($id);
  if ($self->_db->docExists($id)) {
    $doc->retrieve; #to get revision number for object
    $doc->data({data=>$data});
    $doc->update;
  } else {
    $doc->data({data=>$data});
    $doc->create;
  }
  return $doc->data->{"data"};
}

=head2 retrieve

  my $scalar=$s->retrieve("key"); #undef if not exists (but you can also store undef)

=cut

sub retrieve {
  my $self=shift;
  die("Error: Wrong number of arguments.") unless @_ == 1;
  my $id=shift;
  die("Error: ID must be defined.") unless defined $id;
  if ($self->_db->docExists($id)) {
    my $doc=$self->_db->newDoc($id);
    $doc->retrieve;
    return $doc->data->{"data"};
  } else {
    return undef;
  }
}

=head2 delete

  $s->delete("key");

  my $data=$s->delete("key"); #returns value from database just before delete

=cut

sub delete {
  my $self=shift;
  die("Error: Wrong number of arguments.") unless @_ == 1;
  my $id=shift;
  die("Error: ID must be defined.") unless defined $id;
  if ($self->_db->docExists($id)) {
    my $doc=$self->_db->newDoc($id);
    $doc->retrieve;
    my $data=$doc->data->{"data"};
    $doc->delete;
    return $data; #return want we delete
  } else {
    return undef;
  }
}

=head1 METHODS (Properties)

=cut

sub _client {
  my $self=shift;
  unless (defined $self->{"_client"}) {
    $self->{"_client"}=CouchDB::Client->new(uri=>$self->uri);
    $self->{"_client"}->testConnection or die("Error: CouchDB Server Unavailable");
  }
  return $self->{"_client"};
}

sub _db {
  my $self=shift;
  unless (defined $self->{"_db"}) {
    $self->{"_db"}=$self->_client->newDB($self->db);
    $self->{"_db"}->create unless $self->_client->dbExists($self->db);
  }
  return $self->{"_db"};
}

=head2 db

Sets and retrieves the CouchDB database name.

Default: perl-storable-couchdb

Limitation: Only lowercase characters (a-z), digits (0-9), and any of the characters _, $, (, ), +, -, and / are allowed. Must begin with a letter.

=cut

sub db {
  my $self=shift;
  $self->{"db"}=shift if @_;
  $self->{"db"}='perl-storable-couchdb' unless defined $self->{"db"};
  return $self->{"db"};
}

=head2 uri

URI of the CouchDB server

Default: http://127.0.0.1:5984/

=cut

sub uri {
  my $self=shift;
  $self->{"uri"}=shift if @_;
  $self->{"uri"}='http://127.0.0.1:5984/' unless defined $self->{"uri"};
  return $self->{"uri"};
}

=head1 BUGS

Please log on RT and send an email to the author.

=head1 SUPPORT

DavisNetworks.com supports all Perl applications including this package.

=head1 AUTHOR

  Michael R. Davis
  CPAN ID: MRDVT
  Satellite Tracking of People, LLC
  mdavis@stopllc.com
  http://www.stopllc.com/

=head1 COPYRIGHT

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the LICENSE file included with this module.

=head1 SEE ALSO

L<Storable>, L<CouchDB::Client>, Apache CouchDB http://couchdb.apache.org/

=cut

1;

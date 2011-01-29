use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'Storable::CouchDB',
    VERSION_FROM => 'lib/Storable/CouchDB.pm',
    AUTHOR       => 'Michael R. Davis (mdavis@stopllc.com)',
    ABSTRACT_FROM=> 'lib/Storable/CouchDB.pm',
    PREREQ_PM    => {
                     'Test::Simple'    => 0.44,
                     'CouchDB::Client' => 0,
                    },
);

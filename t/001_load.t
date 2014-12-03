# -*- perl -*-

# t/001_load.t - check module loading and create testing directory

use Test::More tests => 2;

BEGIN { use_ok( 'JSON::Infer::Moose' ); }

my $object = JSON::Infer::Moose->new ();
isa_ok ($object, 'JSON::Infer::Moose');



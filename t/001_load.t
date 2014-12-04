
use Test::More;

use_ok( 'JSON::Infer::Moose' );

my $object = JSON::Infer::Moose->new ();
isa_ok ($object, 'JSON::Infer::Moose');

use_ok('JSON::Infer::Moose::Class');

use_ok('JSON::Infer::Moose::Attribute');

use_ok('JSON::Infer::Moose::Role::Classes');

done_testing();

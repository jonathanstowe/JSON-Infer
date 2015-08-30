
use v6;
use lib 'lib';

use Test;

use-ok( 'JSON::Infer' );

my $object = JSON::Infer.new();
isa_ok ($object, 'JSON::Infer');

use-ok('JSON::Infer::Class');

use-ok('JSON::Infer::Attribute');

use-ok('JSON::Infer::Type');

use-ok('JSON::Infer::Role::Classes');
use-ok('JSON::Infer::Role::Types');

done-testing();
# vim: expandtab shiftwidth=4 ft=perl6

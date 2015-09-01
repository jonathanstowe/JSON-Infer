#!perl6

use v6;
use Test;
use lib 'lib';

use JSON::Infer;

my $obj;

lives-ok { $obj = JSON::Infer.new() }, "create a new JSON::Infer";
isa-ok($obj, JSON::Infer, "and it is the right sort of thing");

my $ret;

lives-ok { $ret = $obj.infer(uri => 'http://api.mixcloud.com/spartacus/party-time/') }, "infer from mixcloud";
isa-ok($ret, JSON::Infer::Class, "and it does return a JSON::Infer::Class");

done-testing();
# vim: expandtab shiftwidth=4 ft=perl6


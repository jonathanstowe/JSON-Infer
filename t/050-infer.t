#!perl6

use v6;
use Test;
use lib 'lib';

use JSON::Infer;

use JSON::Class;
use JSON::Name;

my $obj;

lives-ok { $obj = JSON::Infer.new() }, "create a new JSON::Infer";
isa-ok($obj, JSON::Infer, "and it is the right sort of thing");

my $ret;

lives-ok { $ret = $obj.infer(uri => 'http://api.mixcloud.com/spartacus/party-time/', class-name => 'Mixcloud::Show') }, "infer from mixcloud";
isa-ok($ret, JSON::Infer::Class, "and it does return a JSON::Infer::Class");

my $class-str;

lives-ok { $class-str = $ret.make-class() }, "make class";
lives-ok { EVAL $class-str }, "and make sure that it at least evals nicely";

my $new-obj;
lives-ok { $new-obj = ::('Mixcloud::Show').new } , "and got the type we defined";

does-ok $new-obj, JSON::Class, "and has the role we want";

done-testing();

# vim: expandtab shiftwidth=4 ft=perl6

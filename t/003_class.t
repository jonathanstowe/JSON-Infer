use Test::More;

use strict;
use warnings;

use_ok('JSON::Infer::Moose::Class');


my @tests = (
   {
      description => 'simple attributes',
      class_name  => 'My::Test',
      value => {
         foo   => 'var',
         baz   => 9,
         yada  => undef,
      },
      classes  => 0,
   },
   {
      description => 'attribute with one object',
      class_name  => 'My::Test',
      value => {
         foo   => 'var',
         baz   => 9,
         yada  => { cart => 'horse'},
      },
      classes  => 1,
   },
   {
      description => 'attribute with more deeply nested object',
      class_name  => 'My::Test',
      value => {
         foo   => 'var',
         baz   => 9,
         yada  => { cart => {type => 'hat'}},
      },
      classes  => 2,
   },
);

foreach my $test ( @tests )
{
   ok(my $object = JSON::Infer::Moose::Class->new_from_data($test->{class_name}, $test->{value}), "new_from_data " . $test->{description});
   isa_ok($object, 'JSON::Infer::Moose::Class');
   is($object->name(), $test->{class_name}, "got the right name");
   is($object->attributes(), keys %{$test->{value}}, "got the right number of attributes");
   is(@{$object->classes()}, $test->{classes}, "have " . ( $test->{classes} ? $test->{classes} : 'no' ) . " classes");

   foreach my $attr (keys %{$test->{value}} )
   {
      ok(my $attr_def = $object->_attributes()->{$attr}, "got attribute $attr");
      isa_ok($attr_def, 'JSON::Infer::Moose::Attribute');
      is($attr_def->class(), $object->name(), "and the attribute has the right class");
   }

}

done_testing();

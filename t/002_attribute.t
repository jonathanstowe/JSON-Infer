
use Test::More;

use JSON;

BEGIN { use_ok( 'JSON::Infer::Moose::Attribute' ); }


my $object = JSON::Infer::Moose::Attribute->new ();
isa_ok ($object, 'JSON::Infer::Moose::Attribute');


my @tests = (
               {
                  attr_name   => 'test_attr',
                  value => 'foo',
                  class => 'My::Test',
                  type_constraint   => 'Str',
                  classes  => 0,
                  description => 'value is a string',
               },
               {
                  attr_name   => 'test_attr',
                  value => 9,
                  class => 'My::Test',
                  type_constraint   => 'Num',
                  classes  => 0,
                  description => 'value is a Number',
               },
               {
                  attr_name   => 'test_attr',
                  value => undef,
                  class => 'My::Test',
                  type_constraint   => 'Maybe[Str]',
                  classes  => 0,
                  description => 'value is undefined',
               },
               {
                  attr_name   => 'test_attr',
                  value => JSON::true(),
                  class => 'My::Test',
                  type_constraint   => 'Bool',
                  classes  => 0,
                  description => 'value is a boolean (true)',
               },
               {
                  attr_name   => 'test_attr',
                  value => JSON::false(),
                  class => 'My::Test',
                  type_constraint   => 'Bool',
                  classes  => 0,
                  description => 'value is a boolean (false)',
               },
               {
                  attr_name   => 'test_attr',
                  value => ['foo'],
                  class => 'My::Test',
                  type_constraint   => 'ArrayRef',
                  classes  => 0,
                  description => 'value is an Array of strings',
               },
               {
                  attr_name   => 'test_attr',
                  value => { test_attr => 'foo' },
                  class => 'My::Test',
                  type_constraint   => 'My::Test::TestAttr',
                  classes  => 1,
                  description => 'value is an object',
               },
               {
                  attr_name   => 'test_attr',
                  value => { test_attr => 'foo', 'class_attr' => { foo => 9 } },
                  class => 'My::Test',
                  type_constraint   => 'My::Test::TestAttr',
                  classes  => 2,
                  description => 'value is an object with an object attribute',
               },
               {
                  attr_name   => 'test_attr',
                  value => [{ test_attr => 'foo' }],
                  class => 'My::Test',
                  type_constraint   => 'ArrayRef[My::Test::TestAttr]',
                  classes  => 1,
                  description => 'value is an an array of object',
               },
            );


foreach my $test (@tests)
{
   ok(my $object = JSON::Infer::Moose::Attribute->new_from_value( $test->{attr_name}, $test->{value}, $test->{class}), "new_from_value " . $test->{description});

   isa_ok ($object, 'JSON::Infer::Moose::Attribute');
   is( $object->name(), $test->{attr_name}, "got the right name" );
   is( $object->type_constraint(), $test->{type_constraint}, "got the right type constraint" );
   is( @{ $object->classes() }, $test->{classes}, "and " . ( $test->{classes} ? $test->{classes} : 'no' ) . ' classes' );
}


done_testing();

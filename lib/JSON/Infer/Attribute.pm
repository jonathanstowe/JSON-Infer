
use v6;

=begin pod

=head1 NAME

JSON::Infer::Attribute

=head1 DESCRIPTION

A description of an infered attribute

=head2 METHODS

=over 4

=head3 new-from-value

This is an alternate constructor that will return a new object based
on the name and attributes infered from the valie.

The third argument is the name of the class the attribute was found in
this will be used to generate the names of any new classes found.

=head3 infer_from_value

This does the actual work of infering the type from the value provided.

=head3 process_object

This is used to process an object value returning the
JSON::Infer::Class object.

=head3 name

The name of the attribute

=head3 type_constraint

The infered type constraint.

=head3 class

Name of the class that this was being constructed for.

=head3 child_class_name

Returns the name of a class that will be used for an object type based on
this attribute.

=end pod

use JSON::Infer::Role::Classes;
use JSON::Infer::Role::Types;

class JSON::Infer::Attribute does JSON::Infer::Role::Classes does JSON::Infer::Role::Types {

    method  new-from-value(Str $name, $value, $class) returns JSON::Infer::Attribute {

        my $obj = self.new(name => $name, class => $class );
        $obj.infer-from-value($value);
        $obj;
    }


    method infer-from-value($value) {

        my $type_constraint;

        given $value {
            when Array {
                if ?$_.grep(Array|Hash) {
                    my $obj = self.process-object($_);
                    $type_constraint = "Array[{$obj.name}]";
                }
                else {
                    $type_constraint = 'Array';
                }
            }
            when Hash {
                my $obj = self.process-object($_);
                $type_constraint = $obj.name;

            }
            default {
                $type_constraint = $_.WHAT.^name;
            }
        }

        $!type-constraint = $type_constraint;

    }

    method process-object($value) {
        my $obj = JSON::Infer::Class.new-from-data(self.child-class-name(), $value);
        self.add-classes($obj);
        self.add-types($obj);
        $obj;
    }


    has Str $.name is rw;
    has Str $.type-constraint is rw;
    has Str $.class is rw;


    has Str $.child-class-name is rw;

    method child-class-name() returns Str is rw { 
        if not $!child-class-name.defined {
            my Str $name = $!name;
            $name ~~ s:g/_(.)/{ $0.uc }/;
            $!child-class-name = $!class ~ '::' ~ $name.tc;
        }
        $!child-class-name;
    }
}
# vim: expandtab shiftwidth=4 ft=perl6

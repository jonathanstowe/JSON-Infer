
use v6;

=begin pod

=head1 NAME

JSON::Infer::Class

=head1 DESCRIPTION

This holds the infered definition of a class to be generated from
JSON input.

=head2 METHODS


=head3 new_from_data

This returns a L<JSON::Infer::Class> constructed from the provided
reference.

=head3 populate_from_data

This performs the actual inference from a single record.

=head3 new_attribute

=head3 name

This is the name of the class.

=head3 attributes

This is an array ref of the attributes discovered i the object.

=head3 add_attribute

Add the atribute to this class.

=end pod

need JSON::Infer::Role::Classes;
need JSON::Infer::Role::Types;

class JSON::Infer::Class does JSON::Infer::Role::Classes does JSON::Infer::Role::Types {

    need JSON::Infer::Attribute;

    method new-from-data(Str $name, $data ) returns JSON::Infer::Class {

        my $obj = self.new(name => $name);

        my @data;

        given $data {
            when Array {
                @data = $data.list;
            }
            default {
                @data.push($data);
            }
        }

        for @data -> $datum {
            $obj.populate-from-data($datum);
        }

        $obj;
    }


    method populate-from-data($datum) {

        for $datum.kv -> $attr, $value {
            if not %!attributes{$attr}:exists {
                my $new = self.new-attribute($attr, $value);
            }
        }
    }


    method new_attribute(Str $name, $value) returns JSON::Infer::Attribute {

        my $new = JSON::Infer::Attribute.new-from-value($name, $value, $!name);
        self.add-attribute($new);
        $new;
    }

    has Str $.name is rw;

    has JSON::Infer::Attribute %attributes;

    method add-attribute(JSON::Infer::Attribute $attr) {
        %!attributes{$attr.name} = $attr;
        self.add-classes($attr);
        self.add-types($attr);
    }
}
# vim: expandtab shiftwidth=4 ft=perl6

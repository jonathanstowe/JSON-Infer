
use v6;

=begin pod

=head1 NAME

JSON::Infer::Class

=head1 DESCRIPTION

This holds the infered definition of a class to be generated from
JSON input.

=head2 METHODS


=head3 new-from-data

This returns a L<JSON::Infer::Class> constructed from the provided
reference.

=head3 populate-from-data

This performs the actual inference from a single record.

=head3 new-attribute

=head3 name

This is the name of the class.

=head3 attributes

This is an Array of the L<JSON::Infer::Attribute> discovered in the object.

=head3 add-attribute

Add the atribute to this class.

=end pod

use JSON::Infer::Role::Classes;
use JSON::Infer::Role::Types;

class JSON::Infer::Class does JSON::Infer::Role::Classes does JSON::Infer::Role::Types {

    use JSON::Infer::Attribute;

    multi method new-from-data(:$class-name, :$content) returns JSON::Infer::Class {
        self.new-from-data($class-name, $content);
    }

    multi method new-from-data(Str $name, $data ) returns JSON::Infer::Class {

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


    method new-attribute(Str $name, $value) returns JSON::Infer::Attribute {

        my $new = JSON::Infer::Attribute.new-from-value($name, $value, $!name);
        self.add-attribute($new);
        $new;
    }

    has Str $.name is rw;

    has Bool $.top-level is rw = False;

    has JSON::Infer::Attribute %.attributes is rw;

    method add-attribute(JSON::Infer::Attribute $attr) {
        %!attributes{$attr.name} = $attr;
        self.add-classes($attr);
        self.add-types($attr);
    }

    method make-class(Int $level  = 0) returns Str {
        my $indent = "    " x $level;

        my Str $ret;

        if $!top-level {
            $ret ~= "{ $indent }use JSON::Class;\n{ $indent }use JSON::Name;\n";

        }

        $ret ~= $indent ~ "class { self.name } does JSON::Class \{";
        my $next-level = $level + 1;

        for self.classes -> $class {
            $ret ~= "\n" ~ $class.make-class($next-level);
        }

        for self.attributes.kv -> $name, $attr {
            $ret ~= "\n" ~ $attr.make-attribute($next-level) ;
        }

        $ret ~= "\n$indent\}";
        $ret;
    }

    method file-path() returns Str {
        my $path = $*SPEC.catfile($!name.split('::'));
        $path ~= '.pm';
        $path;
    }
}
# vim: expandtab shiftwidth=4 ft=perl6

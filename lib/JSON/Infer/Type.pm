package JSON::Infer::Moose::Type;

use strict;
use warnings;

use Moose;
with qw(
         JSON::Infer::Moose::Role::Entity
       );

=head1 NAME

JSON::Infer::Moose::Type

=head1 DESCRIPTION

This describes a L<Moose> typeconstraint;

=head2 METHODS

=over 4

=item name

This is the name of the typeconstraint that will be given to an attribute.

=cut

=item subtype_of

This is the type that the typeconstraint will be a subtype of.  This may be
undefined if this doesn't require to be a subtype.

=cut

has subtype_of => (
                     is => 'rw',
                     isa   => 'Maybe[Str]',
                     predicate   => 'has_subtype',
                  );


=item array 

This is a boolean to indicate whether this is 
an array type.  This has a bearing on the coercion being created.

=cut

has array   => (
                  is => 'rw',
                  isa   => 'Bool',
                  default  => 0,
               );

=item of_class

This is the L<JSON::Infer::Moose::Class> that this type is for.

=cut

has of_class   => (
                     is => 'rw',
                     isa   => 'JSON::Infer::Moose::Class',
                  );

=back

=cut

1;

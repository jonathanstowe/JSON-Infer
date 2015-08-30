package JSON::Infer::Moose::Role::Types;

use strict;
use warnings;


use Moose::Role;

=head1 NAME

JSON::Infer::Moose::Role::Types

=head1 DESCRIPTION

=head2 METHODS

=over 4

=item types

=cut

has types => (
                  is => 'rw',
                  isa   => 'ArrayRef[JSON::Infer::Moose::Types]',
                  traits   => [qw(Array)],
                  auto_deref  => 1,
                  default  => sub { [] },
                  handles  => {
                     all_types   => 'elements',
                     _add_type  => 'push',
                  },
               );

=item add_types

This takes and object of this role and adds it's types to my types.

=cut

sub  add_types
{
   my ( $self, $object ) = @_;

   if ( $object->DOES('JSON::Infer::Moose::Role::Types') )
   {
      foreach my $type ( $object->types() )
      {
         $self->_add_type($type);
      }
   }

   if ( $object->isa('JSON::Infer::Moose::Type') )
   {
      $self->_add_type($object);
   }
}


=back

=cut

1;

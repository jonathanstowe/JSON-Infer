package JSON::Infer::Role::Classes;

use strict;
use warnings;


use Moose::Role;

=head1 NAME

JSON::Infer::Role::Classes

=head1 DESCRIPTION

=head2 METHODS

=over 4

=item classes

=cut

has classes => (
                  is => 'rw',
                  isa   => 'ArrayRef[JSON::Infer::Class]',
                  traits   => [qw(Array)],
                  auto_deref  => 1,
                  default  => sub { [] },
                  handles  => {
                     all_classes   => 'elements',
                     _add_class  => 'push',
                  },
               );

=item add_classes

This takes and object of this role and adds it's classes to my classes.

=cut

sub  add_classes
{
   my ( $self, $object ) = @_;

   if ( $object->DOES('JSON::Infer::Role::Classes') )
   {
      foreach my $class ( $object->classes() )
      {
         $self->_add_class($class);
      }
   }

   if ( $object->isa('JSON::Infer::Class') )
   {
      $self->_add_class($object);
   }
}


=back

=cut

1;

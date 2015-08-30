package JSON::Infer::Class;

use strict;
use warnings;

our ($VERSION) = q$Revision:$ =~ /Revision:\s*(\d+)/;

use Moose;
with qw(
         JSON::Infer::Role::Classes
         JSON::Infer::Role::Types
       );

use Scalar::Util qw(reftype);



=head1 NAME

JSON::Infer::Class

=head1 DESCRIPTION

This holds the infered definition of a class to be generated from
JSON input.

=head2 METHODS

=over 4

=item new_from_data

This returns a L<JSON::Infer::Class> constructed from the provided
reference.

=cut

sub new_from_data
{
   my ( $self, $name, $data ) = @_;

   my $obj;

   if (ref($data) )
   {
      $obj = $self->new(name => $name);

      my @data;
      if (reftype($data) eq 'ARRAY')
      {
         @data = @{$data};
      }
      else
      {
         push @data, $data;
      }

      foreach my $datum (@data)
      {
         $obj->populate_from_data($datum);
      }
      
   }
   return $obj;
}

=item populate_from_data

This performs the actual inference from a single record.

=cut

sub populate_from_data
{
   my ( $self, $datum ) = @_;


   while (my ( $attr, $value ) = each %{$datum})
   {
      if(!$self->has_attribute($attr) )
      {
         my $new = $self->new_attribute($attr, $value);
      }
   }
}

=item new_attribute

=cut

sub new_attribute
{
   my ( $self, $name, $value ) = @_;

   require JSON::Infer::Attribute;
   my $new = JSON::Infer::Attribute->new_from_value($name, $value, $self->name());
   $self->add_attribute($new);

   return $new;
}



=item name

This is the name of the class.

=cut

has name => (
               is => 'rw',
               isa   => 'Str',
            );

=item attributes

This is an array ref of the attributes discovered i the object.

=cut

has _attributes  => (
                     is => 'rw',
                     isa   => 'HashRef[JSON::Infer::Attribute]',
                     default  => sub { {} },
                     traits   => [qw(Hash)],
                     handles  => {
                        attributes  => 'values',
                        has_attribute  => 'exists',
                        _add_attribute => 'set',
                     },
                  );


=item add_attribute

Add the atribute to this class.

=cut
                  
sub add_attribute
{
   my ( $self, $attr ) = @_;

   if ( $attr )
   {
      $self->_add_attribute($attr->name(), $attr);
      $self->add_classes($attr);
      $self->add_types($attr);
   }
}


=back

=cut

1;

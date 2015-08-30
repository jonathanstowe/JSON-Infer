package JSON::Infer::Role::Entity;

use strict;
use warnings;

use Moose::Role;


=head1 NAME

JSON::Infer::Role::Entity

=head1 DESCRIPTION

Role for common items between classes (name etc.)

=head2 METHODS

=over 4

=item name

=cut

has name => (
               is => 'rw',
               isa   => 'Str',
            );


=back



=cut

1;

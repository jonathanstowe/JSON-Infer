package JSON::Infer::Moose;

use strict;
use warnings;

our $VERSION = '0.1';

use Moose;


=head1 NAME

JSON::Infer::Moose - Infer Moose Classes from JSON objects

=head1 SYNOPSIS

  use JSON::Infer::Moose;


=head1 DESCRIPTION

This provides a mechanism for creating some stub Moose classes from 
the return of a REST Call.

=head2 METHODS

=over 4


=item infer

This accepts a single path and returns a L<JSON::Infer::Moose::Class>
object, if there is an error retrieving the data or parsing the response
it will throw an exception.

It requires the following named arguments:

=over 4

=item uri

This is the uri that will be used to retrieve the content.  It will need
to be some protocol scheme that is understood by L<LWP::UserAgent>

=item class_name

This is the base class name that will be used for the package, any child classes that are discovered will parsing the
attributes will have a name based on this and the name of the attribute.

=cut


=back


=cut

sub infer
{
   my ( $self, @args ) = @_;

   my $ret;

   if ( @args  )
   {
      my %args = @args;

      if ( defined(my $uri = $args{uri} ) )
      {
         my $resp =  $self->get($uri);

         if ($resp->is_success() )
         {
            require JSON::Infer::Moose::Class;

            my $name = $args{class_name} || 'My::JSON';

            my $content = $self->decode_json($resp->decoded_content());

            $ret = JSON::Infer::Moose::Class->new_from_data($name, $content);
         }
         else
         {
         }
      }
      else
      {
      }

   }

   return $ret;
}

=item ua

The L<LWP::UserAgent> that will be used. 

=cut

has ua   => (
               is => 'rw',
               isa   => 'LWP::UserAgent',
               lazy  => 1,
               builder  => '_get_ua',
               handles  => [qw(get)],
            );

sub _get_ua
{
   my ( $self ) = @_;
   require LWP::UserAgent;

   my $ua = LWP::UserAgent->new(
      default_headers   => $self->headers(), 
      agent => __PACKAGE__ . '/' . $VERSION,
   );




   return $ua;
}

=item headers

Returns the default set of headers that will be applied to the
LWP::UserAgent object.

=cut

has headers => (
                  is => 'rw',
                  isa   => 'HTTP::Headers',
                  lazy  => 1,
                  builder  => '_get_headers',
               );

sub _get_headers
{
   my ( $self ) = @_;

   require HTTP::Headers;

   my $h = HTTP::Headers->new();
   $h->header('Content-Type'  => $self->content_type());
   $h->header('Accept'  => $self->content_type());

   return $h;
}

=item content_type

This is the content type that we want to use.  The default is
"application/json".

=cut

has content_type  => (
                        is => 'rw',
                        isa   => 'Str',
                        default  => "application/json",
                     );


=item json_parser

This returns a JSON parser object.

=cut

has json_parser   => (
                        is => 'rw',
                        isa   => 'JSON',
                        lazy  => 1,
                        builder  => '_get_json',
                        handles  => {
                           decode_json => 'decode',
                           encode_json => 'encode',
                        },
                     );

sub _get_json
{
   my ( $self ) = @_;

   require JSON;

   my $json = JSON->new();

   return $json;
}


=back


=head1 BUGS



=head1 SUPPORT



=head1 AUTHOR

    Jonathan Stowe <jns@gellyfish.co.uk>

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.


=head1 SEE ALSO

perl(1).

=cut

1;

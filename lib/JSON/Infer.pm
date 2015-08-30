use v6;

=begin pod

=head1 NAME

JSON::Infer - Infer Moose Classes from JSON objects

=head1 SYNOPSIS

=begin code

  use JSON::Infer;

=end code


=head1 DESCRIPTION

This provides a mechanism for creating some stub Moose classes from 
the return of a REST Call.

=head2 METHODS

=over 4


=head3 infer

This accepts a single path and returns a L<JSON::Infer::Class>
object, if there is an error retrieving the data or parsing the response
it will throw an exception.

It requires the following named arguments:

=over 4

=head3 uri

This is the uri that will be used to retrieve the content.  It will need
to be some protocol scheme that is understood by L<LWP::UserAgent>

=head3 class_name

This is the base class name that will be used for the package, any child classes that are discovered will parsing the
attributes will have a name based on this and the name of the attribute.

=head3 ua

The L<LWP::UserAgent> that will be used. 

=head3 headers

Returns the default set of headers that will be applied to the
LWP::UserAgent object.

=head3 content_type

This is the content type that we want to use.  The default is
"application/json".

=head3 json_parser

This returns a JSON parser object.

=end pod

class JSON::Infer:ver<v0.0.1> {

    our $VERSION = v0.0.1;

    use HTTP::UserAgent;

    method infer(:$uri, Str :$class-name = 'My::JSON')
    {
        my $ret;


        if $uri.defined {
            my $resp =  self.get($uri);

            if $resp.is-success() {
                require JSON::Infer::Class;

                my $content = self.decode-json($resp.decoded-content());

                $ret = JSON::Infer::Class.new_from_data(:$class-name, :$content);
            }
            else {
            }
        }
        else {
        }

        return $ret;
    }


    has HTTP::UserAgent $.ua is rw handles <get>;

    method !get-ua {
        require HTTP::UserAgent;
        my $ua = HTTP::UserAgent.new( default-headers   => $.headers, agent => $?PACKAGE ~ '/' ~ $VERSION);
        $ua;
    }


    has HTTP::Header $.headers is rw;

    method !get-headers() {
        require HTTP::Header;
        my $h = HTTP::Header.new();
        $h.header('Content-Type'  => $!content-type);
        $h.header('Accept'  => $!content-type);
        $h;
    }


    has $.content-type  is rw =  "application/json";

    method decode-json(Str $content) {
        use JSON::Fast;
        from-json($content);
    }

}
# vim: expandtab shiftwidth=4 ft=perl6

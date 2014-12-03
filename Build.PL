use Module::Build;

my @args = (
             module_name   => 'JSON::Infer::Moose',
             license       => 'perl',
             author        => ['Jonathan Stowe <jns@gellyfish.co.uk'],
             requires      => {
                'Moose'            => undef,
                'JSON'             => undef,
                'LWP::UserAgent'   => undef,
             },
           );

my $build = Module::Build->new(@args);

$build->create_build_script();

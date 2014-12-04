use Module::Build;

my @args = (
             module_name   => 'JSON::Infer::Moose',
             license       => 'perl',
             author        => ['Jonathan Stowe <jns@gellyfish.co.uk>'],
             release_status   => 'unstable',
             share_dir  => [qw(share)],
             create_makefile_pl  => 'traditional',
             script_files  => 'bin',
             meta_merge         => {
                                      resources => { repository => 'https://github.com/jonathanstowe/UML-Model' }
                                },
             requires      => {
                'Moose'            => undef,
                'JSON'             => undef,
                'LWP::UserAgent'   => undef,
             },
           );

my $build = Module::Build->new(@args);

$build->create_build_script();

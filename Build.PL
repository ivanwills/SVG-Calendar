use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name       => 'SVG::Calendar',
    license           => 'perl',
    dist_author       => 'Ivan Wills <ivan.wills@gmail.com>',
    dist_version_from => 'lib/SVG/Calendar.pm',
    requires          => {
        'perl'                         => 5.008,
        'Config::Std'                  => 0,
        'SVG'                          => '2.33',
        'Math::Trig'                   => '1.15',
        'Template'                     => '2.14',
        'Template::Provider::FromDATA' => '0.08',
        'Image::ExifTool'              => '7.0',
        'DateTime::Format::Strptime'   => 0,
        'Clone'                        => '0.17',
        'Readonly'                     => '1.03',
        'version'                      => '0.74',
    },
    recommends => {
         'Astro::Coord::ECI::Moon'     => 0.044,
         'Astro::MoonPhase'            => 0.60,
    },
    build_requires => {
        'Test::More'          => 0,
        'Test::Pod'           => 0,
        'Test::Pod::Coverage' => 0,
        'Test::Spelling'      => 0,
        'Test::Kwalitee'      => 0,
        'Test::Perl::Critic'  => 0,
    },
    add_to_cleanup     => [ 'SVG-Calendar-*' ],
    create_makefile_pl => 'traditional',
    create_license     => 1,
    meta_merge         => {
        resources => {
            repository => 'http://github.com/ivanwills/SVG-Calendar',
            bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=SVG-Calendar',
        },
    },
);

$builder->create_build_script();

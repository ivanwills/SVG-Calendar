
use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
	module_name => 'SVG::Calendar',
	license  => 'perl',
	dist_author         => 'Ivan Wills <ivan.wills@gmail.com>',
    dist_version_from   => 'lib/SVG/Calendar.pm',
	requires => {
		#'perl'                         => 5.08,
		'SVG'                          => '2.33',
		'Math::Trig'                   => '1.15',
		'Template'                     => '2.14',
		'Template::Provider::FromDATA' => '0.08',
		'Image::ExifTool'              => '7.0', # '7.15',
		'Class::Date'                  => '1.1.7',
		'Clone'                        => '0.17',
		'Readonly'                     => '1.03',
		'version'                      => '0.74',
	},
	build_requires => {
		'Test::More' => 0,
	},
	add_to_cleanup      => [ 'SVG-Calendar-*' ],
	create_makefile_pl => 'traditional',
);
$build->create_build_script;

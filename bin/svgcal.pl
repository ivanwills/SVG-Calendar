#!/usr/bin/perl

# Created on: 2006-05-05 22:44:23
# Create by:  ivan
# $Id$
# # $Revision$, $HeadURL$, $Date$
# # $Revision$, $Source$, $Date$

use strict;
use warnings;
use version;
use Scalar::Util;
use Getopt::Long;
use Pod::Usage;
use Config::Std;
use Data::Dumper qw/Dumper/;
use SVG::Calendar;

our $VERSION = version->new('0.2.0');

my %option = (
	moon     => {},
	date     => {},
	ical     => {},
	page     => {},
	image    => {},
	height   => 0.5,
	config   => "$ENV{HOME}/.svgcal",
	path     => undef,
	template => undef,
	verbose  => 0,
	man      => 0,
	help     => 0,
	VERSION  => 0,
);

if ( !@ARGV ) {
	pod2usage( -verbose => 1 );
}

main();
exit 0;

sub main {
	Getopt::Long::Configure('bundling');
	GetOptions(
		\%option,
		'moon|m=s%',
		'date|d=s%',
		'ical|c=s%',
		'page|p=s%',
		'image|i=s%',
		'calendar_height|height|h=s',
		'config|C=s',
		'path|P=s',
		'template|t=s',
		'out|o=s',
		'save|s',
		'show-template',
		'verbose|v!',
		'man',
		'help',
		'VERSION'
	) or pod2usage(2);

	if ( $option{VERSION} ) {
		print "svgcal.pl Version = $VERSION\n";
		exit 1;
	}
	if ( $option{man} ) {
		pod2usage( -verbose => 2 );
	}
	if ( $option{help} ) {
		pod2usage( -verbose => 1 );
	}

	# do stuff here
	my $cal;

	if ( $option{save} && !-f $option{config} ) {
		open my $fh, '>', $option{config} or warn "Cannot create the configuration file '$option{config}': $!";  ## no critic
		if ($fh) {
			print {$fh} "\n" or print {*STDERR} "Cannot print to file '$option{config}': $!\n";
			close $fh or print {*STDERR} "Cannot close file '$option{config}': $!\n";
		}
	}

	if (@ARGV) {
		for my $img (grep {/=/} @ARGV) {
			my ($month, $src) = split /=/, $img, 2;
			$option{image}{$month} = $src;
		}
	}

	if ( $option{'show-template'} ) {
		show_template();
	}

	my %config = -f $option{config} ? get_config() : %option;
	$cal = SVG::Calendar->new(%config);

	if ( $option{date}{month} ) {
		$cal->output_month( $option{date}{month}, $option{out} || q/-/ );
	}
	else {
		die 'No page output file name base specified!' if !$option{out};  ## no critic

		if ( $option{date}{year} ) {
			$cal->output_year( $option{date}{year}, $option{out} );
		}
		else {
			$cal->output_year( $option{date}{start}, $option{date}{end}, $option{out} );
		}
	}

	return;
}

sub show_template {
	my $found = 0;
	while ( my $line = <SVG::Calendar::DATA> ) {
		if ( $found ) {
			print $line;
		}
		elsif ( $line =~ /^__calendar.svg__$/xms ) {
			$found = 1;
		}
	}
	return exit 0;
}

sub get_config {
	read_config $option{config} => my %config;

OPTION:
	for my $key ( keys %option ) {
		next OPTION if !ref $option{$key};

		for my $subkey ( keys %{ $option{$key} } ) {

			# override the config file settings
			$config{$key}{$subkey} = $option{$key}{$subkey};
		}
	}

	if ( $option{page} ) {
		$config{page} = $option{page};
	}
	if ( $option{path} ) {
		$config{path} = $option{path};
	}
	if ( $option{template} ) {
		$config{template} = $option{template};
	}
	if ( $option{image} ) {
		$config{image} = $option{image};
	}

	if ( $option{save} && -f $option{config} ) {
		write_config %config;
	}

	return %config;
}

__DATA__

=head1 NAME

svgcal.pl - Creates the pages for a calendar in SVG format

=head1 VERSION

This documentation refers to svgcal.pl version 0.2.0.

=head1 SYNOPSIS

   svgcal.pl [option] --date {see below}
   svgcal.pl [--verbose | --VERSION | --help | --man]

 OPTIONS:
  -o --out=str   The base file name when out putting multiple months
  -d --date      Parameters that control the months displaied on the
                 calendar
    start=YYYY-MM   Start month
    end=YYYY-MM     End month
    year=YYYY       Year to base the whole calendar on (Default next year)
    month=YYYY-MM   Display only this month
  -m --moon      Moon parameters
    display=1       Display the moon on individual days
    quarters=1|0    Show only whole quarters
    vpos=top|bottom Specifies which quadrent the moon should appear in
    hpos=left|right as above
    radius=n%       The radius as a percentage of day box width
    image=url       An image of the moon to use as the fill background of
                    the moon
  -c --ical      ICal parameters
  -p --page      Specify a page type or a height or width of the page
    page=A0..A6     The page type
    height=size     The page height (with optional units)
    width=size      The page width (with optional units)
  -i --image     Specifies the images to be displayed on the calendar
    src=file        This image will be used for any image with out a specific
                    month image.
    YYYY-MM=file    Use this image for the specified month
  -h --height    The height on the page that the calendar shoud take up.
                 Either a fraction or a percent (Default 50%)
  -C --config    Location of the configuration file (Default ~/.svgcal)
  -P --path=template path
                 Specify a colon seperated path to find templates in
  -t --template=template_dir
                 The name of a template directory to use instead of the
                 default templates (expects to find a template there called
                 calendar.svg)
  -s --save      Save any other command line options to your config file
     --show-template
                 Displays the default template used by SVG::Calendar,
                 this is useful if you want to change the default template

  -v --verbose   Show more detailed option
     --version   Prints the version information
     --help      Prints this help information
     --man       Prints the full documentation for svgcal.pl

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head1 DIAGNOSTICS

=head1 CONFIGURATION AND ENVIRONMENT

=head1 DEPENDENCIES

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems to Ivan Wills (ivan.wills@gmail.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gmail.com)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2006 Ivan Wills (101 Miles St Bald Hills QLD Australia 4036).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut

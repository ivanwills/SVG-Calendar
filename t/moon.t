#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 31 * 4;
use SVG::Calendar;

my @packages = qw/Astro::Coord::ECI::Moon Astro::MoonPhase DateTime::Util::Astro::Moon/;
my %found;

for my $package (@packages) {
    my $file = $package;
    $file =~ s{::}{/}gxms;
    $file .= '.pm';

    eval{ require $file };
    next if $@;

    $found{$package} = 1;
}

my $cal = SVG::Calendar->new();

my %phases = (
    # date       => phase
    '2008-10-01' => 0.255769207861541,
    '2008-10-02' => 0.457287605672748,
    '2008-10-03' => 0.654899245236679,
    '2008-10-04' => 0.849057814076298,
    '2008-10-05' => 1.04051286533444,
    '2008-10-06' => 1.22240026416465,
    '2008-10-07' => 1.41174807224763,
    '2008-10-08' => 1.6020467975377,
    '2008-10-09' => 1.79482233755409,
    '2008-10-10' => 1.9916064109407,
    '2008-10-11' => 2.19382073688362,
    '2008-10-12' => 2.40263185125081,
    '2008-10-13' => 2.61877604938007,
    '2008-10-14' => 2.84237642823711,
    '2008-10-15' => 3.0728052964515,
    '2008-10-16' => 3.3086630861858,
    '2008-10-17' => 3.54792585016853,
    '2008-10-18' => 3.78825437198716,
    '2008-10-19' => 4.0273858744403,
    '2008-10-20' => 4.26348689457233,
    '2008-10-21' => 4.49536116108485,
    '2008-10-22' => 4.72247109231735,
    '2008-10-23' => 4.94480695101413,
    '2008-10-24' => 5.16268268314345,
    '2008-10-25' => 5.37653663016577,
    '2008-10-26' => 5.58678413071163,
    '2008-10-27' => 5.79373550935741,
    '2008-10-28' => 5.99757442309741,
    '2008-10-29' => 6.19838652038459,
    '2008-10-30' => 0.113040995752607,
    '2008-10-31' => 0.30802003018672,
);

for my $package (@packages) {
    SKIP:
    {
        skip "Missing optional package $package", scalar keys %phases if !$found{$package};

        $cal->{moon_phase} = $package;

        for my $date (keys %phases) {
            my $phase = $cal->get_moon_phase($date);
            ok( abs( $phases{$date} - $phase ) < 0.005, "$phase is approximatly $phases{$date} of $date" );
        }

    }
}

SKIP:
{
    skip "Missing optional all packages", scalar keys %phases if !%found;

    # let SVG::Calendar choose the best phase checking package
    delete $cal->{moon_phase};

    for my $date (keys %phases) {
        my $phase = $cal->get_moon_phase($date);
        ok( $cal->moon( phase => $phase, id => $date, x => 1, y => 1, r => 1), "SVG can be generated for this date ($date)" );
    }
}

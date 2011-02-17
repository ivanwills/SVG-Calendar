#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'SVG::Calendar' );
}

diag( "Testing SVG::Calendar $SVG::Calendar::VERSION, Perl $], $^X" );


use strict;
use warnings;
use Test::More;

eval { require Test::Spelling; Test::Spelling->import() };

plan skip_all => "Test::Spelling required for testing POD coverage" if $@;

add_stopwords(qw/SVG svg QLD svgcal STDOUT Param Arg pl YYYY Initialises/);
all_pod_files_spelling_ok();

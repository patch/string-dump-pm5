use strict;
use warnings;
use Test::More tests => 1;

BEGIN { use_ok 'String::Dumper', qw( dump_string ) }

diag "Testing String::Dumper $String::Dumper::VERSION, Perl $], $^X";

use strict;
use warnings;
use Test::More tests => 1;

BEGIN { use_ok 'String::Dump', qw( dump_string ) }

diag "Testing String::Dump $String::Dump::VERSION, Perl $], $^X";

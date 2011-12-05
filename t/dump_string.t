#!perl
use strict;
use warnings;
use Test::More tests => 1;
use String::Dumper qw( dump_string );

is dump_string(), undef, '';

use strict;
use warnings;
use Test::More tests => 1;
use String::Dump qw( dump_string );

use utf8;

is dump_string('Ĝis! ☺'), '11C 69 73 21 20 263A', 'call exported dump_string';

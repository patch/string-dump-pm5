use strict;
use warnings;
use Test::More tests => 11;
use String::Dumper qw( dump_string );

use utf8;

note 'Testing strings of characters.';

is dump_string('Ĝis! ☺'),        '11C 69 73 21 20 263A',    'default mode';
is dump_string(hex => 'Ĝis! ☺'), '11C 69 73 21 20 263A',    'hex mode';
is dump_string(dec => 'Ĝis! ☺'), '284 105 115 33 32 9786',  'dec mode';
is dump_string(oct => 'Ĝis! ☺'), '434 151 163 41 40 23072', 'oct mode';

is(
    dump_string(bin => 'Ĝis! ☺'),
    '100011100 1101001 1110011 100001 100000 10011000111010',
    'bin mode'
);

is(
    dump_string(names => 'Ĝis! ☺'),
    'LATIN CAPITAL LETTER G WITH CIRCUMFLEX, LATIN SMALL LETTER I,'
    . ' LATIN SMALL LETTER S, EXCLAMATION MARK, SPACE, WHITE SMILING FACE',
    'names mode'
);

no utf8;

note 'Testing series of bytes.';

is dump_string('Ĝis! ☺'),        'C4 9C 69 73 21 20 E2 98 BA',        'default mode';
is dump_string(hex => 'Ĝis! ☺'), 'C4 9C 69 73 21 20 E2 98 BA',        'hex mode';
is dump_string(dec => 'Ĝis! ☺'), '196 156 105 115 33 32 226 152 186', 'dec mode';
is dump_string(oct => 'Ĝis! ☺'), '304 234 151 163 41 40 342 230 272', 'oct mode';

is(
    dump_string(bin => 'Ĝis! ☺'),
    '11000100 10011100 1101001 1110011 100001 100000 11100010 10011000 10111010',
    'bin mode'
);

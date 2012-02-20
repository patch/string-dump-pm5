use strict;
use warnings;
use Test::More tests => 21;
use Test::Warn;
use String::Dump qw( :all );

use utf8;

note 'Testing strings of characters';

is dump_hex('Ĝis! ☺'), '11C 69 73 21 20 263A',    'dump_hex';
is dump_dec('Ĝis! ☺'), '284 105 115 33 32 9786',  'dump_dec';
is dump_oct('Ĝis! ☺'), '434 151 163 41 40 23072', 'dump_oct';

is(
    dump_bin('Ĝis! ☺'),
    '100011100 1101001 1110011 100001 100000 10011000111010',
    'dump_bin'
);

is(
    dump_names('Ĝis! ☺'),
    'LATIN CAPITAL LETTER G WITH CIRCUMFLEX, LATIN SMALL LETTER I,'
    . ' LATIN SMALL LETTER S, EXCLAMATION MARK, SPACE, WHITE SMILING FACE',
    'dump_names'
);

SKIP: {
    # TODO: use codepoints that will not be supported anytime soon
    skip 'Unicode 6.0 supported in Perl 5.14', 2 if $] >= 5.014;

    is dump_names('💀🎅'), '?, ?', 'unknown Unicode names';
    is(
        dump_names('I❤🐙'),
        'LATIN CAPITAL LETTER I, HEAVY BLACK HEART, ?',
        'unknown Unicode names'
    );
}

for my $mode (qw< hex dec oct bin names >) {
    warning_is { eval "dump_$mode()" } {
        carped => "dump_$mode() expects one argument"
    }, "dump_$mode: too few args";

    warning_is { eval "dump_$mode('foo', 'bar')" } {
        carped => "dump_$mode() expects one argument"
    }, "dump_$mode: too many args";
}

no utf8;

note 'Testing series of bytes';

is dump_hex('Ĝis! ☺'), 'C4 9C 69 73 21 20 E2 98 BA',        'hex';
is dump_dec('Ĝis! ☺'), '196 156 105 115 33 32 226 152 186', 'dec';
is dump_oct('Ĝis! ☺'), '304 234 151 163 41 40 342 230 272', 'oct';

is(
    dump_bin('Ĝis! ☺'),
    '11000100 10011100 1101001 1110011 100001 100000 11100010 10011000 10111010',
    'bin mode'
);

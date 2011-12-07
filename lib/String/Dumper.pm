package String::Dumper;

use 5.006;
use strict;
use warnings;
use charnames qw( :full );
use parent 'Exporter';

our $VERSION = '0.01';
our @EXPORT  = qw( dump_string );

use constant DEFAULT_MODE => 'hex';

my %delim_for = (
    hex  => ' ',
    dec  => ' ',
    oct  => ' ',
    bin  => ' ',
    name => ', ',
);

my %sub_for = (
    hex  => sub { map { sprintf '%X',      ord } @_ },
    dec  => sub { map {                    ord } @_ },
    oct  => sub { map { sprintf '%o',      ord } @_ },
    bin  => sub { map { sprintf '%b',      ord } @_ },
    name => sub { map { charnames::viacode ord } @_ },
);

sub dump_string {
    my ($mode, $string);

    if (@_ == 1) {
        ($mode, $string) = (DEFAULT_MODE, @_);
    }
    else {
        ($mode, $string) = @_;
    }

    return unless defined $string;

    return join $delim_for{$mode}, $sub_for{$mode}->(split '', $string);
}

1;

__END__

=encoding utf8

=head1 NAME

String::Dumper - Dump strings of characters or bytes for printing and debugging

=head1 VERSION

This document describes String::Dumper version 0.01.

=head1 SYNOPSIS

    use String::Dumper;

    my $string = shift;

    say 'hex: ', dump_string($string);  # hex mode by default
    say 'oct: ', dump_string(oct => $string);  # octal mode

=head1 DESCRIPTION

This module provides the function C<dump_string> and exports it by default.
When debugging or reviewing non-ASCII data, C<dump_string> is your friend.
It's a simple utility to view the characters or bytes of your string in
several different formats, such as hex, octal, decimal, Unicode names, and
more.

An OO interface is forthcoming with additional options and the ability to
reuse them among multiple calls.  Some benefits will be the ability to set
the delimiter between characters and to force a string to be treated as a
string of characters or a series of bytes.  Don't worry, the C<dump_string>
function will remain simple!

=head2 Modes

=over

=item hex

Hexadecimal (base 16) mode.  This is the default when only a string is passed
without the mode.

    use utf8;
    # string of 6 characters
    say dump_string('Ĝis! ☺');  # 11C 69 73 21 20 263A
    say dump_string(hex => 'Ĝis! ☺');  # same thing

    no utf8;
    # series of 9 bytes
    say dump_string('Ĝis! ☺');  # C4 9C 69 73 21 20 E2 98 BA

For a lowercase hex dump, simply pass the response to C<lc>.

    say lc dump_string('Ĝis! ☺');  # 11c 69 73 21 20 263a

=item dec

Decimal (base 10) mode.

    use utf8;
    say dump_string(dec => 'Ĝis! ☺');  # 284 105 115 33 32 9786

    no utf8;
    say dump_string(dec => 'Ĝis! ☺');  # 196 156 105 115 33 32 226 152 186

=item oct

Octal (base 8) mode.

    use utf8;
    say dump_string(oct => 'Ĝis! ☺');  # 434 151 163 41 40 23072

    no utf8;
    say dump_string(oct => 'Ĝis! ☺');  # 304 234 151 163 41 40 342 230 272

=item bin

Binary (base 2) mode.

    use utf8;
    say dump_string(bin => 'Ĝis! ☺');
    # 100011100 1101001 1110011 100001 100000 10011000111010

    no utf8;
    say dump_string(bin => 'Ĝis! ☺');
    # 11000100 10011100 1101001 1110011 100001 100000 11100010 10011000 10111010

=item name

Named Unicode character mode.  Unlike the various numeral modes above, this
mode uses ', ' for the delimiter.

    use utf8;
    say dump_string(name => 'Ĝis! ☺');
    # LATIN CAPITAL LETTER G WITH CIRCUMFLEX, LATIN SMALL LETTER I,
    # LATIN SMALL LETTER S, EXCLAMATION MARK, SPACE, WHITE SMILING FACE

This mode make no sense for a series of bytes, but it still works if that's
what you really want!

    no utf8;
    say dump_string(name => 'Ĝis! ☺');
    # LATIN CAPITAL LETTER A WITH DIAERESIS, STRING TERMINATOR,
    # LATIN SMALL LETTER I, LATIN SMALL LETTER S, EXCLAMATION MARK,
    # SPACE, LATIN SMALL LETTER A WITH CIRCUMFLEX, START OF STRING,
    # MASCULINE ORDINAL INDICATOR

The output in the examples above has been manually split into multiple lines
for the layout of this document.

=back

=head2 Tips

=over

=item Literal strings

When dumping literal strings in your code, as in the examples above, use the
L<utf8> pragma when strings of characters are desired and don't use it or
disable it when series of bytes are desired.

    say dump_string('Ĝis! ☺');  # bytes: 'C4 9C 69 73 21 20 E2 98 BA'

    use utf8;
    say dump_string('Ĝis! ☺');  # chars: '11C 69 73 21 20 263A'

    no utf8;
    say dump_string('Ĝis! ☺');  # bytes: 'C4 9C 69 73 21 20 E2 98 BA'

=item Command-line input

...

=item Filesystem input

...

=item Web request parameters

...

=item Other sources of input

...

=back

=head1 SEE ALSO

=over

=item * L<Data::HexDump> - ...

=item * L<Data::Hexdumper> - ...

=back

=head1 AUTHOR

Nick Patch <patch@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2011 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

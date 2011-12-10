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
    hex   => ' ',
    dec   => ' ',
    oct   => ' ',
    bin   => ' ',
    names => ', ',
);

my %sub_for = (
    hex   => sub { map { sprintf '%X',      ord } @_ },
    dec   => sub { map {                    ord } @_ },
    oct   => sub { map { sprintf '%o',      ord } @_ },
    bin   => sub { map { sprintf '%b',      ord } @_ },
    names => sub { map { charnames::viacode ord } @_ },
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

    say 'hex: ', dump_string($string);  # hex mode by default
    say 'oct: ', dump_string(oct => $string);  # octal mode

=head1 NOTICE

This is an early release of String::Dumper.  Feedback is appreciated!  To give
suggestions or report an issue, contact L<mailto:patch@cpan.org> or open an
issue at L<https://github.com/patch/string-dumper-pm5/issues>.  Pull requests
are welcome at L<https://github.com/patch/string-dumper-pm5>.

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
function will remain simple.

=head2 dump_string($mode, $string)

The mode is optional and defaults to C<hex>.  Other valid modes are C<dec>,
C<oct>, C<bin>, and C<names>, and are described below.  The string may either
be a series of Unicode characters or binary bytes.

=head2 Modes

=head3 hex

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

=head3 dec

Decimal (base 10) mode.

    use utf8;
    say dump_string(dec => 'Ĝis! ☺');  # 284 105 115 33 32 9786

    no utf8;
    say dump_string(dec => 'Ĝis! ☺');  # 196 156 105 115 33 32 226 152 186

=head3 oct

Octal (base 8) mode.

    use utf8;
    say dump_string(oct => 'Ĝis! ☺');  # 434 151 163 41 40 23072

    no utf8;
    say dump_string(oct => 'Ĝis! ☺');  # 304 234 151 163 41 40 342 230 272

=head3 bin

Binary (base 2) mode.

    use utf8;
    say dump_string(bin => 'Ĝis! ☺');
    # 100011100 1101001 1110011 100001 100000 10011000111010

    no utf8;
    say dump_string(bin => 'Ĝis! ☺');
    # 11000100 10011100 1101001 1110011 100001 100000 11100010 10011000 10111010

=head3 names

Named Unicode character mode.  Unlike the various numeral modes above, this
mode uses ', ' for the delimiter.

    use utf8;
    say dump_string(names => 'Ĝis! ☺');
    # LATIN CAPITAL LETTER G WITH CIRCUMFLEX, LATIN SMALL LETTER I,
    # LATIN SMALL LETTER S, EXCLAMATION MARK, SPACE, WHITE SMILING FACE

This mode makes no sense for a series of bytes, but it still works if that's
what you really want!

    no utf8;
    say dump_string(names => 'Ĝis! ☺');
    # LATIN CAPITAL LETTER A WITH DIAERESIS, STRING TERMINATOR,
    # LATIN SMALL LETTER I, LATIN SMALL LETTER S, EXCLAMATION MARK,
    # SPACE, LATIN SMALL LETTER A WITH CIRCUMFLEX, START OF STRING,
    # MASCULINE ORDINAL INDICATOR

The output in the examples above has been manually split into multiple lines
for the layout of this document.

=head2 Tips

=head3 Literal strings

When dumping literal strings in your code, as in the examples above, use the
L<utf8> pragma when strings of Unicode characters are desired and don't use it
or disable it when series of bytes are desired.  The pragma may also be
lexically enabled or disabled.

    use utf8;

    {
        no utf8;
        say dump_string('Ĝis! ☺');  # C4 9C 69 73 21 20 E2 98 BA
    }

    say dump_string('Ĝis! ☺');  # 11C 69 73 21 20 263A

=head3 Command-line input and filehandles

The simplest way to ensure that you're working with strings of characters from
all of your basic sources of input is to use the L<utf8::all> pragma.  This
extends the utf8 pragma to automatically convert command-line arguments
provided by C<@ARGV>, user-defined filehandles, as well as C<STDIN>, among
others.

=head3 Other sources of input

To handle strings provided by other sources of input, such as from network
protocols or a web server request, pass the value to
L<Encode::decode_utf8|Encode>, which will return the desired string.

    use Encode;

    say dump_string( decode_utf8($string) );

To convert a variable in-place, pass it to utf8::decode instead.

    utf8::decode($string);

    say dump_string($string);

=head1 SEE ALSO

=over

=item * L<Data::HexDump> - Simple hex dumping using the default output of the
Unix C<hexdump> utility

=item * L<Data::Hexdumper> - Advanced formatting of binary data, similar to
C<hexdump>

=back

=head1 AUTHOR

Nick Patch <patch@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2011 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

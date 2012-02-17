package String::Dump;

use 5.006;
use strict;
use warnings;
use parent 'Exporter';
use charnames qw( :full );
use Carp;

our $VERSION = '0.05';
our @EXPORT  = qw( dump_hex dump_dec dump_oct dump_bin dump_names );

use constant UNKNOWN_NAME => '?';

my %delim_for = (
    hex   => ' ',
    dec   => ' ',
    oct   => ' ',
    bin   => ' ',
    names => ', ',
);

my %sub_for = (
    hex   => sub { map { sprintf '%X', ord } @_ },
    dec   => sub { map {               ord } @_ },
    oct   => sub { map { sprintf '%o', ord } @_ },
    bin   => sub { map { sprintf '%b', ord } @_ },
    names => sub { map { charnames::viacode(ord) || UNKNOWN_NAME } @_ },
);

sub dump_hex   { _dumpstr('hex',   @_) }
sub dump_dec   { _dumpstr('dec',   @_) }
sub dump_oct   { _dumpstr('oct',   @_) }
sub dump_bin   { _dumpstr('bin',   @_) }
sub dump_names { _dumpstr('names', @_) }

sub _dumpstr {
    my ($mode, $string) = @_;

    if (@_ != 2) {
        carp "dump_$mode() expects one argument";
        return;
    }

    return unless defined $string;

    return join $delim_for{$mode}, $sub_for{$mode}->(split '', $string);
}

1;

__END__

=encoding utf8

=head1 NAME

String::Dump - Dump strings of characters or bytes for printing and debugging

=head1 VERSION

This document describes String::Dump version 0.05.

=head1 SYNOPSIS

    use String::Dump;

    say 'hex: ', dump_hex($string);  # hex mode
    say 'oct: ', dump_oct($string);  # octal mode

=head1 DESCRIPTION

When debugging or reviewing strings containing non-ASCII or non-printing
characters, String::Dump is your friend.  It provides simple functions to
return a dump of the characters or bytes of your string in several different
formats, such as hex, octal, decimal, Unicode names, and more.

An OO interface is forthcoming with additional options and the ability to
reuse them among multiple calls.  Some benefits will include the ability to
set the delimiter between characters, set padding for the characters, and
force a string to be treated as a string of characters or a series of bytes.
Don't worry, the standard functions will remain simple.

Check out L<String::Dump::Debugging> for tips on debugging Unicode and encoded
strings with this module.  Also check out the bundled command-line tool
L<dumpstr>.

=head1 FUNCTIONS

The following functions are all exported by default.  This is convenient for
debugging and one-liners, but explicitly exporting individual functions is
recommended in other cases.  It's up to you!

These functions all accept a single argument: the string to dump, which may
either be a Perl internal string or an encoded series of bytes.

=head2 dump_hex($string)

Hexadecimal (base 16) mode.

    use utf8;
    # string of 6 characters
    say dump_hex('Ĝis! ☺');  # 11C 69 73 21 20 263A

    no utf8;
    # series of 9 bytes
    say dump_hex('Ĝis! ☺');  # C4 9C 69 73 21 20 E2 98 BA

For a lowercase hex dump, simply pass the response to C<lc>.

    say lc dump_hex('Ĝis! ☺');  # 11c 69 73 21 20 263a

=head2 dump_dec($string)

Decimal (base 10) mode.

    use utf8;
    say dump_dec('Ĝis! ☺');  # 284 105 115 33 32 9786

    no utf8;
    say dump_dec('Ĝis! ☺');  # 196 156 105 115 33 32 226 152 186

=head2 dump_oct($string)

Octal (base 8) mode.

    use utf8;
    say dump_oct('Ĝis! ☺');  # 434 151 163 41 40 23072

    no utf8;
    say dump_oct('Ĝis! ☺');  # 304 234 151 163 41 40 342 230 272

=head2 dump_bin($string)

Binary (base 2) mode.

    use utf8;
    say dump_bin('Ĝis! ☺');
    # 100011100 1101001 1110011 100001 100000 10011000111010

    no utf8;
    say dump_bin('Ĝis! ☺');
    # 11000100 10011100 1101001 1110011 100001 100000 11100010 10011000 10111010

=head2 dump_names($string)

Named Unicode character mode.  Unlike the various numeral modes above, this
mode uses ', ' for the delimiter.

    use utf8;
    say dump_names('Ĝis! ☺');
    # LATIN CAPITAL LETTER G WITH CIRCUMFLEX, LATIN SMALL LETTER I,
    # LATIN SMALL LETTER S, EXCLAMATION MARK, SPACE, WHITE SMILING FACE

This mode makes no sense for a series of bytes, but it still works if that's
what you really want!

    no utf8;
    say dump_names('Ĝis! ☺');
    # LATIN CAPITAL LETTER A WITH DIAERESIS, STRING TERMINATOR,
    # LATIN SMALL LETTER I, LATIN SMALL LETTER S, EXCLAMATION MARK,
    # SPACE, LATIN SMALL LETTER A WITH CIRCUMFLEX, START OF STRING,
    # MASCULINE ORDINAL INDICATOR

The output in the examples above has been manually split into multiple lines
for the layout of this document.

=head1 CONTRIBUTIONS

This is an early release of String::Dump.  Feedback is appreciated!  To give
suggestions or report an issue, contact L<mailto:patch@cpan.org> or open an
issue at L<https://github.com/patch/string-dump-pm5/issues>.  Pull requests
are welcome at L<https://github.com/patch/string-dump-pm5>.

=head1 SEE ALSO

=over

=item * L<dumpstr> - Dump strings of characters on the command line

=item * L<String::Dump::Debugging> - String debugging tips with String::Dump

=item * L<Template::Plugin::StringDump> - String::Dump plugin for TT

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

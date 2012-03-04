package String::Dump;

use 5.006;
use strict;
use warnings;
use parent 'Exporter';
use charnames qw( :full );
use Carp;

our $VERSION     = '0.06';
our @EXPORT      = qw( dump_hex dump_dec dump_oct dump_bin dump_names );
our %EXPORT_TAGS = ( all => \@EXPORT );

# TODO: remove this after a while
sub import {
    my ($class, @symbols) = @_;
    carp 'Implicitly importing String::Dump functions is deprecated and will '
       . 'be disabled in an upcoming release'
        unless @symbols;
    local $Exporter::ExportLevel = 1;
    $class->SUPER::import(@symbols);
}

sub dump_hex {
    my ($str) = @_;
    carp('dump_hex() expects one argument') && return if @_ != 1;
    return unless defined $str;
    return sprintf '%*vX', ' ', $str;
}

sub dump_dec {
    my ($str) = @_;
    carp('dump_dec() expects one argument') && return if @_ != 1;
    return unless defined $str;
    return sprintf '%*vd', ' ', $str;
}

sub dump_oct {
    my ($str) = @_;
    carp('dump_oct() expects one argument') && return if @_ != 1;
    return unless defined $str;
    return sprintf '%*vo', ' ', $str;
}

sub dump_bin {
    my ($str) = @_;
    carp('dump_bin() expects one argument') && return if @_ != 1;
    return unless defined $str;
    return sprintf '%*vb', ' ', $str;
}

sub dump_names {
    my ($str) = @_;
    carp('dump_names() expects one argument') && return if @_ != 1;
    return unless defined $str;
    return join ', ',
           map { charnames::viacode(ord) || '?' }
           split '', $str;
}

1;

__END__

=encoding utf8

=head1 NAME

String::Dump - Dump strings of characters or bytes for printing and debugging

=head1 VERSION

This document describes String::Dump version 0.06.

=head1 SYNOPSIS

    use String::Dump qw( dump_hex dump_oct );

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
Don’t worry, the standard functions will remain simple.

Check out L<String::Dump::Debugging> for tips on debugging Unicode and encoded
strings with this module.  Also check out the bundled command-line tool
L<dumpstr>.

=head1 FUNCTIONS

These functions all accept a single argument: the string to dump, which may
either be a Perl internal string or an encoded series of bytes.  Each has to
be explicitly exported or they can all be exported with the C<:all> tag.

    use String::Dump qw( :all );

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
mode uses ‘, ’ (comma, space) for the delimiter.

    use utf8;
    say dump_names('Ĝis! ☺');
    # LATIN CAPITAL LETTER G WITH CIRCUMFLEX, LATIN SMALL LETTER I,
    # LATIN SMALL LETTER S, EXCLAMATION MARK, SPACE, WHITE SMILING FACE

This mode makes no sense for a series of bytes, but it still works if that’s
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

© 2011–2012 Nick Patch

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

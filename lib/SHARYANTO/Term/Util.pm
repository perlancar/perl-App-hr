package SHARYANTO::Term::Util;

use 5.010001;
use strict;
use warnings;

# VERSION
# DATE

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       hr
               );

my $o;

sub hr {
    my $char = shift;
    $char  = "=" if !defined($char) || !length($char);
    my $w  = $o->term_width;
    my $n  = int($w / length($char))+1;
    my $hr = substr(($char x $n), 0, $w);
    return $hr if defined(wantarray);
    if ($^O =~ /MSWin/) {
        substr($hr, -1, 1) = '';
    }
    say $hr;
}

# a dummy class just to use TermAttrs
{
    package SHARYANTO::Term::Util::object;
    use Moo;
    with 'SHARYANTO::Role::TermAttrs';
}
$o = SHARYANTO::Term::Util::object->new;

1;
# ABSTRACT: Terminal utilities

=head1 FUNCTIONS

=head2 hr([CHAR]) => optional STR

Print (under void context) or return (under scalar/array context) a horizontal
bar with the width of the terminal.

C<CHAR> is optional, can be multicharacter, but cannot be empty string. The
defautl is C<=>.

Under Windows, when printing, will shave one character at the end because the
terminal cursor will move a line down when printing at the last column.


=head1 SEE ALSO

L<SHARYANTO>

=cut

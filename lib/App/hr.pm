package App::hr;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       hr
               );

my $o;

sub hr {
    my ($pattern, $color) = @_;
    $pattern  = "=" if !defined($pattern) || !length($pattern);
    my $w  = $o->term_width;
    my $n  = int($w / length($pattern))+1;
    my $hr = substr(($pattern x $n), 0, $w);
    return $hr if defined(wantarray);
    if ($^O =~ /MSWin/) {
        substr($hr, -1, 1) = '';
    }
    if ($color) {
        require Term::ANSIColor;
        $hr = Term::ANSIColor::colored([$color], $hr);
    }
    say $hr;
}

# a dummy class just to use TermAttrs
{
    package # hide from PAUSE
        App::hr::Class;
    use Moo;
    with 'Term::App::Role::Attrs';
}
$o = App::hr::Class->new;

1;
# ABSTRACT: Print horizontal bar on the terminal

=head1 SYNOPSIS

 use App::hr qw(hr);
 hr;

Sample output:

 =============================================================================

 hr('x----');

Sample output:

 x----x----x----x----x----x----x----x----x----x----x----x----x----x----x----x-

You can also use the provided CLI L<hr>.


=head1 FUNCTIONS

=head2 hr([PATTERN]) => optional STR

Print (under void context) or return (under scalar/array context) a horizontal
ruler with the width of the terminal.

C<PATTERN> is optional, can be multicharacter, but cannot be empty string. The
defautl is C<=>.

Under Windows, when printing, will shave one character at the end because the
terminal cursor will move a line down when printing at the last column.

Terminal width is currently determined using L<Term::App::Role::Attrs>, which
will either use environment variable C<COLUMNS> or detecting using
L<Term::Size>, or if all those fail, use a hard-coded default of 80.

=cut

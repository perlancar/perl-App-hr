package App::hr;

# DATE
# VERSION

use feature 'say';
use strict 'subs', 'vars';
use warnings;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       hr
               );

our %SPEC;

# IFBUILT
## INSERT_BLOCK_FROM_MODULE: Code::Embeddable pick
# END IFBUILT
# IFUNBUILT
use Code::Embeddable; *pick = \&Code::Embeddable::pick;
# END IFUNBUILT


my $term_width;
if (defined $ENV{COLUMNS}) {
    $term_width = $ENV{COLUMNS};
} elsif (eval { require Term::Size; 1 }) {
    ($term_width, undef) = Term::Size::chars();
} else {
    $term_width = 80;
}

sub hr {
    my ($pattern, $color) = @_;
    $pattern = "=" if !defined($pattern) || !length($pattern);
    my $n  = int($term_width / length($pattern))+1;
    my $hr = substr(($pattern x $n), 0, $term_width);
    if ($^O =~ /MSWin/) {
        substr($hr, -1, 1) = '';
    }
    if ($color) {
        require Term::ANSIColor;
        $hr = Term::ANSIColor::colored([$color], $hr);
    }
    return $hr if defined(wantarray);
    say $hr;
}

$SPEC{hr_app} = {
    v => 1.1,
    summary => 'Print horizontal bar on the terminal',
    description => <<'_',

`hr` can be useful as a marker/separator, especially if you use other commands
that might produce a lot of output, and you need to scroll back lots of pages to
see previous output. Example:

    % hr; command-that-produces-lots-of-output
    ============================================================================
    Command output
    ...
    ...
    ...

    % hr -r; some-command; hr -r; another-command

Usage:

    % hr
    ============================================================================

    % hr -c red  ;# will output the same bar, but in red

    % hr --random-color  ;# will output the same bar, but in random color

    % hr x----
    x----x----x----x----x----x----x----x----x----x----x----x----x----x----x----x

    % hr -- -x-  ;# specify a pattern that starts with a dash
    % hr -p -x-  ;# ditto

    % hr --random-pattern
    vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

    % hr --random-pattern
    *---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---*---

    % hr -r  ;# shortcut for --random-pattern --random-color

    % hr --help

If you use Perl, you can also use the `hr` function in `App::hr` module.

_
    args_rels => {
        'choose_one&' => [
            [qw/color random_color/],
            [qw/pattern random_pattern/],
        ],
    },
    args => {
        color => {
            summary => 'Specify a color (see Term::ANSIColor)',
            schema => 'str*',
            cmdline_aliases => {c=>{}},
        },
        random_color => {
            schema => ['bool', is=>1],
        },
        height => {
            summary => 'Specify height (number of rows)',
            schema => ['int*', min=>1],
            default => 1,
            cmdline_aliases => {H=>{}},
        },
        space_before => {
            summary => 'Number of empty rows before drawing the bar',
            schema => ['int*', min=>0],
            default => 0,
            cmdline_aliases => {b=>{}},
        },
        space_after => {
            summary => 'Number of empty rows after drawing the bar',
            schema => ['int*', min=>0],
            default => 0,
            cmdline_aliases => {a=>{}},
        },
        pattern => {
            summary => 'Specify a pattern',
            schema => 'str*',
            pos => 0,
            cmdline_aliases => {p=>{}},
        },
        random_pattern => {
            schema => ['bool', is=>1],
            cmdline_aliases => {
                r => {
                    summary => 'Alias for --random-pattern --random-color',
                    is_flag => 1,
                    code => sub {
                        $_[0]{random_color} = 1;
                        $_[0]{random_pattern} = 1;
                    },
                },
            },
        },
    },
};
sub hr_app {
    my %args = @_;

    if ($args{random_color}) {
        $args{color} = pick(
            'red',
            'bright_red',
            'green',
            'bright_green',
            'blue',
            'bright_blue',
            'cyan',
            'bright_cyan',
            'magenta',
            'bright_magenta',
            'yellow',
            'bright_yellow',
            'white',
            'bright_white',
        );
    }

    if ($args{random_pattern}) {
        $args{pattern} = pick(
            '.',
            '-',
            '=',
            'x',
            'x-',
            'x---',
            'x-----',
            '*',
            '*-',
            '*---',
            '*-----',
            '/\\',
            'v',
            'V',
        );
    }

    my $res = hr($args{pattern}, $args{color});
    $res = join(
        "",
        ("\n" x ($args{space_before} // 0)),
        ("$res\n" x ($args{height} // 1)),
        ("\n" x ($args{space_after} // 0)),
    );

    [200, "OK", $res];
}

1;
# ABSTRACT: Print horizontal bar on the terminal

=for Pod::Coverage ^(pick)$

=head1 SYNOPSIS

 use App::hr qw(hr);
 hr;

Sample output:

 =============================================================================

 hr('x----');

Sample output:

 x----x----x----x----x----x----x----x----x----x----x----x----x----x----x----x-

You can also use the provided CLI L<hr>.


=head1 prepend:FUNCTIONS

=head2 hr([ PATTERN [, COLOR ] ]) => optional STR

Print (under void context) or return (under scalar/array context) a horizontal
ruler with the width of the terminal.

Terminal width is determined using L<Term::Size>.

C<PATTERN> is optional, can be multicharacter, but cannot be empty string. The
defautl is C<=>.

Under Windows, will shave one character at the end because the terminal cursor
will move a line down when printing at the last column.


=head1 SEE ALSO

L<ruler> (L<App::ruler>)

=cut

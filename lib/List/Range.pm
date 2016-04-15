package List::Range;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Class::Accessor::Lite ro => [qw/name lower upper/];

use Carp qw/croak/;

sub new {
    my ($class, %args) = @_;
    $args{lower} = '-Inf' unless exists $args{lower};
    $args{upper} = '+Inf' unless exists $args{upper};
    $args{name}  = ''     unless exists $args{name};
    die "Invalid arguments" if keys %args != 3;
    return bless \%args => $class;
}

sub includes {
    my $self = shift;
    if (ref $_[0] eq 'CODE') {
        my $code = shift;

        my $tmp; # for preformance
        return grep {
            $tmp = $code->($_);
            $self->{lower} <= $tmp && $tmp <= $self->{upper}
        } @_;
    }
    return grep { $self->{lower} <= $_ && $_ <= $self->{upper} } @_;
}

sub excludes {
    my $self = shift;
    if (ref $_[0] eq 'CODE') {
        my $code = shift;
        my $tmp; # for preformance
        return grep {
            $tmp = $code->($_);
            $tmp < $self->{lower} || $self->{upper} < $tmp
        } @_;
    }
    return grep { $_ < $self->{lower} || $self->{upper} < $_ } @_;
}

# for duck typing
sub ranges { [shift] }

sub all {
    my $self = shift;
    croak 'lower is inlinit' if $self->lower eq '-Inf';
    croak 'upper is infinit' if $self->upper eq 'Inf';
    return ($self->lower..$self->upper);
}

1;
__END__

=encoding utf-8

=head1 NAME

List::Range - It's new $module

=head1 SYNOPSIS

    use List::Range;

    my $range = List::Range->new(name => "one-to-ten", lower => 1, upper => 10);
    $range->includes(0);   # => false
    $range->includes(1);   # => true
    $range->includes(3);   # => true
    $range->includes(10);  # => true
    $range->includes(11);  # => false

    $range->includes(0..100); # => (1..10)
    $range->includes(sub { $_ + 1 }, 0..100); # => (1..11)

    $range->excludes(0..100); # => (11..100)
    $range->excludes(sub { $_ + 1 }, 0..100); # => (0, 12..100)

=head1 DESCRIPTION

List::Range is ...

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut


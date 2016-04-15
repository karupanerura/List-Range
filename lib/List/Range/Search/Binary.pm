package List::Range::Search::Binary;
use strict;
use warnings;

use Class::Accessor::Lite ro => [qw/ranges/];

sub new {
    my ($class, $set, $opt) = @_;
    $opt ||= {};

    my $ranges = $class->_normalize($set->ranges, $opt);
    return bless {
        ranges    => $ranges,
        max_depth => $opt->{max_depth} || int(log(@$ranges) / log(2)),
    } => $class;
}

sub _normalize {
    my ($class, $ranges, $opt) = @_;
    my $sorted = $opt->{no_sort} ? $ranges : [
        sort { $a->lower <=> $b->lower || $a->upper <=> $b->upper } @$ranges
    ];
    return $opt->{no_verify} ? $sorted : $class->_verify($sorted);
}

sub _verify {
    my ($class, $ranges) = @_;
    for my $i (0..$#{$ranges}-1) {
        my $before = $ranges->[$i];
        my $after  = $ranges->[$i+1];
        die "Binary search does not support to search in the crossed ranges"
            if $after->lower <= $before->upper;
    }
    return $ranges;
}

sub includes {
    my ($self, $value) = @_;

    my @ranges = @{ $self->{ranges} };
    for (0..$self->{max_depth}) {
        my $point = $#ranges / 2;
        my $range = $ranges[$point];
        if ($value < $range->lower) {
            splice @ranges, $point;
        }
        elsif ($value > $range->upper) {
            splice @ranges, 0, $point - 1;
        }
        else {
            # includes
            return $range;
        }
    }

    # not found
    return undef; ## no critic
}

sub excludes { !shift->includes(@_) }

1;
__END__

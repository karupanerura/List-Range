package List::Range::Search::Liner;
use strict;
use warnings;

use Class::Accessor::Lite ro => [qw/ranges/];

sub new {
    my ($class, $set) = @_;
    return bless {
        ranges => $set->ranges,
    } => $class;
}

sub includes {
    my ($self, $value) = @_;

    for my $range (@{ $self->{ranges} }) {
        return $range if $range->includes($value)
    }

    # not found
    return undef; ## no critic
}

sub excludes { !shift->includes(@_) }

1;
__END__

package List::Range::Set;
use strict;
use warnings;
use utf8;

use parent qw/List::Range/;

use Class::Accessor::Lite ro => [qw/ranges/];

use List::Range::Search::Liner;
use List::Range::Search::Binary;

sub new {
    my ($class, $name, $ranges) = @_;
    my ($lower, $upper) = ('-Inf', '+Inf');
    for my $range (@$ranges) {
        $lower = $range->lower if $range->lower < $lower;
        $upper = $range->upper if $range->upper > $upper;
    }
    my $self = $class->SUPER::new(name => $name, lower => $lower, upper => $upper);
    $self->{ranges} = $ranges;
    return $self;
}

1;
__END__

=pod

=encoding utf-8

=head1 NAME

List::Range::Set - Set of the range

=head1 SYNOPSIS

    use List::Range;
    use List::Range::Set;

    my $set = List::Range->new('MySet' => [
        List::Range->new(name => "A",              upper =>  0),
        List::Range->new(name => "B", lower =>  1, upper => 10),
        List::Range->new(name => "C", lower => 11, upper => 20),
        List::Range->new(name => "D", lower => 21, upper => 30),
        List::Range->new(name => "E", lower => 31, upper => 40),
        List::Range->new(name => "F", lower => 41, upper => 50),
    ]);

    $set->includes(0);  # => true
    $set->includes(1);  # => true
    $set->includes(11); # => true
    $set->includes(31); # => true
    $set->includes(50); # => true
    $set->includes(51); # => false

=head1 DESCRIPTION

TODO

=head1 SEE ALSO

L<perl>

=head1 LICENSE

Copyright (C) karupanerura.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

karupanerura E<lt>karupa@cpan.orgE<gt>

=cut

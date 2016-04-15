use strict;
use Test::More 0.98;

use List::Range;
use List::Range::Set;
use List::Range::Search::Liner;

my @ranges = (
    List::Range->new(name => "B", lower =>  1, upper => 10),
    List::Range->new(name => "A",              upper =>  0),
    List::Range->new(name => "C", lower => 11, upper => 20),
    List::Range->new(name => "D", lower => 21, upper => 30),
    List::Range->new(name => "E", lower => 31, upper => 40),
    List::Range->new(name => "F", lower => 41, upper => 50),
);

my $set = List::Range::Set->new('MySet' => \@ranges);
my $searcher = List::Range::Search::Liner->new($set);
isa_ok $searcher, 'List::Range::Search::Liner';

is $searcher->ranges, \@ranges, 'should return the same range of array reference.';

is +$searcher->includes(0)->name,  'A',    '0 is included in the A range';
is +$searcher->includes(1)->name,  'B',    '1 is included in the B range';
is +$searcher->includes(5)->name,  'B',    '5 is included in the B range';
is +$searcher->includes(10)->name, 'B',   '10 is included in the B range';
is +$searcher->includes(11)->name, 'C',   '11 is included in the C range';
is +$searcher->includes(50)->name, 'F',   '50 is included in the F range';
is +$searcher->includes(51),       undef, '51 is not included in the set';

ok !$searcher->excludes(0),  '0 is not excluded in the set';
ok !$searcher->excludes(1),  '1 is not excluded in the set';
ok !$searcher->excludes(5),  '5 is not excluded in the set';
ok !$searcher->excludes(10), '10 is not excluded in the set';
ok !$searcher->excludes(11), '11 is not excluded in the set';
ok !$searcher->excludes(50), '50 is not excluded in the set';
ok +$searcher->excludes(51), '51 is excluded in the set';

done_testing;

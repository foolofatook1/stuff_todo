#!/usr/bin/perl

use strict;
use warnings;
use Tie::File;

my @list = '';
my @newList = '';
my $element = 0;


tie @list, 'Tie::File', './words.txt',
  or die "you dead\n";

foreach $element (@list) {
    push @newList, $element . "\n" if $element;
}

print @list;
print @newList;

#!/usr/bin/perl

use strict;
use warnings;

my $file = '/home/jacob/Desktop/eh_web_dev/stuff_todo/todo.txt';

handle_input();

# handles command line flags.
sub handle_input {

    if ( defined $ARGV[0] && $ARGV[0] eq "--done" ) {
        done();
    }
    else {
        todo();
    }
}


##################*helper functions*####################

# prints what you still need to do on the list.
sub todo {

    open FILE, "<$file"
      or die "Could not open log file. $!\n";

    my $count = 1;
    
    while (<FILE>) {
        print $count++ . ") " . $_ if $_ =~ /\[ \]/;
    }
}

# prints what you have done.
sub done {

    open( FILE, "<$file" )
      or die("Could not open log file. $!\n");

    my $count = 1;

    while (<FILE>) {
        print $count++ . ") " . $_ if $_ =~ /\[x\]/;
    }
}



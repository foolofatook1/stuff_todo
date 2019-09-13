#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Tie::File;

my $file = './todo.txt';

# list of flags
# my $help = '';
my $all        = '';
my $done       = '';
my $show       = '';
my $finished   = '';
my $unfinished = '';
my $put        = '';
my $remove     = '';

# todo: add the following subroutines:
# my $undo = '';

handle_input();

sub handle_input {

    if (@ARGV) {
        GetOptions(
            'all'          => \&all,
            'done'         => \&done,
            'show=i'       => \&show,
            'finished=i'   => \&finished,
            'unfinished=i' => \&unfinished,
            'put=s'        => \&put,
            'remove=i'     => \&remove
        );
    }

    # default
    else {
        todo();
    }

}

##################*helper functions*####################

# prints what you still need to do on the list.
sub todo {

    read_file();

    my $count = 1;
    while (<FILE>) {
        print $count++ . ") " . $_ if $_ =~ /\[ \]/;
    }
    close FILE;
    exit;
}

# prints tasks that have been done.
sub done {

    read_file();

    my $count = 1;
    while (<FILE>) {
        print $count++ . ") " . $_ if $_ =~ /\[x\]/;
    }
    close FILE;
    exit;
}

# shows all tasks
sub all {

    read_file();

    my $count = 1;
    while (<FILE>) {
        print $count++ . ") " . $_ if $_ =~ /\[/;

    }
    close FILE;
    exit;
}

# shows a single task
sub show {

    my ( $flag, $list_num ) = @_;

    read_file();

    my $count = 1;
    while (<FILE>) {
        if ( $count == $list_num ) {
            print $count . ") " . $_;
            close FILE;
            exit;
        }
        $count++ if $_ =~ /\[/;
    }
    close FILE;
    print
"Sorry. The line number you entered is greater or less than the list size.\n";
}

# checks a task off the list
sub finished {
    my ( $flag, $list_num ) = @_;
    replace( "\[ \]", "\[x\]", $list_num );
}

# removes a check from a checked task on the list.
sub unfinished {
    my ( $flag, $list_num ) = @_;
    replace( "\[x\]", "\[ \]", $list_num );
}

# adds a task to the list
sub put {

    my ( $flag, $string ) = @_;

    $string = $string . " \[ \]\n";

    my @array = '';
    tie @array, 'Tie::File', $file
      or die "Could not open the log file. $!\n";

    push @array, $string;
    untie @array;
}

# removes a task from the list
sub remove {

    my ( $flag, $list_num ) = @_;

    my @array = '';
    my $count = 1;

    tie @array, 'Tie::File', $file,
      or die "Could not open log file. $!\n";

    for (@array) {
        if ( $count == $list_num ) {
            delete $array[$count];
            @array = grep { $_ ne '' } @array;
            untie @array;
            exit;
        }
        $count++ if $_ =~ /\[/;
    }
    untie @array;
    print
"Sorry. The line number you entered is greater or less than the list size.\n";
}

#######*helper functions for helper functions*#######

sub replace {

    # old string, new string, line of list to do replacement
    my ( $old, $new, $list_num ) = @_;

    my @array = '';
    my $count = 1;

    tie @array, 'Tie::File', $file,
      or die "Could not open log file. $!\n";

    for (@array) {
        if ( $count == $list_num ) {
            print "finding and replacing: " . $array[$count] . "\n";
            s/\Q$old/$new/;
            print "after: " . $array[$count] . "\n";

            # print $count . ") " . $array[$count] . "\n";
            untie @array;
            exit;
        }
        print $count++ . ") " . $_ . "\n" if $_ =~ /\[/;
    }
    untie @array;
    print
"Sorry. The line number you entered is greater or less than the list size.\n";
}

# open and read from file
sub read_file {
    open( FILE, "<$file" )
      or die "Could not open log file. $!\n";
}

#####*The following may be unnecessary*#####
# returns the amount of tasks todo.
sub how_much_todo {

    read_file();

    my $count = 0;

    while (<FILE>) {
        $count++ if $_ =~ /\[ \]/;
    }
    return $count;
}

# returns the amount of tasks you've done.
sub how_much_isdone {

    read_file();

    my $count = 0;

    while (<FILE>) {
        $count++ if $_ =~ /\[x\]/;
    }
    return $count;
}

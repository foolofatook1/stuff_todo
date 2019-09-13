#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Tie::File;

my $file = '/home/jacob/Desktop/eh_web_dev/stuff_todo/todo.txt';

# list of flags
# my $help = '';
my $all      = '';
my $done     = '';
my $show     = '';
my $finished = '';
my $unfinished = '';
# my $add = '';
# my $remove = '';
# my $undo = '';

handle_input();

sub handle_input {

    if (@ARGV) {
        GetOptions(
            'all'    => \&all,
            'done'   => \&done,
            'show=i' => \&show,
            'finished=i' => \&finished,
            'unfinished=i' => \&unfinished
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

# prints what you have done.
sub done {

    read_file();

    my $count = 1;

    while (<FILE>) {
        print $count++ . ") " . $_ if $_ =~ /\[x\]/;
    }
    close FILE;
    exit;
}

sub all {

    read_file();

    my $count = 1;

    while (<FILE>) {
        print $count++ . ") " . $_ if $_ =~ /\[/;

    }
    close FILE;
    exit;
}

# checks something off of the list.
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
        $count++;
    }
    close FILE;
    print "Sorry. The line number you entered is greater or less than the list size.\n";
}

sub finished {

    my ($flag, $list_num) = @_;

    replace("\[ \]", "\[x\]", $list_num);
}

sub unfinished {
    
    my ($flag, $list_num) = @_;

    replace("\[x\]", "\[ \]", $list_num);
}

#######*helper functions for helper functions*#######

sub replace {
   
    # old string, new string, line of list to do replacement
    my ($old, $new, $list_num) = @_;

    my @array = '';
    my $count = 0;

    tie @array, 'Tie::File', $file,
      or die "Could not open log file. $!\n";

    for (@array) {
        if ($count == $list_num-1) {
            s/\Q$old/$new/;
            print $array[$count] . "\n";
            exit;
        }
        $count++;
    }
    print "Sorry. The line number you entered is greater or less than the list size.\n";
}
    
# open and read from file
sub read_file {
    open( FILE, "<$file" )
      or die "Could not open log file. $!\n";
}

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

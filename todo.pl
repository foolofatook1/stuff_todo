#!/usr/bin/perl
use strict;
use warnings;

my $file = '/home/jacob/Desktop/eh_web_dev/stuff_todo/todo.txt'; 



handle_input();

# handles command line flags.
sub handle_input {

    if ( arg_check() && $ARGV[0] eq "--done" ) {
        done();
    }
    elsif ( defined $ARGV[0] && $ARGV[0] eq "--just-did" ) {
        if ( not defined $ARGV[1] ) {
            print "This flag requires two arguments.\n";
            exit;
        }
        else {
            just_did();
        }
    }
    # default is to give you your current todo list
    else {
        todo();
    }
}



##################*helper functions*####################

# check args.
#sub check_args {
#    my (
#    if (defined $ARGV[0]) {
#        return 1; 
#    }
#    else {
#        return 0;
#    }
#}

# check flags.

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
      or die "Could not open log file. $!\n";

    my $count = 1;

    while (<FILE>) {
        print $count++ . ") " . $_ if $_ =~ /\[x\]/;
    }
}

# checks something off of the list.
sub just_did {

    open( FILE, "<$file" )
      or die("Could not open log file. $!\n");

    my $count = 0;
    while (<FILE>) {
        if ($_ =~ /\[ \]/) {
            $count++;
        }
        if($count eq $ARGV[1]){
            print $count . ") " . $_;
        }
    }
}

#######*helper functions for helper functions*#######

# returns the amount of tasks todo.
sub how_much_todo {

    open( FILE, "<$file" )
      or die "Could not open log file. $!\n";

    my $count = 0;

    while (<FILE>) {
        $count++ if $_ =~ /\[ \]/;
    }
    return $count;
}

# returns the amount of tasks you've done.
sub how_much_isdone {

    open ( FILE, "<$file" )
      or die "Could not open log file. $!\n";

    my $count = 0;
    
    while (<FILE>) {
        $count++ if $_ =~ /\[x\]/;
    }
    return $count;
}

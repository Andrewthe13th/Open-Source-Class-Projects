#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

my $rawFile = "raw_info.txt";
my @array;
#print scalar(@ARGV);

#assigned each row to an element of the array
open(my $fh, '<', $rawFile) or die "Raw File was not Opened!!!! \n";

# Output the First two lines
my $line1 = <$fh>;
#print "\n  System Name: $line1" ;
my $line2 = <$fh>;
#print "  Serial #: $line2\n";
my $line3 = <$fh>;
my @header = split(/\s+/, $line3, 6);

#Set up the filter
# print "Insert a filter/s : ";
# my $filter = <>;
#chomp($filter);
my $bfilter = 1;

#create array elements based on each row
while(my $row = <$fh>){
	chomp($row);
    $bfilter = 1;

    if (scalar(@ARGV) ne 0){
        for(my $i = 0; $i < scalar(@ARGV); $i++)
        {
            if ($row =~ m/\Q$ARGV[$i]\E/ ){
                $bfilter = 0;
            }
        }
    }
    if ($bfilter)
    {
        $row =~ s/snap reserve/snap-reserve/g;
        push @array, $row;
    }
}
close($fh);


# Filtered out Non  percentages
my @nonCapacity = grep(/---%/, @array);
@array = grep(/\d+%/, @array);

# Sort Data
@array = sort { (split(" ", (split("%", $b))[0]))[4] <=> (split(" ", (split("%", $a))[0]))[4] }@array;

# Add non-number percentage back
for (my $i = 0; $i < scalar(@nonCapacity); $i++)
{
    push @array, $nonCapacity[$i];
}


# Create default .txt file
open(my $out, '>', 'usageReport.txt') or die "Print out not opened!!!!\n";
print $out "System Name: $line1 Serial #: $line2\n";
printf $out ("%-45s %10s %10s %10s %13s    %-45s\n", $header[0], $header[1], $header[2], $header[3], $header[4], $header[5]);
for (my $i = 0; $i < scalar(@array); $i++)
{
    my @temp = split(" ", $array[$i]);
    if ($temp[0] eq "snap-reserve"){
        $temp[0] = "snap reserve";
    } 
    printf $out("%-45s %10s %10s %10s %13s    %-45s\n", $temp[0], $temp[1], $temp[2], $temp[3], $temp[4], $temp[5]);
}
print $out "\n";
close($out);

# Create .csv file
open($out, '>', 'usageReport.csv') or die "Print out not opened!!!!\n";
print $out "System Name:,$line1\nSerial #:,$line2\n";
my $csvFormat = join(',',@header);
print $out "$csvFormat\n"; 
for (my $i = 0; $i < scalar(@array); $i++)
{
    $csvFormat = join(',',split(" ", $array[$i]));
    $csvFormat =~  s/snap-reserve/snap reserve/g;
	print $out "$csvFormat\n";
}
close($out);

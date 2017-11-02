#! /usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use Scalar::Util qw(looks_like_number);

my @number_called;
my @student_assign;
my @student_called;
my @student_List;
my $random_number;
my $date = localtime();

if (-f "student_signIn.txt") # use Get_victim version 2.0
{
	open(my $read, '<', "student_signIn.txt") or die "student_signIn.txt NOT OPENED!!!!\n";

	while(my $row = <$read>)
	{
		chomp($row);
		push @student_List, $row;
	}

	close($read);

	if (! -f "student_called.txt" && !looks_like_number($student_List[0])) # pre-assign values for all students and create "student_called.txt"
	{
		my $count = 0;
		open(my $overwrite, '>', "student_signIn.txt") or die "student_signIn.txt NOT Wriiten Too!!!!\n";
		while (scalar(@student_assign) < scalar(@student_List))
		{
			my $bValid = 1;
			# if no matches found within the array
			while($bValid eq 1)
			{
				$bValid = 0;
				# Create a new random number if found on the list
				$random_number = int(rand(scalar(@student_List))) + 1;
				# search within the list
				for (my $i=0; $i < scalar(@student_assign); $i++)
				{
					my @number = split(" ",$student_assign[$i]);

					if (looks_like_number($number[0]))
					{
						if ($number[0] eq $random_number)
						{
						$bValid = 1;
						}
					}
				}
			}
			$student_assign[$count] = "$random_number $student_List[$count]";
			print $overwrite "$student_assign[$count]\n";
			$count++;
		}
		close($overwrite);
		open(my $create, '>>', "student_called.txt") or die "student_called.txt NOT CREATED!!!!\n";

			open(my $read, '<', "student_signIn.txt") or die "student_signIn.txt NOT OPENED!!!!\n";
			while(my $row = <$read>)
			{
				chomp($row);
				my @line = split(" ",$row);
				if ( $line[0] eq $random_number){
					print $create "$row $date\n";

					my @name = split(" ",$row);
					print "Victim: ";
					for (my $i=1; $i < scalar(@name); $i++)
					{
						print "$name[$i] ";
					}
					print "\n";
				}
			}
				close($read);
			
		close($create);
	}
	else # use pre-existing assigned values
	{
	
	open($read, '<', "student_called.txt") or die "student_called.txt NOT OPENED!!!!\n";
	
	while(my $row = <$read>)
	{
		chomp($row);
		push @student_called, $row;
	
	}
	close($read);

	my $bValid = 1;
		if (scalar(@student_called) < scalar(@student_List))
		{
			my $student;
			# if no matches found within the array
			while($bValid eq 1)
			{
				$bValid = 0;
				# Create a new random number if found on the list
				$random_number = int(rand(scalar(@student_List))) + 1;
				# search within the list
				for (my $i=0; $i < scalar(@student_called); $i++)
				{
					my @number = split(" ",$student_called[$i]);
					#print "$number[0]";
					if ($number[0] eq $random_number)
					{
						$bValid = 1;
					}
					else
					{
						$student = $student_List[$i];
					}
				}
			}
			open(my $write, '>>', "student_called.txt") or die "student_called.txt NOT Wriiten Too!!!!\n";
			print $write "$student $date\n";
			my @name = split(" ",$student);
			print "Victim: ";
			for (my $i=1; $i < scalar(@name); $i++)
			{
				print "$name[$i] ";
			}
			print "\n";
			close($write);
		}
		else
		{
			print "all users called\n"; 
		}
	}
}
else # use Get_victim version 1.0
{
	#gather all values that have been called
	if (-f "number_called.txt"){
		open(my $fh, '<', "number_called.txt") or die "number_called.txt NOT OPENED!!!!\n";

		while(my $row = <$fh>)
		{
			chomp($row);
			push @number_called, $row;
		}

		close($fh);
	}

	# Get random number
	if (@ARGV) #custom class size
	{
		my $bValid = 1;
		if (scalar(@number_called) < $ARGV[0])
		{
			# if no matches found within the array
			while($bValid eq 1)
			{
				$bValid = 0;
				# Create a new random number if found on the list
				$random_number = int(rand($ARGV[0])) + 1;
				# search within the list
				for (my $i=0; $i < scalar(@number_called); $i++)
				{
					if ($number_called[$i] eq $random_number)
					{
						$bValid = 1;
					}
				}
			}
			open(my $fh, '>>', "number_called.txt") or die "number_called.txt NOT Wriiten Too!!!!\n";
			print $fh "$random_number\n";
			print "$random_number\n";
			close($fh);
		}
		else
		{
			print "all users called\n"; 
		}

	}
	else
	{ #Default class size of 32
		my $bValid = 1;
		if (scalar(@number_called) < 32)
		{
			# if no matches found within the array
			while($bValid eq 1)
			{
				$bValid = 0;
				# Create a new random number if found on the list
				$random_number = int(rand(32)) + 1;
				# search within the list
				for (my $i=0; $i < scalar(@number_called); $i++)
				{
					if ($number_called[$i] eq $random_number)
					{
						$bValid = 1;
					}
				}
			}
			open(my $fh, '>>', "number_called.txt") or die "number_called.txt NOT Wriiten Too!!!!\n";
			print $fh "$random_number\n";
			print "$random_number\n";
			close($fh);
		}
		else
		{
			print "all users called\n"; 
		}
	}
}


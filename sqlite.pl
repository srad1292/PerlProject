#!/usr/bin/perl

use DBI;
use strict;

my $database;
my $dsn;
my $userid;
my $password;
my $dbh;

&execute;

#This subroutine calls the steps of the assignment
#creating the database, creating the table, inserting the data,
#and getting and printing the data
sub execute{
	&createDatabase;
	&createTable;
	&insertData;
	&outputData;
}

#This subroutine sets up the sqlite database as 'project.db'
sub createDatabase {
	$database = "project.db";
	$dsn = "DBI:SQLite:dbname=$database";
	$userid = "";
	$password = "";
	$dbh = DBI->connect($dsn, $userid, $password, { 
		PrintError => 0,
		RaiseError => 1,
		AutoCommit => 1,}) or die $DBI::errstr;

	print "Opened database successfully\n";
}

#This subroutine drops the old data from the people table
#and creates a new people table to insert data into
sub createTable{
	my $sql = << 'END_SQL';
	DROP TABLE IF EXISTS people
END_SQL
	$dbh->do($sql);


	my $sql = << 'END_SQL';
	CREATE TABLE people (
		id INTEGER PRIMARY KEY,
		first_name VARCHAR(15),
		last_name VARCHAR(15),
		home VARCHAR(15)
	)
END_SQL
	$dbh->do($sql);
}

#This subroutine inserts the data from the instructions into the people table
sub insertData{
	$dbh->do('INSERT INTO people (first_name, last_name, home) VALUES ("Rose","Tyler","Earth")');
	$dbh->do('INSERT INTO people (first_name, last_name, home) VALUES ("Zoe","Heriot","Space Station W3")');
	$dbh->do('INSERT INTO people (first_name, last_name, home) VALUES ("Jo","Grant","Earth")');
	$dbh->do('INSERT INTO people (first_name, home) VALUES ("Leela","Unspecified")');
	$dbh->do('INSERT INTO people (first_name, home) VALUES ("Romana","Gallifrey")');
	$dbh->do('INSERT INTO people (first_name, last_name, home) VALUES ("Clara","Oswald","Earth")');
	$dbh->do('INSERT INTO people (first_name, home) VALUES ("Adric","Alzarius")');
	$dbh->do('INSERT INTO people (first_name, last_name, home) VALUES ("Susan","Foreman","Gallifrey")');
}

#This subroutine retrieves the data from the people table
#and outputs it neatly formatted into a table
sub outputData{
	my $sql = 'SELECT first_name, last_name, home FROM people';
	my $sth = $dbh->prepare($sql);
	$sth->execute();
	my $fheading = "First Name";
	my $lheading = "Last Name";
	my $hheading = "Home";
	printf "%-15s   %-15s   %-15s\n\n",$fheading,$lheading,$hheading;
	while(my @row = $sth->fetchrow_array){
		printf "%-15s   %-15s   %-15s\n",$row[0],$row[1],$row[2];
}

}
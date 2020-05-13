#! /etc/bin/perl
use strict;
use Encode;

while(<STDIN>)
{
	chomp;
	s///g;
	my @arr = split(/\t/,$_);
	my $sent = $arr[0];
	my $freq = $arr[1];
	
	$sent = decode("gbk",$sent);
	
	while(length($sent)>100)
	{
		my $line=substr($sent,0,100);
		$sent = substr($sent,100,length($line)-1);
			
		#$line remove long pure letter and num strings
		#$line =~ s/[0-9a-zA-Z]{15,32760}//g; ***delet 20130703****
		#remove pure letters and nums
		#$line =~ s/^[0-9a-zA-Z]*$//;         ***delet 20130703****
		print encode("gbk",$line)."\n"if($line ne '');
	}
		#$sent =~ s/[0-9a-zA-Z]{15,32760}//g; ***delet 20130703****		
		#$sent =~ s/^[0-9a-zA-Z]*$//;         ***delet 20130703****
		print encode("gbk",$sent)."\n"if($sent ne '');
}


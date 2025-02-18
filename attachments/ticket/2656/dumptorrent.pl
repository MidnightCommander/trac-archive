#!/usr/bin/perl
#
# (C) 2009 Adrian Ulrich
# ...simple bencoding dumper
#
# Released under the terms of The "Artistic License 2.0".
# http://www.perlfoundation.org/legal/licenses/artistic-2_0.txt
#

use strict;
use Carp;
use Data::Dumper;

foreach my $file (@ARGV) {
	my $h = torrent2hash($file)->{content};
	delete($h->{info}->{pieces});
	print "# $file:\n";
	print Data::Dumper::Dumper($h);
}



	sub decode {
		my($string) = @_;
		my $ref = { data=>$string, len=>length($string), pos=> 0 };
		Carp::confess("decode(undef) called") if $ref->{len} == 0;
		return d2($ref);
	}
	
	sub encode {
		my($ref) = @_;
		Carp::confess("encode(undef) called") unless $ref;
		return _encode($ref);
	}
	
	
	
	sub _encode {
		my($ref) = @_;
		
		my $encoded = undef;
		
		Carp::cluck() unless defined $ref;
		
		if(ref($ref) eq "HASH") {
			$encoded .= "d";
			foreach(sort keys(%$ref)) {
				$encoded .= length($_).":".$_;
				$encoded .= _encode($ref->{$_});
			}
			$encoded .= "e";
		}
		elsif(ref($ref) eq "ARRAY") {
			$encoded .= "l";
			foreach(@$ref) {
				$encoded .= _encode($_);
			}
			$encoded .= "e";
		}
		elsif($ref =~ /^(\d+)$/) {
			$encoded .= "i$1e";
		}
		else {
			# -> String
			$encoded .= length($ref).":".$ref;
		}
		return $encoded;
	}
	

	sub d2 {
		my($ref) = @_;
		
		my $cc = _curchar($ref);
		if($cc eq 'd') {
			my $dict = {};
			for($ref->{pos}++;$ref->{pos} < $ref->{len};) {
				last if _curchar($ref) eq 'e';
				my $k = d2($ref);
				my $v = d2($ref);
				$dict->{$k} = $v;
			}
			$ref->{pos}++; # Skip the 'e'
			return $dict;
		}
		elsif($cc eq 'l') {
			my @list = ();
			for($ref->{pos}++;$ref->{pos} < $ref->{len};) {
				last if _curchar($ref) eq 'e';
				push(@list,d2($ref));
			}
			$ref->{pos}++; # Skip 'e'
			return \@list;
		}
		elsif($cc eq 'i') {
			my $integer = '';
			for($ref->{pos}++;$ref->{pos} < $ref->{len};$ref->{pos}++) {
				last if _curchar($ref) eq 'e';
				$integer .= _curchar($ref);
			}
			$ref->{pos}++; # Skip 'e'
			return $integer;
		}
		elsif($cc =~ /^\d$/) {
			my $s_len = '';
			while($ref->{pos} < $ref->{len}) {
				last if _curchar($ref) eq ':';
				$s_len .= _curchar($ref);
				$ref->{pos}++;
			}
			$ref->{pos}++; # Skip ':'
			
			return undef if ($ref->{len}-$ref->{pos} < $s_len);
			my $str = substr($ref->{data}, $ref->{pos}, $s_len);
			$ref->{pos} += $s_len;
			return $str;
		}
		else {
#			warn "Unhandled Dict-Type: $cc\n";
			$ref->{pos} = $ref->{len};
			return undef;
		}
	}

	sub _curchar {
		my($ref) = @_;
		return(substr($ref->{data},$ref->{pos},1));
	}



#################################################################
# Load a torrent file
sub torrent2hash {
	my($file) = @_;
	my $buff = undef;
	open(BENC, "<", $file) or return {};
	while(<BENC>) {
		$buff .= $_;
	}
	close(BENC);
	return {} unless $buff;
	return data2hash($buff);
}

sub data2hash {
	my($buff) = @_;
	my $href = decode($buff);
	return {} unless ref($href) eq "HASH";
	return {content=>$href, torrent_data=>$buff};	
}



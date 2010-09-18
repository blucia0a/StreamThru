#!/usr/bin/perl -w
use strict;
use IO::Socket;

my $port  = 8000;

$SIG{CHLD} = 'IGNORE';
my $S_Sock = IO::Socket::INET->new(LocalPort => $port,
				    Listen => 10,
				    Proto => 'tcp',
				    Reuse => 1
				   );
$S_Sock || die "failed to create server socket: $!\n";
while (my $C_Sock = $S_Sock->accept){
	my $pid;
	die "Fork Failed: $!\n" unless defined ($pid = fork());
	if($pid == 0){ #Child Process!
		$S_Sock->close; #done w/ this now
		  #play_songs($C_Sock);
		print $C_Sock "HTTP/1.0 200 OK\n";
		print $C_Sock "Content-Type: audio/x-wav\n";
		print $C_Sock "Cache-Control: no-cache\n";
		print $C_Sock "Pragma: no-cache\n";
		print $C_Sock "Connection: close \n";
		print $C_Sock "x-audiocast-name: MP3R4ND0N\n\n";

                binmode STDIN;
		my $read_status = 1;
		my $print_status = 1;
		my $chunk;
		while($read_status && $print_status){
			$read_status = read(STDIN,$chunk,1024);
			if(defined $chunk && defined $read_status){
				$print_status = print $C_Sock $chunk;
			}
			undef $chunk;
		}
                $C_Sock->close();
		exit 0;
	}else{ #Parent Process!
		warn "New Client: ",$C_Sock->peerhost,"\n";
		$C_Sock->close;
	}
}

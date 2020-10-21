#!/usr/bin/env perl
# /**---------------------------------------------------------------------------
#
#         File: autossh.pl
#
#        Usage: ./autossh.pl  
#
#  Description: 
#
#      Options: ---
# Requirements: ---
#         Bugs: ---
#        Notes: ---
#       Author: Liang Peng (...), pengliang@piesat
# Organization: ...
#      Version: 1.0
#      Created: 2020年10月14日 23时14分21秒
#     Revision: ---
# ----------------------------------------------------------------------------*/

use strict;
use warnings;
use utf8;
my $set = 0;
my $port = 11111;
my $fn = 2020-10-10-23-00;
while (1) {
    my $t = `ps -ef | grep 'autossh -M 5678 -N -R 11111' | grep -v grep`;
    print("\$t = $t");
    if ($t =~ /^\s*$/) {
        $set = 1;
    } else {
        while (!-e "port") {
            print("scp\n");
            system("scp -P122 1.119.5.181:~/port ./");
            sleep(1);
        }
        $fn = `cat port`;
        chomp($fn);
        if (!-e $fn) {
            $set = 1;
            system("cp port $fn");
            system("rm -rf port");
            while ($t =~ /1/) {
                my ($pid) = $t =~ /\s(\d+)\s/;
                print($pid);
                system("kill -9 $pid");
                $t = `ps -ef | grep 'autossh -M 5678 -N -R 11111' | grep -v grep`;
            }
        }
    }
    if ($set) {
        system('autossh -M 5678 -N -R 11111:localhost:22 -p 122 1.119.5.181 &');
        sleep(5);
        print("You can try new connection!!")
    }
    $set = 0;
    sleep(3);
    system("rm -rf port") if (-e "port");
}


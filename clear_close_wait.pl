#!/usr/bin/env perl
# /**---------------------------------------------------------------------------
#
#         File: clear_close_wait.pl
#
#        Usage: ./clear_close_wait.pl  
#
#  Description: 
#
#
#      Options: ---
# Requirements: ---
#         Bugs: ---
#        Notes: ---
#       Author: Liang Peng (...), pengliang@piesat
# Organization: ...
#      Version: 1.0
#      Created: 2020年10月16日 08时13分59秒
#     Revision: ---
# ----------------------------------------------------------------------------*/

use strict;
use warnings;
use utf8;
my $port = shift;
my $usr = shift;
$usr = 'root' if !defined($usr);

my $ii = 1;
my $dd = 1;
while (1) {
    # 检查连接，尝试登录
    my $ssh = `timeout 10 ssh $usr\@localhost -p $port 2>/dev/null`;

    # 生成当前局地时间字符串
    my $lt = localtime();
    $lt =~ s/[^\w]/-/g;

    # 
    my $t = `sudo lsof -i:$port | grep CLOSE_WAIT`;
    if ($t =~ /1/) {
        print("$port is bad\n");
        print("ps=$t\n");
        #print("ssh=$ssh\n");
        my ($pid) = $t =~ /\s(\d+)\s/;
        system("sudo kill -9 $pid");
        system("echo $lt > /home/leon/ports/$port");
    } elsif (`sudo lsof -i:$port` =~ /^\s*$/) {
        print("$port is lost\n");
        print("\$t=$t\n");
        system("echo $lt > /home/leon/ports/$port");
    } else {
        print("$port is OK ".("." x $ii)."\n");
    }
    my $i = 1;
    my $d = 1;
    while (`sudo lsof -i:$port` =~ /^\s*$/) {
        print("No $port:"."-" x $i);
        print("\n");
        sleep(3);
        $d = -1 if $i == 4;
        $d = 1 if $i == 1;
        $i = $i + $d;
    }
    sleep(3);
    $dd = -1 if $ii >= 5;
    $dd = 1 if $ii <= 1;
    $ii = $ii + $dd;
}


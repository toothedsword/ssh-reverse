#!/usr/bin/env perl
# /**---------------------------------------------------------------
#
#         File: autossh_v1.pl
#
#        Usage: ./autossh_v1.pl <port> <site>  
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
# ----------------------------------------------------------------*/

use v5.10;
use strict;
my $set = 0;
my $port = shift;
my $site = shift;
my $ptime0 = "";
while (1) {
    say "\nStart...............................";
    say "   >>> 查看连接状态";
    my $t = `ps -ef | grep 'autossh -M 5678 -N -R $port' | grep -v grep`;
    if ($t =~ /1/) {
        print $t;
    } else {
        say "No connection";
    }

    say "   >>> 获取服务器更新请求";
    my $ptime = '';
    while ($ptime =~ /^\s*$/) {
        my $ssh = `
        ssh -p $site << EOD
        echo -----
        cat ports/$port
        echo -----
        exit
        EOD
        `;
        ($ptime) = $ssh =~ /-----\s*([^\s]+)\s*-----/;
        say("ptime=",$ptime);
        sleep(1);
    }

    if ($t =~ /^\s*$/) {
        say "   >>> 没有连接信息，需要建立连接";
        $set = 1;
    } else {
        if ($ptime eq $ptime0) {
            say "   >>> 请求无更新，无需重新建立连接";
        } else {
            say "   >>> 端口请求更新，清除当前连接，需要重新建立连接";
            $set = 1;
            while ($t =~ /1/) {
                my ($pid) = $t =~ /\s(\d+)\s/;
                my $cmd = "kill -9 $pid";
                say $cmd;
                `$cmd`;
                $t = `ps -ef | grep 'autossh -M 5678 -N -R $port' | grep -v grep`;
            }
        }
    }
    $ptime0 = $ptime;

    if ($set) {
        say "   >>> 正在建立连接";
        my $cmd = "autossh -M 5678 -N -R $port:localhost:22 -p $site &";
        say $cmd;
        system($cmd);
        my $lt = localtime();
	system("echo '$lt' >> log.log");
        say "You can try new connection!!!!!!!";
        sleep(5);
    }
    $set = 0;
    say "Goto sleep...";
    sleep(30);
}


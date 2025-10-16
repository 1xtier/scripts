#!/usr/bin/env perl
use strict;
use warnings;

my $ZPOOL = '/sbin/zpool';
my $status_output = `$ZPOOL status 2>/dev/null`;

if ($? != 0) {
  print "The zfs file system was not found\n";
  exit 0
}

if ($status_output =~ /degraded/i) {
  print "degraded\n";
}



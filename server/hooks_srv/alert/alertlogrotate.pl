#!/usr/bin/env perl

use strict;
use warnings;
use File::Copy;
use File::stat;
use POSIX qw(strftime);

my $LOG_FILE = '/var/log/monit/alert_monitlog';
my $MAX_SIZE = '10 * 1024 * 1024';
my $KEEP_COUNT = 7;

if (-f $LOG_FILE && -s $LOG_FILE > $MAX_SIZE) {
  print "Rotating $LOG_FILE (size: " . (-s $LOG_FILE) . " bytes)\n";
  
  unlink("$LOG_FILE.3") if -f "$LOG_FILE.3";

  rename("$LOG_FILE.2", "$LOG_FILE.3") if -f "$LOG_FILE.2";
  rename("$LOG_FILE.1", "$LOG_FILE.2") if -f "$LOG_FILE.1";
  rename($LOG_FILE, "$LOG_FILE.1") or die "Cannot rotate $LOG_FILE: $!";

  open(my $fh, '>', $LOG_FILE) or die "Cannot create $LOG_FILE: $!";

  print "Log rotation completed\n";
} else {
  print "No rotation needed\n";
}

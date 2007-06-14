#!perl -T

use strict;
use warnings;
use Test::More tests => 3;

use Carp;
use Config::Apt::Sources;
my $srcs = Config::Apt::Sources->new();

$srcs->parse_stream(do { local $/; <DATA> });
if ((($srcs->get_sources)[0]->get_components())[1] eq "non-free") {
  pass("file parsed correctly");
} else {
  fail("file failed to parse");
}

($srcs->get_sources)[2]->set_uri("http://example.com");

if (($srcs->get_sources)[2]->to_string() eq "deb http://example.com testing/updates main") {
  fail("reference bug. mirror should not have been updated.");
} else {
  pass("no reference bug");
}

my @sources = $srcs->get_sources;
$sources[2]->set_uri("http://example.com");
$srcs->set_sources(@sources);

if (($srcs->get_sources)[2]->to_string() eq "deb http://example.com testing/updates main") {
  pass("change parsed correctly");
} else {
  fail("failed to update mirror");
}

__DATA__
deb http://ftp.us.debian.org/debian/ unstable main non-free contrib
deb-src http://ftp.us.debian.org/debian/ unstable main non-free contrib
# This is a comment.  It's cooler than all its other comment buddies because
#   it's followed by a blank line, too!

deb http://security.debian.org/ testing/updates main

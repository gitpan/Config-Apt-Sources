#!perl -T

use strict;
use warnings;
use Test::More tests => 4;

use Config::Apt::SourceEntry;
my $src = Config::Apt::SourceEntry->new("deb http://example.com/debian testing main contrib");
my ($type,$uri,$dist,@components);
$type = $src->get_type();
$uri  = $src->get_uri();
$dist = $src->get_dist();
@components = $src->get_components();

if ($type eq "deb" && $uri eq "http://example.com/debian" && $dist eq "testing") {
  pass("source line parsed correctly");
} else {
  fail("failed to parse test line");
}

if ($components[0] eq "main" && $components[1] eq "contrib") {
  pass("parsed components correctly");
} else {
  fail("failed to parse components");
}

$src->set_type("deb-src");
$src->set_uri("ftp://example.net/ubuntu/");
$src->set_dist("edgy");
$src->set_components(("main"));

my $line = $src->to_string();

if ($line eq "deb-src ftp://example.net/ubuntu/ edgy main") {
  pass("set and constructed new line correctly");
} else {
  fail("failed to construct new line");
}

$src = Config::Apt::SourceEntry->new("deb http://example.com/debian-custom ./");
if (defined $src) {
  pass("entry with no components created");
} else {
  fail("failed to create entry with no components");
}

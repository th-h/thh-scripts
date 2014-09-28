#! /usr/bin/perl -W
#
# footnotes Version 0.1 by Thomas Hochstein
#
# This script will convert footnotes in WP-footnotes notation
# to MultiMarkDown, i.e. replace "((Text for footnote))" with
# "[^1]" and add "[^1]: Text for footnote" at the end of the
# text, incrementing the counter each time, or the other way
# round.
# 
# Copyright (c) 2014 Thomas Hochstein <thh@inter.net>
#
# It can be redistributed and/or modified under the same terms under 
# which Perl itself is published.

my $VERSION = "0.1";

use strict;
use Getopt::Long qw(GetOptions);

# read commandline option(s)
my ($OptTo,$OptFile);
GetOptions ('t|to=s'     => \$OptTo,
            'f|file=s'   => \$OptFile,
            'h|help'     => \&ShowPOD,
            'V|version'  => \&ShowVersion) or exit 1;

# read whole article from STDIN or --file
undef $/;
my $article;
if ($OptFile) {
  open(FILE, "< $OptFile") or die "Can't open $OptFile: $!";
  $article = <FILE>;
  close(FILE);
} else {
  $article = <>;
}
$/ = "\n";

# conversion and output
my $output;

if (lc($OptTo) eq 'mmd') {
  $output = &ConvertToMMD($article);
} elsif (lc($OptTo) eq 'wp') {
  $output = &ConvertToWP($article);
} else {
	print "Please set '--to' to 'mmd' or 'wp'!\n";
  exit(1);
}

print $output;
exit(0);

################################################################################

sub ConvertToMMD {
  my $article = shift;
  my $footnotes;
  my $counter = 1;
  
  # match and remove all ((...)),
  # replacing them with [^n], incrementing n each time
  while ( $article =~ s/\(\((.+?)\)\)/"[^$counter]"/seo ) {
    $footnotes .= "[^$counter]: " . $1 . "\n";
    $counter++;
  }

  return "$article\n\n$footnotes\n";
}

sub ConvertToWP {
  my $article = shift;
  my @footnotes;
  my $counter = 1;

  # read footnotes in [^n] format
  while ( $article =~ s/^\[\^$counter\]: (.+)$//m ) {
    $footnotes[$counter] = $1;
    $counter++;
  }

  # replace footnote plcaeholders with footnote content
  $counter = 0;
  foreach my $footnote (@footnotes) {
    $article =~ s/\[\^$counter\]/"(($footnote))"/eg;
    $counter++;
  }

  # remove trailing whitespace
  $article =~ s/\n+$//g;

  return "$article\n";
}

sub ShowVersion {
  print "MMD-FootNotes v$VERSION\n";
  print "Copyright (c) 2014 Thomas Hochstein <thh\@inter.net>\n";
  print "This program is free software; you may redistribute it ".
        "and/or modify it under the same terms as Perl itself.\n";
  exit(100);
};

sub ShowPOD {
  exec('perldoc', $0);
  exit(100);
};

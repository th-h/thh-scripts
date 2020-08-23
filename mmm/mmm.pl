#! /usr/bin/perl -W
#
# mmm Version 0.3 by Thomas Hochstein
#
# Create a MIME multipart/alternative part, containing
# text/plain (in Markdowen) and text/html, from a
# Markdown file.
#
# Copyright (c) 2015-2016 Thomas Hochstein <thh@thh.name>
#
# It can be redistributed and/or modified under the same terms under 
# which Perl itself is published.

my $VERSION = "0.3";

use strict;
use Getopt::Long qw(GetOptions);
use Text::Markdown;

# read commandline option(s)
my ($OptInFile,$OptHeaderFile);
GetOptions ('f|file=s'    => \$OptInFile,
            't|headers=s' => \$OptHeaderFile,
            'H|help'      => \&ShowPOD,
            'V|version'   => \&ShowVersion) or exit 1;

# read input from STDIN or --file
# unset $/
undef $/;
my $markdown;
if ($OptInFile) {
  open(FILE, "< $OptInFile") or die "Can't open $OptInFile: $!";
  $markdown = <FILE>;
  close(FILE);
} else {
  $markdown = <>;
}
# read header template
my $headers;
if ($OptHeaderFile) {
  open(HEADERS, "< $OptHeaderFile") or die "Can't open $OptHeaderFile: $!";
  $headers = <HEADERS>;
  close(HEADERS);
  # remove all trailing newlines
  $headers =~ s/\n+$//;
}
# reset $/
$/ = "\n";

# convert markdown to html
my $html = Text::Markdown::Markdown($markdown);

# output
print  "$headers\n" if ($OptHeaderFile);

my $Boundary = &GenBoundary;
print  "MIME-Version: 1.0\n";
print  "Content-Type: multipart/alternative;\n";
printf ('   boundary="%s"'."\n",$Boundary);
print  "\n";

print  "This is a multi-part message in MIME format.\n";

printf ("--%s\n",$Boundary);
print  "Content-Type: text/plain; charset=ISO-8859-15\n";
print  "Content-Transfer-Encoding: 8bit\n";
print  "\n";
print  "$markdown\n";

printf ("--%s\n",$Boundary);
print  "Content-Type: text/html; charset=ISO-8859-15\n";
print  "Content-Transfer-Encoding: 8bit\n";
print  "X-Creator: Markdown/1.0.1\n";
print  "\n";
print  "$html\n";

printf ("--%s--\n",$Boundary);

exit(0);

################################################################################

sub GenBoundary {
  my $hex;
  $hex .= sprintf("%x", rand 16) for 1..25;
  return ( "--MMM" . $hex);
}

sub ShowVersion {
  print "mmm v$VERSION\n";
  print "MIME multipart/alternative from Markdown - MMM\n";
  print "Copyright (c) 2015 Thomas Hochstein <thh\@thh.name>\n";
  print "This program is free software; you may redistribute it ".
        "and/or modify it under the same terms as Perl itself.\n";
  exit(100);
};

sub ShowPOD {
  exec('perldoc', $0);
  exit(100);
};

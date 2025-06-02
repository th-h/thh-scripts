#!/usr/bin/perl
#
# pocket-raindrop.pl
#
# Reformat a CSV export file from Pocket <https://getpocket.com/>
# into a CSV import file for Raindrop <https://raindrop.io/>.
#
# - 'time_added' is renamed to 'created'
# - empty 'note' entries are added
# - tags are reformatted (from tag1|tag2 to "tag1, tag2")
# - 'unread'/'archive' status is moved to an 'unread' or 'archive'
#   tag, as Raindrop does not have this status.
#
# Usage: 'pocket-raindrop.pl <IMPORTFILE>', e.g.
# $ pocket-raindrop.pl part_000000.csv
#
# Output is written to 'raindrop.csv'.
#
# Copyright (c) 2025 Thomas Hochstein <thh@thh.name>
#
# This file can be redistributed and/or modified under the same terms
# under which Perl itself is published.

use strict;
use warnings;

use Text::CSV; # from CPAN / apt install libtext-csv-perl

# --------------------------------------------------------------------
# new CVS object
my $csv = Text::CSV->new;

# ----------------------------------------
# get $inputfile from command line argument
my $inputfile = shift(@ARGV);
open my $fh, "<:encoding(UTF-8)", $inputfile  or die "inputfile: $!";

# get column names
my @fieldlist = @{$csv->getline ($fh)};
$csv->column_names (@fieldlist);

# read CSV
my @rows;
while (my $row = $csv->getline_hr ($fh)) {
  # parse and modify CSV
  if ($row->{'url'}) {
    my @tags;

    # move 'time_added' to 'created'
    $row->{'created'} = $row->{'time_added'};
    delete($row->{'time_added'});

    # add empty 'note'
    $row->{'note'} = '';

    # move status ('read'/'unread') to tags
    if ($row->{'status'}) {
      push @tags, $row->{'status'};
      delete($row->{'status'});
    }

    # add 'twitter' tag for 't.co' URLs
    # if ($row->{'url'} =~ m!^http://t\.co/!) {
    #   push @tags, 'twitter';
    # }

    # reformat current tags
    if ($row->{'tags'} =~ /\|/) {
      push @tags, split(/\|/,$row->{'tags'});
    } elsif ($row->{'tags'}) {
      push @tags, $row->{'tags'};
    }

    # rewrite tags from @tags
    if (@tags) {
        $row->{'tags'} = join(', ', @tags);
    }

    # add to result array for output
    push @rows, $row;
  }
}

close $fh;

# ----------------------------------------
# write new CSV to raindrop.csv
@fieldlist = qw/title url created tags note/;
$csv->column_names (@fieldlist);

open $fh, ">:encoding(UTF-8)", 'raindrop.csv'  or die "raindrop.csv: $!";

print $fh (join(',', @fieldlist)), "\n";

foreach (@rows) {
  $csv->print_hr ($fh, $_);
  print $fh "\n";
}

close $fh;

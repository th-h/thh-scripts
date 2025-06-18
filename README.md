# My personal scripts

I will add some small (and rather hackish) scripts for my
personal use here.

## Perl

### [mmm.pl](generators/mmm.pl)

`mmm` (*MIME multipart/alternative from Markdown*) can
create a MIME `multipart/alternative` mail, containing a
`text/plain` part (in Markdown) and a `text/html` part, from
a Markdown file. Other mail headers (From:, To:, Subject:, ...)
can be prepended from a template file.

Usage: `mmm [--file $inputfile] [--headers $templatefile]`

### [footnotes.pl](converters/footnotes.pl)

`footnotes` will convert footnotes in MultiMarkDown format
to the format of the Wordpress plugin
[footnotes](https://wordpress.org/plugins/footnotes/) and back.

Usage: `footnotes --to mmd|wp [--file $inputfile]`

### [pocket-raindrop.pl](converters/pocket-raindrop.pl)

`pocket-raindrop` will reformat a CSV export file from
[Pocket](https://getpocket.com/) into a CSV import file for
[Raindrop](https://raindrop.io/).

Usage: `pocket-raindrop part_000000.csv`, output to `raindrop.csv`.

# My personal scripts

I will add some small (and rather hackish) scripts for my
personal use here.

## Perl

### footnotes.pl

`footnotes` will convert footnotes in MultiMarkDown format
to the format of the Wordpress plugin
[footnotes](https://wordpress.org/plugins/footnotes/) and back.

Usage: `footnotes --to mmd|wp [--file $inputfile]`

### mmm.pl

`mmm` (*MIME multipart/alternative from Markdown*) can
create a MIME `multipart/alternative` mail, containing a
`text/plain` part (in Markdowen) and a `text/html` part, from
a Markdown file. Other mail headers (From:, To:, Subject:, ...)
can be prepended from a template file.

Usage: `mmm [--file $inputfile] [--headers $templatefile]`

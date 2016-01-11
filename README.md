# StrictNamedArguments
[![Build Status](https://travis-ci.org/gfldex/perl6-xhtml-writer.svg?branch=master)](https://travis-ci.org/gfldex/perl6-xhtml-writer)

Write xhtml elements utilising named arguments to guard against typos. Colons in
names of XHTML attributes are replaced with a hyphen. Use the the html element names
as an import tag or :ALL to get them all. Please note that there is a dd-tag what will
overwrite dd from the settings.

Usage:
```
use v6;
use XHTML::Writer :ALL;

put html( xml-lang=>'de', 
	body(
        div( id="uniq",
          p( class="abc", 'your text here'),
          p( 'more text' )
        )
    ));
```

With skeleton:

```
use v6;
use XHTML::Writer :p, :title;
use XHTML::Skeleton;

put xhtml-skeleton(p('Hello Camelia!'), header=>title('Hello Camelia'));
```


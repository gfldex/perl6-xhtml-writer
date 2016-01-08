# StrictNamedArguments
[![Build Status](https://travis-ci.org/gfldex/perl6-xhtml-writer.svg?branch=master)](https://travis-ci.org/gfldex/perl6-xhtml-writer)

Write xhtml elements utilising named arguments to guard against typos. Colons in
names of XHTML attributes are replaced with a hyphen.

Usage:
```
use v6;
use XHTML::Writer;

put html( xml-lang=>'de', 
	body(
        div( id="uniq",
          p( class="abc", 'your text here'),
          p( 'more text' )
        )
    ));
```


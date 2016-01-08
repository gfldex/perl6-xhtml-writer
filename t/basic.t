use XHTML11;

say table(id=>'foo', class=>'de', tr(class=>'.tr', td(class=>'.td', 'abc'), td('ghj')));

say p(p(p('abc'),p('ghj')));

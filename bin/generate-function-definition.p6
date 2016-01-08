use v6;
use XML;

#TODO <br/>


sub MAIN($schema-file?) {

	my $doc = from-xml-file($schema-file // '3rd-party/xhtml1-strict.xsd');

	my %attr-group;

	multi sub walk(XML::Text, *%named){} # NOOP

	multi sub walk(XML::Element $_ where .name ~~ <xs:attributeGroup>){
		.nodes>>.&walk(group-name=>.attribs<name>);
	}

	multi sub walk(XML::Element $_ where .name ~~ <xs:attributeGroup>, :$group-name){
		my $ref = .attribs<ref> // Failure.new;
		%attr-group{$group-name}.push: |%attr-group{$ref};
		.nodes>>.&walk(group-name=>.attribs<name>);
	}

	multi sub walk(XML::Element $_ where .name ~~ <xs:attribute>, :$group-name!){
		my $name = .attribs<name> // .attribs<ref> // Failure.new;
		%attr-group.push($group-name=>$name);
		.nodes>>.&walk(:$group-name);
	}

	my %elements;
	put 'my $indent = 0;' ~ "\n";
	multi sub walk(XML::Element $_ where .name ~~ <xs:element> && (.attribs<name>:exists)) {
		my $name := .attribs<name> // Failure.new;
		%elements{$name} = Any;
		.nodes>>.&walk(element-name=>$name);		
		put 'sub ', $name, '(', (':$' xx * Z~ %elements{$name}>>.subst(':', '-').list Z~ '?,' xx *), ' *@c) is export {', "\n    (temp \$indent)+=2;\n",
		"    '<", $name, "' ~\n ", %elements{$name}.list.map({
			"   (\${$_.subst(':', '-')} ?? ' $_' ~ '=' ~ \"\\\"\${$_.subst(':', '-')}\\\"\" !! Empty) ~\n" 	
		}), q{    ">\\n" ~ @c>>.Str>>.indent($indent).join("\n") ~ (+@c ?? "\\n" !! "") ~ '</}, $name, ">'", "\n",
		'}', "\n";
	}

	multi sub walk(XML::Element $_ where .name ~~ <xs:attribute>, :$element-name!) {
		my $name = .attribs<name> // .attribs<ref> // Failure.new;
		%elements{$element-name}.push: |$name;
	}

	multi sub walk(XML::Element $_ where .name ~~ <xs:attributeGroup>, :$element-name!) {
		%elements{$element-name}.push: |%attr-group{.attribs<ref>};
	}

	multi sub walk(XML::Element $_, *%named){
		.nodes>>.&walk(|%named);
	}

	multi sub walk(*@_, *%named) {
		.nodes>>.&walk(|%named);
	}

	$doc.root.nodes>>.&walk;

}

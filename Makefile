lib/XHTML/Writer.pm6: bin/generate-function-definition.p6 Build.pm
	perl6 -I . -M Build -e 'Build.new.build(".")'

TESTS=t/basic.t

$(TESTS): lib/XHTML/Writer.pm6

test: t/basic.t
	prove --exec "perl6 -I ./lib" -r ./t/

lib: lib/XHTML/Writer.pm6

all: lib test

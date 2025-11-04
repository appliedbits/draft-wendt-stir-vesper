#!/bin/bash

TITLE="draft-wendt-stir-vesper"
VERSION="-06"

/opt/homebrew/Cellar/gem-kramdown-rfc/1.7.29/gems/kramdown-rfc2629-1.7.29/bin/kramdown-rfc --verbose --v3 $TITLE$VERSION.md > $TITLE$VERSION.xml
#/opt/homebrew/opt/ruby/bin/kramdown-rfc --verbose --v3 $TITLE$VERSION.md > $TITLE$VERSION.xml
xml2rfc $TITLE$VERSION.xml -o $TITLE$VERSION.txt --text

# /Users/cwendt/Sync/MyDocs/ietf
#!/bin/bash

TITLE="draft-wendt-stir-vesper"
VERSION="-07"

/opt/homebrew/lib/ruby/gems/4.0.0/gems/kramdown-rfc2629-1.7.34/bin/kramdown-rfc --verbose --v3 $TITLE$VERSION.md > $TITLE$VERSION.xml
#/opt/homebrew/opt/ruby/bin/kramdown-rfc --verbose --v3 $TITLE$VERSION.md > $TITLE$VERSION.xml
xml2rfc $TITLE$VERSION.xml -o $TITLE$VERSION.txt --text

# /Users/cwendt/Sync/MyDocs/ietf
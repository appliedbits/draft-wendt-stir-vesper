#!/bin/bash

TITLE="draft-wendt-stir-vesper"
VERSION="-02"

/opt/homebrew/Cellar/gem-kramdown-rfc/1.7.19/gems/kramdown-rfc2629-1.7.19/bin/kramdown-rfc $TITLE$VERSION.md > $TITLE$VERSION.xml
xml2rfc -q $TITLE$VERSION.xml -o $TITLE$VERSION.txt --text

# /Users/cwendt/Sync/MyDocs/ietf
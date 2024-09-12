#!/bin/bash

TITLE="draft-wendt-stir-vesper"
VERSION="-00"

/opt/homebrew/Cellar/gem-kramdown-rfc/1.7.17/gems/kramdown-rfc2629-1.7.17/bin/kramdown-rfc $TITLE$VERSION.md > $TITLE$VERSION.xml
xml2rfc -q $TITLE$VERSION.xml -o $TITLE$VERSION.txt --text

# /Users/cwendt/Sync/MyDocs/ietf
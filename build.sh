#!/bin/sh
set -eu

# Tiny — a cheeky one-file static site generator.
# Requires cmark (https://github.com/commonmark/cmark).

CMARK_BIN=${CMARK:-cmark}
command -v "$CMARK_BIN" >/dev/null 2>&1 || { echo "tiny: cmark not found" >&2; exit 1; }

usage(){ echo "usage: $0 [template [output]]" >&2; exit 1; }

ROOT="$(cd "$(dirname "$0")" && pwd)"
CONTENT="$ROOT/content.md"
DEFAULT_TEMPLATE="$ROOT/template.html"
DEFAULT_OUTPUT="$ROOT/index.html"

[ "$#" -le 2 ] || usage

case "${1:-}" in
	-h|--help) usage;;
esac

if [ "$#" -ge 1 ]; then
	TEMPLATE=$1
else
	TEMPLATE=$DEFAULT_TEMPLATE
fi

if [ "$#" -ge 2 ]; then
	OUTPUT=$2
else
	OUTPUT=$DEFAULT_OUTPUT
fi

case $TEMPLATE in
	/*) :;;
	*) TEMPLATE="$ROOT/$TEMPLATE";;
esac

case $OUTPUT in
	/*) :;;
	*) OUTPUT="$ROOT/$OUTPUT";;
esac

[ -f "$TEMPLATE" ] || { echo "tiny: template '$TEMPLATE' not found" >&2; exit 1; }

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

awk -v dir="$TMP" '
BEGIN{section=""}
/^## /{
	section=substr($0,4)
	gsub(/\r/,"",section)
	slug=tolower(section)
	gsub(/[^a-z0-9]+/,"-",slug)
	gsub(/^-+/,"",slug)
	gsub(/-+$/,"",slug)
	if(slug!=""){
		close(path)
		path=dir"/"slug".md"
		section=slug
	}else{
		section=""
	}
	next
}
section!=""{print>path}
' "$CONTENT"

slugify(){ printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g'; }
render(){ "$CMARK_BIN" "$TMP/$1.md"; }
lede(){ render "$1" | sed '0,/<p>/s//<p class="section-lede">/'; }
plain(){ "$CMARK_BIN" -t commonmark "$TMP/$1.md" | tr '\n' ' ' | sed 's/ \{1,\}$//' | sed -e 's/&/&amp;/g' -e 's/"/&quot;/g' -e "s/'/&#39;/g" -e 's/</&lt;/g' -e 's/>/&gt;/g'; }
raw(){ cat "$TMP/$1.md"; }

PLACEHOLDERS=$(grep -o '{{[^}]*}}' "$TEMPLATE" | sort -u || true)
[ -n "$PLACEHOLDERS" ] || { cp "$TEMPLATE" "$OUTPUT"; echo "tiny: wrote $OUTPUT"; exit 0; }

MAP="$TMP/map"
: > "$MAP"

printf '%s\n' "$PLACEHOLDERS" | while IFS= read -r placeholder; do token=${placeholder#{{};token=${token%}};mode=${token%%:*};key=${token#*:};[ "$mode" != "$token" ] || { mode=render; key=$token; };slug=$(slugify "$key");[ -s "$TMP/$slug.md" ] || { echo "tiny: missing section for $placeholder" >&2; exit 1; };out="$TMP/value.$mode.$slug";case $mode in render) render "$slug" > "$out";; lede|intro) lede "$slug" > "$out";; plain|text) plain "$slug" > "$out";; raw|markdown) raw "$slug" > "$out";; *) echo "tiny: unknown mode '$mode'" >&2; exit 1;; esac;printf '%s\t%s\n' "$placeholder" "$out" >> "$MAP";done

awk -v map="$MAP" 'function literal(p,l,b){b="";while((getline l<p)>0){b=b?(b"\n"l):l}close(p);gsub(/\\/,"\\\\",b);gsub(/&/,"\\\\\\&",b);return b}BEGIN{FS="\t";while((getline<map)>0){place[++count]=$1;val[count]=literal($2)}}{line=$0;for(i=1;i<=count;i++)gsub(place[i],val[i],line);print line}' "$TEMPLATE" > "$OUTPUT"

echo "tiny: wrote $OUTPUT"

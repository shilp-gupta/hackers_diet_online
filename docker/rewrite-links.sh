#!/bin/bash
set -euo pipefail

domain="${HDO_COOKIE_DOMAIN:-localhost:8080}"
scheme="${HDO_SITE_SCHEME:-http}"
base="${scheme}://${domain}"

targets=(webdoc src)

find "${targets[@]}" -type f \( \
    -name '*.html' -o -name '*.htm' -o -name '*.css' -o -name '*.js' -o \
    -name '*.pl' -o -name '*.pm' -o -name '*.w' -o -name '*.tex' -o \
    -name '*.md' -o -name '*.txt' \
\) -print0 | while IFS= read -r -d '' file; do
    perl -0pi -e 's{https?://www\.fourmilab\.ch/cgi-bin/HackDietBadge}{'"$base"'/cgi-bin/HackDietBadge}g' "$file"
    perl -0pi -e 's{https?://www\.fourmilab\.ch/cgi-bin/HackDiet}{'"$base"'/cgi-bin/HackDiet}g' "$file"
    perl -0pi -e 's{https?://www\.fourmilab\.ch/hackdiet/online}{'"$base"'/hackdiet/online}g' "$file"
    perl -0pi -e 's{https?://www\.fourmilab\.ch/hackdiet}{'"$base"'/hackdiet}g' "$file"
    perl -0pi -e 's{https?://www\.fourmilab\.ch/images/logo/swlogo\.png}{'"$base"'/hackdiet/online/figures/swlogo.png}g' "$file"
done

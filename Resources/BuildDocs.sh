#! /bin/sh

/usr/local/bin/appledoc \
--project-name "GVCFoundation" \
--project-company "Global Village Consulting" \
--company-id "net.global-village" \
--docset-atom-filename "GVCFoundation.atom" \
--docset-feed-url "http://global-village.net/GVCFoundation/%DOCSETATOMFILENAME" \
--docset-package-url "http://global-village.net/GVCFoundation/%DOCSETPACKAGEFILENAME" \
--docset-fallback-url "http://global-village.net/GVCFoundation/" \
--output "~/help" \
--publish-docset \
--logformat xcode \
--keep-undocumented-objects \
--keep-undocumented-members \
--keep-intermediate-files \
--no-repeat-first-par \
--no-warn-invalid-crossref \
--ignore "*.m" \
--index-desc "${PROJECT_DIR}/Resources/Licenses/GVC License.md" \
"${PROJECT_DIR}/GVCFoundation"

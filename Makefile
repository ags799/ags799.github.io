SHELL = /bin/sh

# .git/hooks/pre-commit depends on this target name
index.html: index.html.tmpl config.yml
	gomplate \
		--datasource config=./config.yml \
		--file index.html.tmpl \
		--out index.html

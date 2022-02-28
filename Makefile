SHELL = /bin/sh
index.html: index.html.tmpl config.yml
	gomplate --datasource config=./config.yml --file index.html.tmpl --out index.html

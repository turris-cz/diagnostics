#!/bin/sh
set -eu

export TEXTDOMAIN=turris-diagnostics-web
export TEXTDOMAINDIR=/usr/share/locale
LANGUAGE="$(uci get foris.settings.lang 2>/dev/null || echo "en")"
export LANGUAGE


page() {
	cat <<EOF
<!doctype html>
<html lang="$LANGUAGE">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<link rel="shortcut icon" id="light-scheme-icon" href="/turris-theme/favicon-black.png">
	<link rel="icon" id="dark-scheme-icon" href="/turris-theme/favicon-white.png">
	<link rel="stylesheet" id="css-dark" href="/turris-theme/darkly-5.min.css" media="(prefers-color-scheme: dark)">
	<link rel="stylesheet" id="css-light" href="/turris-theme/flatly-5.min.css" media="(prefers-color-scheme: light)">
	<style type="text/css" media="screen">
	.smaller { max-width: 540px; }
	</style>
	<script src="/turris-theme/darkmode_head.js"></script>
	<title>$(gettext "Turris Diagnostics")</title>
</head>
<body class="align-middle text-center">
	<div class="container smaller d-grid mt-5">
		<picture>
			<source name="dark" srcset="/turris-theme/logo-white.svg" media="(prefers-color-scheme: dark)">
			<source name="light" srcset="/turris-theme/logo-black.svg" media="(prefers-color-scheme: light)">
			<img class="mb-3" name="img" src="/turris-theme/logo-black.svg" alt="Turris Logo" width="280">
		</picture>
		<h2>$(gettext "Diagnostics")</h2>
		<p>$(gettext "This page allows you to generate diagnostics report for your Turris router.")</p>

		<a class="btn btn-primary mt-3 mb-3" href="./diagnostics.txt.gz" role="button">
			$(gettext "Generate and download diagnostics")
		</a>

		<div class="alert alert-warning mt-3">
			$(gettext "Make sure that download is finished before sending it to support or disconnecting from the router's network. The report is being generated during download, so it takes a considerable amount of time.")
		</div>

	</div>
	<script async src="/turris-theme/darkmode_body.js"></script>
</body>
</html>
EOF
}


endpoint="${PATH_INFO##*/diagnostics}"
case "$endpoint" in
	.gz|.txt.gz)
		echo "Status: 200 OK"
		echo 'Content-Type:application/octet-stream; name = "diagnostics.txt.gz"'
		echo 'Content-Disposition: attachment; filename = "diagnostics.txt.gz"'
		echo
		/usr/share/diagnostics/diagnostics.sh | gzip
		;;
	.txt)
		echo "Status: 200 OK"
		echo "Content-type: text/plain"
		echo
		/usr/share/diagnostics/diagnostics.sh
		;;
	.html)
		echo "Status: 200 OK"
		echo "Content-type: text/html"
		echo
		page
		;;
	*)
		echo "Status: 303 See Other"
		echo "Location: ${PATH_INFO%$endpoint}.html"
		echo
		;;
esac

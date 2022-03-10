#!/bin/sh
set -eu

export TEXTDOMAIN=turris-snapshots-web
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
	.smaller { max-width: 580px; }
	</style>
	<script src="/turris-theme/bootstrap.bundle.min.js"></script>
	<script src="/turris-theme/darkmode_head.js"></script>
	<title>$(gettext "Turris Minimal Snapshot Manager")</title>
</head>
<body class="align-middle text-center">
	<div class="container smaller d-grid mt-5">
		<picture>
			<source name="dark" srcset="/turris-theme/logo-white.svg" media="(prefers-color-scheme: dark)">
			<source name="light" srcset="/turris-theme/logo-black.svg" media="(prefers-color-scheme: light)">
			<img class="mb-3" name="img" src="/turris-theme/logo-black.svg" alt="Turris Logo" width="280">
		</picture>
		<h2>$(gettext "Minimal Snapshot Manager")</h2>
		<p>
		$(gettext "This page allows minimal management of system snapshots.")
		</p>

		<form method="get" class="text-start mt-3">

			<div class="mb-3">
				<label for="snapshot" class="form-label">$(gettext "Select snapshot")</label>
				<select class="form-select" name="num" id="snapshot" aria-label="Select snapshot" aria-describedby="snapshotHelp">
EOF
	local first="y"
	schnapps list -c | tail -n +2 | sort -rn \
		| while IFS=',' read -r number type size date description; do
			printf "<option value=\"%d\"${first:+ selected}>%s (%s at %s) [%s]</option>\n" \
				"$number" "$description" "$type" "$date" "$size"
			first=""
		done
	cat <<EOF
				</select>
				<div id="snapshotHelp" class="form-text">$(gettext "Select an existing snapshot to perform the action on.")</div>
			</div>

			<nav>
				<div class="nav nav-pills justify-content-center" id="nav-tab" role="tablist">
					<button class="nav-link active" id="nav-export-tab" data-bs-toggle="tab" data-bs-target="#nav-export" type="button" role="tab" aria-controls="nav-export" aria-selected="true">$(gettext "Export")</button>
					<button class="nav-link" id="nav-medkit-tab" data-bs-toggle="tab" data-bs-target="#nav-medkit" type="button" role="tab" aria-controls="nav-medkit" aria-selected="true">$(gettext "Medkit")</button>
					<button class="nav-link" id="nav-rollback-tab" data-bs-toggle="tab" data-bs-target="#nav-rollback" type="button" role="tab" aria-controls="nav-rollback" aria-selected="false">$(gettext "Rollback")</button>
					<button class="nav-link" id="nav-remove-tab" data-bs-toggle="tab" data-bs-target="#nav-remove" type="button" role="tab" aria-controls="nav-remove" aria-selected="false">$(gettext "Remove")</button>
				</div>
			</nav>
			<div class="tab-content mt-2" id="nav-tabContent">
				<div class="tab-pane fade show active" id="nav-export" role="tabpanel" aria-labelledby="nav-export-tab">
					<div class="d-grid">
						<div class="mb-3">
							<label for="password" class="form-label">$(gettext "Password to encrypt the snapshot with")</label>
							<input type="text" class="form-control" name="pass" id="password" aria-describedby="passwordHelp">
							<div id="passwordHelp" class="form-text">$(gettext "Password used to encrypt the exported snapshot. It is prefilled with a randomly generated one.")</div>
						</div>
						<button type="submit" formaction="./snapshot.tar.gz.enc" required="password" class="btn btn-primary">$(gettext "Export selected snapshot")</button>
						<div class="alert alert-secondary mt-5 overflow-auto">
							$(gettext "The following snippet shows how to decrypt an exported snapshot:")
							<pre class="border rounded mt-2"><code class="m-2">openssl enc -aes-256-cbc -d -md sha512 -pbkdf2 -iter 10000 -salt -in snapshot.tar.gz.enc -out snapshot.tar.gz</code></pre>
						</div>
					</div>
				</div>
				<div class="tab-pane fade" id="nav-medkit" role="tabpanel" aria-labelledby="nav-medkit-tab">
					<div class="d-grid">
						<button type="submit" formaction="./snapshot.tar.gz" class="btn btn-primary">$(gettext "Export selected snapshot for use as Medkit")</button>
					</div>
				</div>
				<div class="tab-pane fade" id="nav-rollback" role="tabpanel" aria-labelledby="nav-rollback-tab">
					<div class="d-grid">
					<button type="submit" formaction="./snapshot/rollback" class="btn btn-warning">$(gettext "Roll back to the selected snapshot and reboot the router")</button>
					</div>
				</div>
				<div class="tab-pane fade" id="nav-remove" role="tabpanel" aria-labelledby="nav-remove-tab">
					<div class="d-grid">
					<button type="submit" formaction="./snapshot/delete" class="btn btn-danger">$(gettext "Remove the selected snapshot")</button>
					</div>
				</div>
			</div>

		</form>

	</div>
	<script async src="/turris-theme/darkmode_body.js"></script>
	<script>
		function generatePassword() {
			var password = '';
			var chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
			for (i = 1; i <= 16; i++) {
				var char = Math.floor(Math.random() * chars.length + 1);
				password += chars.charAt(char)
			}
			return password;
		}
		document.getElementById("password").value = generatePassword();
	</script>
</body>
</html>
EOF
}

valid_number() {
	schnapps list -c | grep -q "^$1,"
}

decode() {
	local urlnoplus="${1//+/ }"
	printf '%b' "${urlnoplus//%/\\x}"
}


number=""
export PASSWORD=""
while IFS='=' read -r key value; do
	value="$(decode "$value")"
	case "$key" in
		num)
			echo "$value" | grep -q '[0-9]\+' || continue
			number="$value"
			;;
		pass)
			PASSWORD="$value"
			;;
		# We intentionally ignore anything we do not know
	esac
done <<EOF
$(echo "$QUERY_STRING" | tr '&;' '\n')
EOF


endpoint="${PATH_INFO##*/snapshot}"
case "$endpoint" in
	.tar.gz|.tar.gz.enc)
		if [ -n "$number" ] && ! valid_number "$number"; then
			echo "Status: 400 Bad Request"
			echo
			exit 0
		fi
		filename="snapshot-${HOSTNAME:-unknown}-${number:-current}$endpoint"
		echo "Status: 200 OK"
		echo "Content-Type:application/octet-stream; name = \"$filename\""
		echo "Content-Disposition: attachment; filename = \"$filename\""
		echo
		schnapps export $number '-' | {
				if [ "$endpoint" = ".tar.gz.enc" ]; then
					openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 10000 -salt -pass env:PASSWORD
				else
					cat
				fi
			}
		;;
	/rollback)
		if [ -n "$number" ] && ! valid_number "$number"; then
			echo "Status: 400 Bad Request"
			echo
			exit 0
		fi
		schnapps rollback $number
		reboot
		;;
	/delete)
		if ! valid_number "$number"; then
			echo "Status: 400 Bad Request"
			echo
			exit 0
		fi
		schnapps delete "$number"
		;;
	s.json)
		schnapps.sh list -j
		;;
	s.csv)
		schnapps.sh list -c
		;;
	s.html)
		echo "Status: 200 OK"
		echo "Content-type: text/html"
		echo
		page
		;;
	*)
		echo "Status: 303 See Other"
		echo "Location: ${PATH_INFO%$endpoint}s.html"
		echo
		;;
esac

#!/bin/sh
set -eu

export TEXTDOMAIN=turris-snapshots-web
export TEXTDOMAINDIR=/usr/share/locale
LANGUAGE="$(uci get foris.settings.lang 2>/dev/null || echo "en")"
export LANGUAGE


page() {
	cat <<EOF
<!DOCTYPE html>
<html lang="$LANGUAGE">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <link rel="icon" type="image/png" id="light-scheme-favicon" href="" />
        <link rel="icon" type="image/png" id="dark-scheme-favicon" href="" />
        <title>$(gettext "Minimal Snapshot Manager | Turris")</title>
        <script src="/turris-theme/color-modes.js"></script>
        <link rel="stylesheet" href="/turris-theme/flatly-5.min.css" />
        <style type="text/css" media="screen">
            .smaller {
                max-width: 580px;
            }
        </style>
    </head>
    <body class="bg-body-tertiary align-middle text-center">
        <svg xmlns="http://www.w3.org/2000/svg" class="d-none">
            <symbol id="check2" viewBox="0 0 16 16">
                <path
                    d="M13.854 3.646a.5.5 0 0 1 0 .708l-7 7a.5.5 0 0 1-.708 0l-3.5-3.5a.5.5 0 1 1 .708-.708L6.5 10.293l6.646-6.647a.5.5 0 0 1 .708 0z"
                />
            </symbol>
            <symbol id="circle-half" viewBox="0 0 16 16">
                <path
                    d="M8 15A7 7 0 1 0 8 1v14zm0 1A8 8 0 1 1 8 0a8 8 0 0 1 0 16z"
                />
            </symbol>
            <symbol id="moon-stars-fill" viewBox="0 0 16 16">
                <path
                    d="M6 .278a.768.768 0 0 1 .08.858 7.208 7.208 0 0 0-.878 3.46c0 4.021 3.278 7.277 7.318 7.277.527 0 1.04-.055 1.533-.16a.787.787 0 0 1 .81.316.733.733 0 0 1-.031.893A8.349 8.349 0 0 1 8.344 16C3.734 16 0 12.286 0 7.71 0 4.266 2.114 1.312 5.124.06A.752.752 0 0 1 6 .278z"
                />
                <path
                    d="M10.794 3.148a.217.217 0 0 1 .412 0l.387 1.162c.173.518.579.924 1.097 1.097l1.162.387a.217.217 0 0 1 0 .412l-1.162.387a1.734 1.734 0 0 0-1.097 1.097l-.387 1.162a.217.217 0 0 1-.412 0l-.387-1.162A1.734 1.734 0 0 0 9.31 6.593l-1.162-.387a.217.217 0 0 1 0-.412l1.162-.387a1.734 1.734 0 0 0 1.097-1.097l.387-1.162zM13.863.099a.145.145 0 0 1 .274 0l.258.774c.115.346.386.617.732.732l.774.258a.145.145 0 0 1 0 .274l-.774.258a1.156 1.156 0 0 0-.732.732l-.258.774a.145.145 0 0 1-.274 0l-.258-.774a1.156 1.156 0 0 0-.732-.732l-.774-.258a.145.145 0 0 1 0-.274l.774-.258c.346-.115.617-.386.732-.732L13.863.1z"
                />
            </symbol>
            <symbol id="sun-fill" viewBox="0 0 16 16">
                <path
                    d="M8 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM8 0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 0zm0 13a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 13zm8-5a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2a.5.5 0 0 1 .5.5zM3 8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2A.5.5 0 0 1 3 8zm10.657-5.657a.5.5 0 0 1 0 .707l-1.414 1.415a.5.5 0 1 1-.707-.708l1.414-1.414a.5.5 0 0 1 .707 0zm-9.193 9.193a.5.5 0 0 1 0 .707L3.05 13.657a.5.5 0 0 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707 0zm9.193 2.121a.5.5 0 0 1-.707 0l-1.414-1.414a.5.5 0 0 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .707zM4.464 4.465a.5.5 0 0 1-.707 0L2.343 3.05a.5.5 0 1 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .708z"
                />
            </symbol>
            <symbol id="box-arrow-up-right" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M8.636 3.5a.5.5 0 0 0-.5-.5H1.5A1.5 1.5 0 0 0 0 4.5v10A1.5 1.5 0 0 0 1.5 16h10a1.5 1.5 0 0 0 1.5-1.5V7.864a.5.5 0 0 0-1 0V14.5a.5.5 0 0 1-.5.5h-10a.5.5 0 0 1-.5-.5v-10a.5.5 0 0 1 .5-.5h6.636a.5.5 0 0 0 .5-.5"/>
                    <path fill-rule="evenodd" d="M16 .5a.5.5 0 0 0-.5-.5h-5a.5.5 0 0 0 0 1h3.793L6.146 9.146a.5.5 0 1 0 .708.708L15 1.707V5.5a.5.5 0 0 0 1 0z"/>
            </symbol>
        </svg>
        <div
            class="dropdown position-fixed bottom-0 end-0 mb-3 me-3 bd-mode-toggle"
        >
            <button
                class="btn btn-primary py-2 dropdown-toggle d-flex align-items-center"
                id="bd-theme"
                type="button"
                aria-expanded="false"
                data-bs-toggle="dropdown"
                aria-label="$(gettext "Toggle theme (auto)")"
            >
                <svg class="bi my-1 theme-icon-active" width="1em" height="1em">
                    <use href="#circle-half"></use>
                </svg>
                <span class="visually-hidden" id="bd-theme-text">$(gettext "Toggle theme")</span>
            </button>
            <ul
                class="dropdown-menu dropdown-menu-end shadow"
                aria-labelledby="bd-theme-text"
            >
                <li>
                    <button
                        type="button"
                        class="dropdown-item d-flex align-items-center"
                        data-bs-theme-value="light"
                        aria-pressed="false"
                    >
                        <svg
                            class="bi me-2 opacity-50"
                            width="1em"
                            height="1em"
                        >
                            <use href="#sun-fill"></use>
                        </svg>
                        $(gettext "Light")
                        <svg class="bi ms-auto d-none" width="1em" height="1em">
                            <use href="#check2"></use>
                        </svg>
                    </button>
                </li>
                <li>
                    <button
                        type="button"
                        class="dropdown-item d-flex align-items-center"
                        data-bs-theme-value="dark"
                        aria-pressed="false"
                    >
                        <svg
                            class="bi me-2 opacity-50"
                            width="1em"
                            height="1em"
                        >
                            <use href="#moon-stars-fill"></use>
                        </svg>
                        $(gettext "Dark")
                        <svg class="bi ms-auto d-none" width="1em" height="1em">
                            <use href="#check2"></use>
                        </svg>
                    </button>
                </li>
                <li>
                    <button
                        type="button"
                        class="dropdown-item d-flex align-items-center active"
                        data-bs-theme-value="auto"
                        aria-pressed="true"
                    >
                        <svg
                            class="bi me-2 opacity-50"
                            width="1em"
                            height="1em"
                        >
                            <use href="#circle-half"></use>
                        </svg>
                        $(gettext "Auto")
                        <svg class="bi ms-auto d-none" width="1em" height="1em">
                            <use href="#check2"></use>
                        </svg>
                    </button>
                </li>
            </ul>
        </div>
        <div class="container smaller d-grid mt-5">
            <img
                class="align-horizontally mb-3 img-logo-black"
                name="img"
                src="/turris-theme/logo-black.svg"
                alt="$(gettext "Turris Logo")"
                width="280"
            />
            <h1 class="h2">$(gettext "Minimal Snapshot Manager")</h2>
            <p>
                $(gettext "This page allows minimal management of system snapshots.")
            </p>

            <form method="get" class="text-start">
                <div class="mb-3">
                    <label for="snapshot" class="form-label"
                        >$(gettext "Select snapshot")</label
                    >
                    <select
                        class="form-select"
                        name="num"
                        id="snapshot"
                        aria-label="Select snapshot"
                        aria-describedby="snapshotHelp"
                    >
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
                    <div id="snapshotHelp" class="form-text">
                        $(gettext "Select an existing snapshot to perform the action on.")
                    </div>
                </div>
                <!-- Nav tabs -->
                <ul
                    class="nav nav-tabs nav-fill mb-3"
                    id="nav-tab"
                    role="tablist"
                >
                    <li class="nav-item" role="presentation">
                        <button
                            class="nav-link active"
                            id="nav-export-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#nav-export"
                            type="button"
                            role="tab"
                            aria-controls="nav-export"
                            aria-selected="true"
                        >
                            $(gettext "Export")
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button
                            class="nav-link"
                            id="nav-medkit-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#nav-medkit"
                            type="button"
                            role="tab"
                            aria-controls="nav-medkit"
                            aria-selected="false"
                        >
                            $(gettext "Medkit")
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button
                            class="nav-link"
                            id="nav-rollback-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#nav-rollback"
                            type="button"
                            role="tab"
                            aria-controls="nav-rollback"
                            aria-selected="false"
                        >
                            $(gettext "Rollback")
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button
                            class="nav-link"
                            id="nav-remove-tab"
                            data-bs-toggle="tab"
                            data-bs-target="#nav-remove"
                            type="button"
                            role="tab"
                            aria-controls="nav-remove"
                            aria-selected="false"
                        >
                            $(gettext "Remove")
                        </button>
                    </li>
                </ul>
                <!-- Tab panes -->
                <div class="tab-content" id="nav-tabContent">
                    <div
                        class="tab-pane fade show active"
                        id="nav-export"
                        role="tabpanel"
                        aria-labelledby="nav-export-tab"
                        tabindex="0"
                    >
                        <div class="d-grid">
                            <div class="mb-3">
                                <label for="password" class="form-label"
                                    >$(gettext "Password to encrypt the snapshot with")</label
                                >
                                <input
                                    type="text"
                                    class="form-control"
                                    name="pass"
                                    id="password"
                                    aria-describedby="passwordHelp"
                                />
                                <div id="passwordHelp" class="form-text">
                                    $(gettext "Password used to encrypt the exported snapshot. It is prefilled with a randomly generated one.")
                                </div>
                            </div>
                            <button
                                type="submit"
                                formaction="./snapshot.tar.gz.enc"
                                required="password"
                                class="btn btn-primary mb-3"
                            >
                                $(gettext "Export selected snapshot")
                            </button>
                            <div
                                class="p-3 text-info-emphasis bg-info-subtle border border-info-subtle rounded-3 overflow-auto"
                            >
                                <p>
                                    $(gettext "The following snippet shows how to decrypt an exported snapshot:")
                                </p>
                                <pre
                                    class="border border-primary-subtle mb-0"
                                ><code>openssl enc -aes-256-cbc -d -md sha512 -pbkdf2 -iter 10000 -salt -in snapshot.tar.gz.enc -out snapshot.tar.gz</code></pre>
                            </div>
                        </div>
                    </div>
                    <div
                        class="tab-pane fade"
                        id="nav-medkit"
                        role="tabpanel"
                        aria-labelledby="nav-medkit-tab"
                        tabindex="0"
                    >
                        <div class="d-grid">
                            <button
                                type="submit"
                                formaction="./snapshot.tar.gz"
                                class="btn btn-primary"
                            >
                                $(gettext "Export selected snapshot for use as Medkit")
                            </button>
                        </div>
                    </div>
                    <div
                        class="tab-pane fade"
                        id="nav-rollback"
                        role="tabpanel"
                        aria-labelledby="nav-rollback-tab"
                        tabindex="0"
                    >
                        <div class="d-grid">
                            <button
                                type="submit"
                                formaction="./snapshot/rollback"
                                class="btn btn-warning"
                            >
                                $(gettext "Roll back to the selected snapshot and reboot the router")
                            </button>
                        </div>
                    </div>
                    <div
                        class="tab-pane fade"
                        id="nav-remove"
                        role="tabpanel"
                        aria-labelledby="nav-remove-tab"
                        tabindex="0"
                    >
                        <div class="d-grid">
                            <button
                                type="submit"
                                formaction="./snapshot/delete"
                                class="btn btn-danger"
                            >
                                $(gettext "Remove the selected snapshot")
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <script type="text/javascript">
            function generatePassword() {
                var password = "";
                var chars =
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
                for (var i = 0; i < 16; i++) {
                    var char = Math.floor(Math.random() * chars.length);
                    password += chars.charAt(char);
                }
                return password;
            }
            var passwordInput = document.getElementById("password");
            if (passwordInput) {
                passwordInput.value = generatePassword();
            }
        </script>
        <script src="/turris-theme/bootstrap.bundle.min.js"></script>
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

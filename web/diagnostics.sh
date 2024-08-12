#!/bin/sh
set -eu

export TEXTDOMAIN=turris-diagnostics-web
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
		<title>$(gettext "Diagnostics | Turris")</title>
        <script src="/turris-theme/color-modes.js"></script>
        <link rel="stylesheet" href="/turris-theme/flatly-5.min.css" />
        <style type="text/css" media="screen">
            .smaller {
                max-width: 540px;
            }
        </style>

    </head>
    <body class="bg-body-tertiary">
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
        <div class="container smaller d-grid mt-5 text-center">
            <img
                class="align-horizontally mb-3 img-logo-black"
                name="img"
                src="/turris-theme/logo-black.svg"
                alt="$(gettext "Turris Logo")"
                width="280"
            />
            <h1 class="h2">$(gettext "Diagnostics")</h2>
            <p>
                $(gettext "This page allows you to generate diagnostics report for your Turris router.")
            </p>

            <a
                class="btn btn-primary mt-3 mb-3"
                href="./diagnostics.txt.gz"
                role="button"
            >
                $(gettext "Generate and download diagnostics")
            </a>

            <div class="alert alert-warning mt-3">
                $(gettext "Make sure that download is finished before sending it to support or disconnecting from the router's network. The report is being generated during download, so it takes a considerable amount of time.")
            </div>
        </div>
        <script src="/turris-theme/bootstrap.bundle.min.js"></script>
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

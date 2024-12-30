#!/bin/sh

open_on_unix() {
    URL="$1"
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$URL" >/dev/null 2>&1
    elif command -v gnome-open >/dev/null 2>&1; then
        gnome-open "$URL" >/dev/null 2>&1
    elif command -v kde-open >/dev/null 2>&1; then
        kde-open "$URL" >/dev/null 2>&1
    elif command -v firefox >/dev/null 2>&1; then
        firefox "$URL" >/dev/null 2>&1
    elif command -v chrome >/dev/null 2>&1; then
        chrome "$URL" >/dev/null 2>&1
    elif command -v chromium >/dev/null 2>&1; then
        chromium "$URL" >/dev/null 2>&1
    elif command -v sensible-browser >/dev/null 2>&1; then
        sensible-browser "$URL" >/dev/null 2>&1
    else
        echo "Unable to open URL. Please copy and paste it into your browser: $URL"
    fi
}

open_url() {
    URL="$1"
    if [ -z "$URL" ]; then
        echo "Usage: open_url <URL>"
        return 1
    fi

    case "$(uname)" in
        Linux*|FreeBSD*|OpenBSD*|NetBSD*)
            open_on_unix "$URL"
            ;;
        Darwin*)
            if ! open "$URL" >/dev/null 2>&1; then
                echo "Unable to open URL. Please copy and paste it into your browser: $URL"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*)
            explorer "$URL" >/dev/null 2>&1
            ;;
        *)
            echo "Unsupported OS. Please open this URL manually: $URL"
            ;;
    esac
}

open_url "https://www.shellcheck.net/"
open_url "https://javagl.github.io/GLConstantsTranslator/GLConstantsTranslator.html"
open_url "https://opengl.gpuinfo.org/"

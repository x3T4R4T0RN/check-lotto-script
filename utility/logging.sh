#!/bin/bash

warn() {
	printf "⚠️  %s\n" "$1" >&2
}

success() {
	printf "🟢  %s\n" "$1" >&2
}

fail() {
	printf "⛔️  %s\n" "$1" >&2
}

log() {
	printf "📢  %s\n" "$1" >&2
}

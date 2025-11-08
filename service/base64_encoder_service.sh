#!/bin/bash

base64_encode() {
	local input="$1"
	echo -n "$input" | base64
}

# --- Base64 Decode ---
base64_decode() {
	local input="$1"
	echo -n "$input" | base64 --decode
}

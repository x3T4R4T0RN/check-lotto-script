#!/bin/bash

# -------------------------------
# Function: aes_encrypted
# -------------------------------
# - Encrypt plain text using AES-256-CBC with PBKDF2
# - Args:
#     $1 - Plain text string to encrypt
#     $2 - Encryption key (password)
# - Output: Base64-encoded AES ciphertext
# -------------------------------
aes_encrypted() {
	local string="$1"
	local key="$2"
	echo -n "$string" | openssl enc -aes-256-cbc -a -salt -pbkdf2 -pass pass:"$key"
}

# -------------------------------
# Function: aes_decrypt
# -------------------------------
# - Decrypt Base64-encoded AES-256-CBC ciphertext
# - Args:
#     $1 - Base64-encoded ciphertext string
#     $2 - Encryption key (password)
# - Output: Decrypted plain text
# -------------------------------
aes_decrypt() {
	local string="$1"
	local key="$2"
	echo -n "$string" | openssl enc -aes-256-cbc -a -d -pbkdf2 -pass pass:"$key"
}

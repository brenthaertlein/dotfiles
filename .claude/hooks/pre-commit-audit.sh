#!/usr/bin/env bash
# Pre-commit security audit hook for Claude Code
# Intercepts git commit commands and runs security checks on staged files

set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only intercept git commit commands
if [[ ! "$COMMAND" =~ git\ commit ]]; then
  exit 0
fi

REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo ".")
STAGED_FILES=$(git diff --cached --name-only 2>/dev/null || git ls-files)
ALL_FILES=$(git ls-files 2>/dev/null)

if [[ -z "$ALL_FILES" && -z "$STAGED_FILES" ]]; then
  exit 0
fi

FINDINGS=0
BLOCKERS=0

check() {
  local level="$1"
  local msg="$2"
  local result="$3"
  if [[ -n "$result" ]]; then
    echo "[$level] $msg:" >&2
    echo "$result" | head -20 >&2
    FINDINGS=$((FINDINGS + 1))
    if [[ "$level" == "BLOCK" ]]; then
      BLOCKERS=$((BLOCKERS + 1))
    fi
  fi
}

echo "=== Security Audit ===" >&2

# PII: usernames, home paths
result=$(echo "$ALL_FILES" | xargs grep -rni '/Users/\|/home/' 2>/dev/null | grep -v '.claude/' || true)
check "BLOCK" "Home directory paths found" "$result"

# PII: email addresses (except in expected places like git log output)
result=$(echo "$ALL_FILES" | xargs grep -rni '@gmail\.\|@yahoo\.\|@hotmail\.\|@outlook\.\|@proton' 2>/dev/null | grep -v '.claude/' || true)
check "BLOCK" "Personal email addresses found" "$result"

# Secrets: API keys, tokens, passwords
result=$(echo "$ALL_FILES" | xargs grep -rniE '(api[_-]?key|api[_-]?secret|access[_-]?key|secret[_-]?key)\s*[=:]' 2>/dev/null | grep -v '.claude/' || true)
check "BLOCK" "API key/secret patterns found" "$result"

# Secrets: AWS credentials
result=$(echo "$ALL_FILES" | xargs grep -rni 'AKIA\|aws_secret_access_key\|AWS_SECRET' 2>/dev/null | grep -v '.claude/' || true)
check "BLOCK" "AWS credential patterns found" "$result"

# Secrets: GCP credentials
result=$(echo "$ALL_FILES" | xargs grep -rni 'GOOGLE_APPLICATION_CREDENTIALS\|"type": "service_account"' 2>/dev/null | grep -v '.claude/' || true)
check "BLOCK" "GCP credential patterns found" "$result"

# Secrets: GitHub tokens
result=$(echo "$ALL_FILES" | xargs grep -rniE 'ghp_[a-zA-Z0-9]{36}\|gho_[a-zA-Z0-9]{36}\|github_pat_' 2>/dev/null | grep -v '.claude/' || true)
check "BLOCK" "GitHub token patterns found" "$result"

# Secrets: Private keys
result=$(echo "$ALL_FILES" | xargs grep -rni 'BEGIN.*PRIVATE\|BEGIN.*RSA' 2>/dev/null | grep -v '.claude/' || true)
check "BLOCK" "Private key material found" "$result"

# Secrets: Generic password/token assignments
result=$(echo "$ALL_FILES" | xargs grep -rniE '(password|passwd|token|secret)\s*[=:]\s*["\x27][^\s]+' 2>/dev/null | grep -v '.claude/' || true)
check "BLOCK" "Hardcoded credential assignments found" "$result"

# PII: Credit card numbers (Visa, Mastercard, Amex, Discover)
result=$(echo "$ALL_FILES" | xargs grep -rnE '\b4[0-9]{12}([0-9]{3})?\b|\b5[1-5][0-9]{14}\b|\b3[47][0-9]{13}\b|\b6(?:011|5[0-9]{2})[0-9]{12}\b' 2>/dev/null | grep -v '.claude/' || true)
check "BLOCK" "Credit card number patterns found" "$result"

# PII: Social Security Numbers (XXX-XX-XXXX and XXXXXXXXX)
result=$(echo "$ALL_FILES" | xargs grep -rnE '\b[0-9]{3}-[0-9]{2}-[0-9]{4}\b|\b[0-9]{9}\b' 2>/dev/null | grep -v '.claude/' || true)
check "BLOCK" "Social Security Number patterns found" "$result"

# Infrastructure: Real IP addresses (not 127.0.0.1 or 0.0.0.0)
result=$(echo "$ALL_FILES" | xargs grep -rnE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' 2>/dev/null | grep -v '.claude/' | grep -v '127\.0\.0\.1' | grep -v '0\.0\.0\.0' || true)
check "WARN" "IP addresses found (verify these are not internal)" "$result"

# File types: sensitive files staged
result=$(git diff --cached --name-only 2>/dev/null | grep -iE '\.(env|pem|key|p12|pfx|tfstate|tfvars)$\|credentials\.json\|kubeconfig\|id_rsa\|id_ed25519\|id_dsa' || true)
check "BLOCK" "Sensitive file types staged for commit" "$result"

if [[ $BLOCKERS -gt 0 ]]; then
  echo "" >&2
  echo "FAIL — $BLOCKERS blocking finding(s). Commit must not proceed." >&2
  exit 2
elif [[ $FINDINGS -gt 0 ]]; then
  echo "" >&2
  echo "PASS WITH WARNINGS — $FINDINGS finding(s) to review." >&2
  exit 0
else
  echo "PASS — no findings." >&2
  exit 0
fi

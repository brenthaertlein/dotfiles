---
name: security-audit
description: Comprehensive security and PII audit for public repo. Must be run before every commit.
allowed-tools: Bash, Read, Grep, Glob
---

# Security Audit

Run a comprehensive security and PII scan across all tracked and staged files in this repository. This is a **public repo** — nothing sensitive should ever be committed.

## Checks to Run

### 1. PII Scan
Search all tracked files for:
- Usernames and home directory paths (`/Users/`, `/home/`)
- Email addresses (any `@` pattern in non-URL context)
- Real names in unexpected places (expected only in git commit metadata, not in config files)
- Credit card numbers (Visa, Mastercard, Amex, Discover patterns)
- Social Security Numbers (`XXX-XX-XXXX` and 9-digit variants)

### 2. Secrets Scan
Search all tracked files for:
- API keys, tokens, secrets, passwords (literal strings and variable names)
- AWS credentials (`AWS_SECRET`, `AWS_ACCESS_KEY`, `aws_secret_access_key`)
- GCP credentials (`GOOGLE_APPLICATION_CREDENTIALS`, service account keys)
- Azure credentials (`AZURE_`, client secrets)
- GitHub tokens (`GH_TOKEN`, `GITHUB_TOKEN`, `ghp_`, `gho_`)
- Private key material (`BEGIN.*PRIVATE KEY`, `BEGIN.*RSA`, `ssh-rsa`, `ssh-ed25519` key content)
- Base64-encoded strings that look like credentials (40+ char base64 blocks)
- Generic credential patterns (`password\s*=`, `secret\s*=`, `token\s*=`)

### 3. Infrastructure Scan
Search all tracked files for:
- IP addresses (except `127.0.0.1` and `0.0.0.0`)
- Internal hostnames or domain names
- Port numbers in connection strings
- Database connection strings or URIs

### 4. File Type Check
Verify no sensitive file types are staged:
- `.env`, `.env.*` files
- `*.pem`, `*.key`, `*.p12`, `*.pfx` files
- `credentials.json`, `service-account*.json`
- `*.tfstate`, `*.tfvars` (Terraform state/variables with secrets)
- `id_rsa`, `id_ed25519`, `id_dsa` (SSH private keys)
- `*.kube/config` or `kubeconfig` files

## Output Format

For each finding, report:
```
[LEVEL] file:line — description
```

Levels:
- `[BLOCK]` — commit must not proceed (secrets, credentials, private keys)
- `[WARN]` — review required (PII, IPs, hostnames — may be intentional)
- `[OK]` — expected finding (127.0.0.1, public URLs, etc.)

## Final Verdict

End with one of:
- **PASS** — no findings, safe to commit
- **PASS WITH WARNINGS** — only `[WARN]` findings, list them for review
- **FAIL** — `[BLOCK]` findings detected, commit must not proceed until resolved

## Execution

Run these scans using `grep` across all git-tracked files (`git ls-files`). Also check `git diff --cached --name-only` for any staged files not yet tracked.

$ARGUMENTS

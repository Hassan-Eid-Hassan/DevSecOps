package main

# Do Not store secrets in ENV variables
secrets_env = [
    "passwd",
    "password",
    "pass",
    "secret",
    "key",
    "access",
    "api_key",
    "apikey",
    "token",
    "tkn"
]

deny[msg] {
    input[i].Cmd == "user"
    val := input[i].Value
    contains(lower(val[0]), "root")
    msg = sprintf("Line %d: Running as root is prohibited. Use non-root user.", [i])
}
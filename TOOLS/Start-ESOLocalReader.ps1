param(
    [int]$Port = 8777
)

$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$listener = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue | Where-Object { $_.State -eq "Listen" }
if ($listener) {
    throw "Port $Port is already in use."
}

$proc = Start-Process -FilePath "py" `
    -ArgumentList @("-m", "http.server", "$Port", "--bind", "127.0.0.1") `
    -WorkingDirectory $root `
    -PassThru `
    -WindowStyle Hidden

[pscustomobject]@{
    Url = "http://127.0.0.1:$Port/index.html"
    Pid = $proc.Id
    Root = $root.Path
}

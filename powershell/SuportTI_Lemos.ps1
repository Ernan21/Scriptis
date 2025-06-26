# Criar a senha como um objeto seguro
$SecurePass = ConvertTo-SecureString "Lemos@5634" -AsPlainText -Force

# Criar o usuário local
New-LocalUser -Name "SuportTI" `
              -FullName "TI" `
              -Description "Usuário de suporte técnico" `
              -Password $SecurePass `
              -PasswordNeverExpires:$true `
              -AccountNeverExpires:$true `
              -UserMayNotChangePassword:$true

# Nome do grupo de usuários padrão conforme idioma
$groupName = if (Get-LocalGroup -Name "Users" -ErrorAction SilentlyContinue) {
    "Users"
} elseif (Get-LocalGroup -Name "Usuários" -ErrorAction SilentlyContinue) {
    "Usuários"
} else {
    Write-Error "Grupo de usuários padrão não encontrado."
    exit
}

# Adicionar o usuário "SuportTI" ao grupo de usuários padrão
Add-LocalGroupMember -Group $groupName -Member "SuportTI"

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

# ⚠️ Fazer logout do usuário atual (encerra a sessão imediatamente)
shutdown /l /f

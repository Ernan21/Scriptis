@ECHO off
setlocal enabledelayedexpansion

REM ===================================================
REM AnyDesk Configuration Script - by [Ernando Freitas SYSAUTOMATE]
REM ===================================================
REM Coleta informações do AnyDesk, remove senhas existentes,
REM cria perfil personalizado e define nova senha.
REM ===================================================

CHCP 65001 >nul

TITLE SUPORTE SYS AUTOMATE
set wait=1
ECHO INICIANDO APLICAÇÃO %username% POR FAVOR AGUARDE ...
TIMEOUT -t %wait% /NOBREAK >NUL
REM systeminfo
:menu
	TIMEOUT -t %wait% /NOBREAK >NUL
    MODE cols=45 lines=15
    CLS
    set bar=============================================
    set data=%date%
    set hora=%time:~0,8%
    set localdir=%cd%
    ECHO %bar%
    ECHO             %data% %hora%
    ECHO %bar%
    ECHO  Computador: %computername%
    ECHO  Usuario: %username%
    ECHO  Local de trabalho: %localdir%
    ECHO %bar%
    ECHO             MENU PRINCIPAL            
    ECHO %bar%
    ECHO  1. VR Master                         
    ECHO  2. VR Concentrador                   
    ECHO  3. VR PDV ( ACESSO TESTER )           
    ECHO  4. VR PDV ( ACESSO CONFIG )          
    ECHO  5. PASTAS E PERMISSÕES
    ECHO  6. ACESSO AO SERVIDOR ( TightVNC viewer )
    ECHO  7. ATUALIZAÇÃO DE PROGRAMAS
    ECHO  0. Sair                              
    ECHO %bar%
    SET /p choice="Escolha uma opção: "

    IF %choice%==1 GOTO VRMASTER
    IF %choice%==2 GOTO VRCONCENTRADOR
    IF %choice%==3 GOTO VRPDV
    IF %choice%==4 GOTO VRPDV_TEST
    IF %choice%==5 GOTO permissoesdriversat
    IF %choice%==6 GOTO TightVNC_server
	IF %choice%==7 GOTO update_all_
    IF %choice%==0 GOTO exit_out
    CLS
    ECHO %bar%
    ECHO       Opção inválida, tente novamente.   
    ECHO %bar%
    TIMEOUT -T 2 /NOBREAK>NUL
    GOTO menu

:VRMASTER
    CLS
    MODE CON cols=150 lines=15
    ECHO ABRINDO VR MASTER ...
    java -jar \\192.168.0.100\vr\exec\vrmaster.jar
    ECHO VR MASTER ENCERRADO
    GOTO menu

:VRCONCENTRADOR
    CLS
    MODE CON cols=150 lines=15
    ECHO ABRINDO VR CONCENTRADOR ...
    java -jar \\192.168.0.100\vr\exec\VRConcentrador.jar
    ECHO VR CONCENTRADOR ENCERRADO
    GOTO menu

:VRPDV
    CLS
    MODE CON cols=150 lines=15
    ECHO Abrindo VR PDV com acesso *config*
    java -jar c:\pdv\exec\VRPDV.jar -config
	TIMEOUT -t %wait% /NOBREAK >NUL
    ECHO VR PDV ( config ) ENCERRADO
    GOTO menu

:VRPDV_TEST
    CLS
    MODE CON cols=150 lines=15
    ECHO Abrindo VR PDV com acesso *teste*
    java -jar c:\pdv\exec\VRPDV.jar -test
	TIMEOUT -t %wait% /NOBREAK >NUL
    ECHO VR PDV ( test ) ENCERRADO
    GOTO menu

REM %bar%=================================
REM - PERMISSOES DRIVER E SAT
:permissoesdriversat
    cls
    MODE CON cols=75 lines=30
    echo:
    echo %bar%======
    echo Aplicando permissoes pasta PDV ... Aguarde ...
    echo %bar%======

    cacls C:\pdv\database /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\database\*.* /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\logpdv /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\driver /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\driver\*.* /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\exec /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\exec\*.* /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\img /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\img\*.* /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\paf /E /T /C /P Todos:F REDE:F
    cacls C:\pdv\sat /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\sat\*.* /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\som /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\pdv\som\*.* /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\Windows\SysWOW64\rxtxSerial.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\Windows\System32\rxtxSerial.dll /E /T /C /P Todos:F REDE:F >nul 2>&1

    rem Permissao PDV.FDB
    cacls %userprofile%\PDV.FDB /E /T /C /P Todos:F REDE:F >nul 2>&1

    rem Permissao pasta Printers para compartilhamento
    cacls C:\Windows\System32\spool\PRINTERS /E /T /C /P Todos:F REDE:F >nul 2>&1

    rem PERMISSAO DLLS EM WINDOWS

    if exist "C:\Program Files (x86)" (
    set winpath="C:\Windows\SysWOW64"
    ) else ( set winpath="C:\Windows\System32" )	

    REM TECLADO
    cacls %winpath%\inpout.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\inpout32.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\inpoutx64.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\ftlib.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\TEC55.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\TEC_55.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\WinIo.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\Tec44Win.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\tec65_32.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\WinIo.sys /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\sk_access.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\sk_access_tcp.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\SK_keyb.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\skgina.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\Ftlib-2.dll /E /T /C /P Todos:F REDE:F >nul 2>&1

    REM SAT
    cacls %winpath%\dllsat.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\dllsat_elgin.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\BemaSAT.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\BemaSAT32.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\BemaSAT64.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\bemasat.xml /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\libsatid.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\GERSAT.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\gersat.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\SAT.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\sat.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\SATDLL.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\satdll.dll /E /T /C /P Todos:F REDE:F >nul 2>&1

    REM IMPRESSORAS
    cacls %winpath%\BemaFI32.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\mp2032.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\SiUSBXp.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\DarumaFrameWork.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\GNE_Framework.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\lebin.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\LeituraMFDBin.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\QrCode_DarumaFramework.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\WS_Framework.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\hprtio.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\HprtPrinter.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\InterfaceEpsonNF.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\InterfaceEpsonNF.jar /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\InterfaceEpsonNF.xml /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\poscheque.dat /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\SI300.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\libiconvp.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\libintlp.dll /E /T /C /P Todos:F REDE:F >nul 2>&1

    REM BIOMETRIA
    cacls %winpath%\ftrScanAPI.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\libusb0.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\NBioBSP.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\NBioBSPISO4JNI.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\NBioBSPJNI.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\NBioNFIQJNI.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\pthreadVC2.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\sgfplib.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\UFLicense.dat /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\UFScanner.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\UFScanner_IZZIX.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\VrBio.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\VrModuleDigitalPersona.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\VrModuleFutronic.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\VrModuleNitgen.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\VrModuleSecugen.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\VrModuleSuprema.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\ftrJavaScanAPI.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\ftrScanAPI.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\ftrWSQ.dll /E /T /C /P Todos:F REDE:F >nul 2>&1

    REM RXTX
    cacls %winpath%\RXTXcomm.jar /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\rxtxParallel.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %winpath%\rxtxSerial.dll /E /T /C /P Todos:F REDE:F >nul 2>&1

    REM BALANCA
    cacls %winpath%\LePeso.dll /E /T /C /P Todos:F REDE:F >nul 2>&1

    REM FIREBIRD
    set firebird_path32="C:\Program Files (x86)\Firebird"
    cacls %firebird_path32% /E /T /C /P Todos:F REDE:F >nul 2>&1

    echo:
    echo %bar%=====
    echo Aplicando permissoes pasta VR ... Aguarde ...
    echo %bar%=====
    echo:
    cacls c:\vr\nfe /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls c:\vr\nfe\certificado /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls c:\vr\nfe\certificado\*.* /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls c:\vr\vr.properties /E /T /C /P Todos:F REDE:F >nul 2>&1
    echo REDE /VR ...
    cacls c:\vr\nfe /E /T /C /P REDE:F >nul 2>&1
    cacls c:\vr\vr.properties /E /T /C /P REDE:F >nul 2>&1
    timeout 1 >nul 2>&1

    echo:
    echo %bar%=
    echo Aplicando permissoes JAVA ... Aguarde ...
    echo %bar%=
    echo:
    echo Permissoes em java/javaw/javaws .exe
    cacls %javaexec% /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %javawexec% /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %javawsexec% /E /T /C /P Todos:F REDE:F >nul 2>&1

    rem %bar%======================================
    echo Permissao JavaPath, VRPdv.jar, java.exe

    cacls %javapath_java% /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %javapath_javaw% /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls %javapath_javaws% /E /T /C /P Todos:F REDE:F >nul 2>&1

    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_java% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaw% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaws% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAEXEC% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWEXEC% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWSEXEC% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1

    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_java% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaw% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaws% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAEXEC% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWEXEC% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWSEXEC% /t REG_SZ /d "RUNASADMIN" /f >nul 2>&1

    rem -----------------------------------
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_java% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaw% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaws% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAEXEC% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWEXEC% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWSEXEC% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1

    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_java% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaw% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaws% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAEXEC% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWEXEC% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWSEXEC% /t REG_SZ /d "~RUNASADMIN" /f >nul 2>&1
    rem -----------------------------------

    rem -----------------------------------
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_java% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaw% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaws% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAEXEC% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWEXEC% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWSEXEC% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1

    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_java% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaw% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %javapath_javaws% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAEXEC% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWEXEC% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v %JAVAWSEXEC% /t REG_SZ /d "~ RUNASADMIN" /f >nul 2>&1
    rem -----------------------------------

    echo:
    echo %bar%=====================
    echo Aplicando permissoes CliSitef.ini e Dlls Sitef... Aguarde ...
    echo %bar%=====================

    if exist C:\Windows\SysWOW64 (
    cacls C:\Windows\SysWOW64\CliSiTef.ini /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\Windows\SysWOW64\CliSiTef32I.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\Windows\SysWOW64\libemv.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\Windows\SysWOW64\QREncode32.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\Windows\SysWOW64\RechargeRPC.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    ) else (
    cacls C:\Windows\System32\CliSiTef.ini /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\Windows\System32\CliSiTef32I.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\Windows\System32\libemv.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\Windows\System32\QREncode32.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    cacls C:\Windows\System32\RechargeRPC.dll /E /T /C /P Todos:F REDE:F >nul 2>&1
    )
    REM timeout 1 >nul 2>&1

    echo:
    echo =================
    echo Desabilitando UAC
    echo =================
    REG ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f >nul 2>&1

    echo:
    echo ==========================
    echo AJUSTANDO PLANO DE ENERGIA
    echo ==========================
    echo:
    echo "Ajustando desligamento ocisoso do hd para 0"
    powercfg /setacvalueindex SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0x00000000  >nul 2>&1
    echo "Ajustando suspender para 0 min"
    powercfg /setacvalueindex SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0x00000000  >nul 2>&1
    echo "Ajustando hibernar para 0 min"
    powercfg /setacvalueindex SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 9d7815a6-7ee4-497e-8888-515a05f02364 0x00000000 >nul 2>&1
    echo "Ajustando suspensao usb para desabilitado"
    powercfg /setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 000 >nul 2>&1
    echo "Ajustando energia PCIExpress para performace"
    powercfg /setacvalueindex SCHEME_CURRENT 501a4d13-42af-4429-9fd1-a8218c268e20 ee12f906-d277-404b-b6da-e5fa1a576df5 000 >nul 2>&1
    echo "Ajustando energia mínima Processador para performace"
    powercfg /setacvalueindex SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 0x00000064 >nul 2>&1
    echo "Ajustando energia máxima Processador para performace"
    powercfg /setacvalueindex SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 0x00000064 >nul 2>&1
    echo "Ajustando tempo de desligamento do monitor para 0"
    powercfg /setacvalueindex SCHEME_CURRENT 7516b95f-f776-4464-8c53-06167f40cc99 3c0bc021-c8a8-4e07-a973-6b14cbcb2b7e 0x00000000 >nul 2>&1

    powercfg -setactive SCHEME_CURRENT >nul 2>&1

    echo:
    echo:
    echo =================================
    echo PROCESSO DE PERMISSOES FINALIZADO
    echo =================================
    TIMEOUT -t %wait% /NOBREAK >NUL
goto menu

:TightVNC_server
    CLS
    MODE CON cols=10 lines=10
    ECHO ACESSANDO O SERVIDOR...
    "c:\Program Files\TightVNC\tvnviewer.exe" -host=192.168.0.100 -password=Lemos@053 -mouselocal=normal
    ECHO COMUNICAÇÃO PERDIDA
    goto menu

:update_all_
    CLS
    MODE CON cols=150 lines=15
    ECHO EM ATUALIZAÇÃO !
	winget upgrade --all -h --authentication-mode silent --allow-reboot --force --include-unknown -u
    goto menu

:exit_out
    set localdir=%cd%
    CLS
    ECHO Limpando Registros
    reg delete "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /va /f>nul 2>&1

    ECHO Criando Logs...
    TIMEOUT -t %wait% /NOBREAK >NUL

    ECHO Atualizando dados...
    echo Nome do Computador: %computername%>%localdir%
    TIMEOUT -t %wait% /NOBREAK >NUL

    ECHO Estalizando dados e conexões...
    SET "AD_PATH=C:\Program Files (x86)\AnyDesk\AnyDesk.exe"
    TIMEOUT -t %wait% /NOBREAK >NUL

    REM Verifica se o AnyDesk está instalado
    IF NOT EXIST "%AD_PATH%" (
        echo [ERRO] AnyDesk não encontrado em: "%AD_PATH%"
        exit /b 1
    )

    REM Coletando o ID do AnyDesk
    FOR /F "delims=" %%i IN ('"%AD_PATH%" --get-id') DO SET "ID=%%i"

    REM Coletando o alias do AnyDesk
    FOR /F "delims=" %%i IN ('"%AD_PATH%" --get-alias') DO SET "ALIAS=%%i"

    REM Coletando o status do AnyDesk
    FOR /F "delims=" %%i IN ('"%AD_PATH%" --get-status') DO SET "STATUS=%%i"

    REM Coletando a versão do AnyDesk
    FOR /F "delims=" %%i IN ('"%AD_PATH%" --version') DO SET "VER=%%i"

    REM =======================================
    REM Criando perfil com permissões estendidas
    REM =======================================
    SET "PROFILE_NAME=SuperUserTI"
    SET "PROFILE_PASS=Lemos@053"

    REM =======================================
    REM Definindo nova senha padrão
    REM Removendo senhas pré-configuradas
    REM =======================================
    SET "ANYDESK_PASS=lemos@123"
    "%AD_PATH%" --remove-password _default
    "%AD_PATH%" --remove-password _full_access
    "%AD_PATH%" --remove-password _screen_sharing
    "%AD_PATH%" --remove-password _unattended_access

    echo Definindo nova senha para perfil: _default
    echo !ANYDESK_PASS! | "!AD_PATH!" --set-password _default
    echo Definindo nova senha para perfil: _full_access
    echo !ANYDESK_PASS! | "!AD_PATH!" --set-password _full_access
    echo Definindo nova senha para perfil: _screen_sharing
    echo !ANYDESK_PASS! | "!AD_PATH!" --set-password _screen_sharing
    echo Definindo nova senha para perfil: _unattended_access
    echo !ANYDESK_PASS! | "!AD_PATH!" --set-password _unattended_access
	
	REM Ativando perfil para acesso master ao desktop
    FOR %%p IN (a) DO (
        echo %PROFILE_PASS% | "%AD_PATH%" --add-profile %PROFILE_NAME% +audio +input +clipboard +clipboard_files +block_input +sas +restart +file_manager +lock_desk +sysinfo +whiteboard +tcp_tunnel +vpn +user_pointer +privacy_feature +record_session
    )
	
    REM Abrindo configurações administrativas e gerais do AnyDesk
    "%AD_PATH%" --settings:alias
	TIMEOUT -t %wait% /NOBREAK >NUL
    echo !ANYDESK_PASS! | !AD_PATH! !ID! --with-password --plain
    echo !PROFILE_PASS! | !AD_PATH! !ID! --with-password --plain
    echo Configuração do AnyDesk concluída com sucesso.
    ECHO Saindo...
    TIMEOUT -t %wait% /NOBREAK >NUL
    exit

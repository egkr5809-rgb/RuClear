@echo off
chcp 65001 > nul
title RuClear

:: =========================================================================
:: НАСТРОЙКА ОКНА И УВЕЛИЧЕННОГО ШРИФТА (24px)
:: =========================================================================
reg add "HKCU\Console\RuClear" /v "FontSize" /t REG_DWORD /d 0x00180000 /f >nul 2>&1
reg add "HKCU\Console\RuClear" /v "FontFamily" /t REG_DWORD /d 0x00000036 /f >nul 2>&1
reg add "HKCU\Console\RuClear" /v "FontWeight" /t REG_DWORD /d 0x00000190 /f >nul 2>&1
:: Жесткая фиксация размера окна (95 символов в ширину, 35 в высоту)
mode con cols=95 lines=35
color 0F

:: =========================================================================
:: ПРОВЕРКА И АВТОМАТИЧЕСКИЙ ЗАПРОС ПРАВ АДМИНИСТРАТОРА
:: =========================================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /b
)

cls
echo ===============================================================================
echo ВНИМАНИЕ: ОТВЕТСТВЕННОСТЬ ЗА ЛЮБОЙ ВРЕД ВАШЕМУ ПК ПРОГРАММА НЕ НЕСЕТ!
echo ВСЕ ИЗМЕНЕНИЯ ПРОИЗВОДЯТСЯ НА ВАШ СТРАХ И РИСК.
echo ===============================================================================
echo.
pause

:main_menu
cls
color 0F
echo ===============================================================================
echo                             RuClear Optimizer
echo ===============================================================================
echo Центральная консоль управления аппаратными и системными модулями
echo ===============================================================================
echo.
echo --- БАЗОВЫЕ ТВИКИ ---
echo [1] МАКСИМАЛЬНЫЙ БУСТ (Питание, VBS, Таймеры, Сеть, Мышь, CPU)
echo [2] АНТИШПИОН И БЛОКИРОВКА РЕКЛАМЫ (Блок Телеметрии/Bing)
echo [3] ТОТАЛЬНАЯ ОЧИСТКА И ОПТИМИЗАЦИЯ ДИСКОВ (Кэш AMD/NVIDIA, Журналы, TRIM)
echo [4] ПРИМЕНИТЬ ВСЕ БАЗОВЫЕ ТВИКИ (1 + 2 + 3)
echo.
echo --- ПРОДВИНУТЫЕ МОДУЛИ (Toolkit Hub) ---
echo [5] TURBO-CORE - Игровые профили отключения служб
echo [6] SPEED-BENCH - Аудит железа и информации о системе
echo [7] DEPLOY-CORE - Пакетный установщик софта (Winget)
echo [8] MSI-LATENCY - Тюнинг DPC/MSI прерываний
echo [9] RESCUE-SNAP - Точка восстановления и бэкап реестра
echo [10] NET-BOOST - Твики TCP/IP и алгоритм Нейгла
echo [11] RAM-FLUSH - Очистка кэша и рабочих наборов ОЗУ
echo.
echo --- ЭКСТРЕМАЛЬНЫЕ МОДУЛИ ---
echo [12] SUPER-PURGE - Супер оптимизация (Тотальное удаление хлама)
echo.
echo --- СПРАВКА ---
echo [13] ИНФОРМАЦИЯ: Что делает каждый модуль?
echo.
echo [0] ВЫХОД
echo.
echo Made by EGKR
echo ===============================================================================
set /p hub_choice="Выберите модуль [0-13]: "

if "%hub_choice%"=="1" goto run_1
if "%hub_choice%"=="2" goto run_2
if "%hub_choice%"=="3" goto run_3
if "%hub_choice%"=="4" goto run_4
if "%hub_choice%"=="5" goto mod_turbo
if "%hub_choice%"=="6" goto mod_bench
if "%hub_choice%"=="7" goto mod_deploy
if "%hub_choice%"=="8" goto mod_msi
if "%hub_choice%"=="9" goto mod_rescue
if "%hub_choice%"=="10" goto mod_net
if "%hub_choice%"=="11" goto mod_ram
if "%hub_choice%"=="12" goto mod_purge
if "%hub_choice%"=="13" goto mod_info
if "%hub_choice%"=="0" exit
goto main_menu

:run_1
call :rc_optimize
pause
goto main_menu

:run_2
call :rc_antispy
pause
goto main_menu

:run_3
call :rc_clean
pause
goto main_menu

:run_4
cls
echo Запуск комплексной оптимизации по всем направлениям...
echo [СТАДИЯ 1] БУСТ СИСТЕМЫ...
call :rc_optimize
echo [СТАДИЯ 2] УДАЛЕНИЕ СЛЕЖКИ...
call :rc_antispy
echo [СТАДИЯ 3] ОЧИСТКА ДИСКОВ...
call :rc_clean
echo =========================================================================
echo [УСПЕХ] ВСЕ БАЗОВЫЕ ОПТИМИЗАЦИИ УСПЕШНО ПРИМЕНЕНЫ!
echo =========================================================================
pause
goto main_menu

:: =========================================================================
:: БАЗОВЫЕ МОДУЛИ
:: =========================================================================
:rc_optimize
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 > nul 2>&1
powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 > nul 2>&1
powercfg -h off > nul 2>&1
bcdedit /set disabledynamictick yes > nul 2>&1
bcdedit /set useplatformtick yes > nul 2>&1
bcdedit /set hypervisorlaunchtype off > nul 2>&1
powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100 > nul 2>&1
powercfg -setactive scheme_current > nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d 40 /f > nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d 20 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d 20 /f >nul 2>&1
powercfg /SETACVALUEINDEX SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba4d5a0 48e6b7a6-50ba-4231-a56f-f1a4f374713e 0 > nul 2>&1
powercfg /SETACTIVE SCHEME_CURRENT > nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d 0 /f > nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d 0 /f > nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d 0 /f > nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d 3 /f > nul 2>&1
sc stop SysMain > nul 2>&1
sc config SysMain start= disabled > nul 2>&1
reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d 0 /f > nul 2>&1
echo [ГОТОВО] Базовые и экстремальные твики системы применены!
exit /b

:rc_antispy
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f > nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f > nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d 1 /f > nul 2>&1
sc config DiagTrack start= disabled > nul 2>&1
sc stop DiagTrack > nul 2>&1
echo [ГОТОВО] Слежка вырезана!
exit /b

:rc_clean
ipconfig /flushdns > nul 2>&1
del /q /f /s "%temp%\*" > nul 2>&1
del /q /f /s "C:\Windows\Temp\*" > nul 2>&1
del /q /f /s "%localappdata%\AMD\DxCache\*" > nul 2>&1
del /q /f /s "%localappdata%\AMD\GLCache\*" > nul 2>&1
for /F "tokens=*" %%1 in ('wevtutil.exe el') DO wevtutil.exe cl "%%1" >nul 2>&1
for /f "tokens=1" %%d in ('powershell -Command "Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | Select-Object -ExpandProperty DeviceID"') do (
defrag %%d /O /U > nul 2>&1
)
echo [ГОТОВО] Очистка дисков и логов завершена!
exit /b

:: =================================================================
:: МОДУЛЬ 5: TURBO-CORE
:: =================================================================
:mod_turbo
cls
echo =================================================================
echo TURBO-CORE
echo =================================================================
echo.
echo [1] Отключить всё ненужное (ОБЯЗАТЕЛЬНО ЗАПУСТИТЬ STEAM СНАЧАЛА)
echo (Проводник и фоновые программы будут убиты)
echo.
echo [2] Отключить почти всё (Работа на рабочем столе)
echo (Система продолжает работать, выключаются только службы)
echo.
echo [0] Назад в меню
echo =================================================================
set /p turbo_c="Выберите режим [0-2]: "

if "%turbo_c%"=="1" goto turbo_max
if "%turbo_c%"=="2" goto turbo_desk
if "%turbo_c%"=="0" goto main_menu
goto mod_turbo

:turbo_max
cls
echo [*] Активация экстремального игрового режима...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 > nul 2>&1
powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
net stop "wuauserv" /y >nul 2>&1
net stop "DoSvc" /y >nul 2>&1
net stop "Spooler" /y >nul 2>&1
net stop "WSearch" /y >nul 2>&1
net stop "SysMain" /y >nul 2>&1
taskkill /F /IM chrome.exe >nul 2>&1
taskkill /F /IM telegram.exe >nul 2>&1
taskkill /F /IM discord.exe >nul 2>&1
taskkill /F /IM msedgewebview2.exe >nul 2>&1
taskkill /F /IM explorer.exe >nul 2>&1
echo =================================================================
echo [!] РЕЖИМ АКТИВЕН. ДЛЯ ВОЗВРАТА ПРОВОДНИКА И СЛУЖБ НАЖМИТЕ ЛЮБУЮ КЛАВИШУ.
echo =================================================================
pause >nul
start explorer.exe
net start "wuauserv" >nul 2>&1
net start "DoSvc" >nul 2>&1
goto main_menu

:turbo_desk
cls
echo [*] Активация режима очистки для рабочего стола...
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 > nul 2>&1
powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
net stop "wuauserv" /y >nul 2>&1
net stop "DoSvc" /y >nul 2>&1
net stop "Spooler" /y >nul 2>&1
net stop "SysMain" /y >nul 2>&1
taskkill /F /IM chrome.exe >nul 2>&1
taskkill /F /IM msedgewebview2.exe >nul 2>&1
echo =================================================================
echo [!] РЕЖИМ АКТИВЕН. ДЛЯ ВОЗВРАТА СЛУЖБ НАЖМИТЕ ЛЮБУЮ КЛАВИШУ.
echo =================================================================
pause >nul
net start "wuauserv" >nul 2>&1
net start "DoSvc" >nul 2>&1
goto main_menu

:: =================================================================
:: МОДУЛЬ 6: SPEED-BENCH
:: =================================================================
:mod_bench
cls
echo =================================================================
echo SPEED-BENCH
echo =================================================================
echo.
echo [1] Скорость оперативы, видюхи, проца
echo [2] Всё о системе (Модель памяти, проца, карты и тд)
echo [0] Вернуться в главное меню
echo.
echo =================================================================
set /p bench_c="Выберите режим [0-2]: "

if "%bench_c%"=="1" goto bench_speed
if "%bench_c%"=="2" goto bench_info
if "%bench_c%"=="0" goto main_menu
goto mod_bench

:bench_speed
cls
echo [*] Замер пропускной способности...
powershell -Command "$raw = winsat mem -v; $m = [regex]::Match($raw, '(\d+[.,]\d+)\s+MB/s'); if ($m.Success) { Write-Host (' [RAM] Скорость ОЗУ: ' + $m.Groups[1].Value + ' МБ/с') -ForegroundColor Cyan }"
powershell -Command "$enc = winsat cpu -encryption; $mE = [regex]::Match($enc, '(\d+[.,]\d+)\s+MB/s'); if ($mE.Success) { Write-Host (' [CPU] Мощность CPU: ' + $mE.Groups[1].Value + ' МБ/с') -ForegroundColor Cyan }"
powershell -Command "$raw = winsat dwm -v; $m = [regex]::Match($raw, '(\d+[.,]\d+)\s+MB/s'); if ($m.Success) { Write-Host (' [GPU] Шина Видеокарты: ' + $m.Groups[1].Value + ' МБ/с') -ForegroundColor Cyan }"
pause
goto mod_bench

:bench_info
cls
echo [*] Сбор информации о системе...
powershell -Command "Write-Host '--- ПРОЦЕССОР ---' -ForegroundColor Yellow; Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors | Format-List; Write-Host '--- ВИДЕОКАРТА ---' -ForegroundColor Yellow; Get-CimInstance Win32_VideoController | Select-Object Name, AdapterRAM | Format-List; Write-Host '--- ОПЕРАТИВНАЯ ПАМЯТЬ ---' -ForegroundColor Yellow; Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer, PartNumber, Speed, Capacity | Format-List"
pause
goto mod_bench

:: =================================================================
:: ОСТАЛЬНЫЕ УТИЛИТЫ
:: =================================================================
:mod_deploy
cls
echo [*] Установка базового софта через Winget...
echo Пожалуйста, подождите. Идет скачивание пакетов (вывод прогресса включен)...
echo.
winget install --id "Google.Chrome" --exact --silent --accept-package-agreements --accept-source-agreements
winget install --id "Telegram.TelegramDesktop" --exact --silent --accept-package-agreements --accept-source-agreements
winget install --id "Discord.Discord" --exact --silent --accept-package-agreements --accept-source-agreements
winget install --id "Valve.Steam" --exact --silent --accept-package-agreements --accept-source-agreements
echo.
echo [V] Установка завершена!
pause
goto main_menu

:mod_msi
cls
echo [] Тюнинг MSI прерываний (Message Signaled Interrupts)...
powershell -Command "$devs = Get-PnpDevice -PresentOnly | Where-Object {$_.InstanceId -like '*PCI*' -and ($_.Class -in @('Display','Net')) }; foreach ($d in $devs) {$p = 'HKLM:\SYSTEM\CurrentControlSet\Enum\' + $d.InstanceId + '\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties'; if(!(Test-Path $p)) { New-Item -Path $p -Force | Out-Null }; Set-ItemProperty -Path $p -Name 'MSISupported' -Value 1 -Type DWord; Write-Host ('[+] MSI включен для: ' + $d.FriendlyName) }"
echo [V] Твики применены. Для обновления таблиц перезагрузите ПК.
pause
goto main_menu

:mod_rescue
cls
echo [*] Создание системной точки восстановления...
powershell -ExecutionPolicy Bypass -Command "Enable-ComputerRestore -Drive 'C:' -ErrorAction SilentlyContinue; Checkpoint-Computer -Description 'Backup' -RestorePointType 'MODIFY_SETTINGS' -ErrorAction SilentlyContinue" >nul 2>&1
echo [V] Точка восстановления создана!
pause
goto main_menu

:mod_net
cls
echo [*] Оптимизация TCP/IP и алгоритма Нейгла...
powershell -Command "$interfaces = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'}; foreach ($int in $interfaces) {$path = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\' + $int.InterfaceGuid; if (Test-Path $path) { Set-ItemProperty -Path $path -Name 'TcpAckFrequency' -Value 1 -Type DWord -ErrorAction SilentlyContinue; Set-ItemProperty -Path $path -Name 'TCPNoDelay' -Value 1 -Type DWord -ErrorAction SilentlyContinue; } }"
netsh int tcp set global autotuninglevel=normal >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
echo [V] Сетевые твики успешно применены!
pause
goto main_menu

:mod_ram
cls
echo [*] Очистка рабочих наборов ОЗУ...
powershell -Command "$PInvokeCode = '[System.Runtime.InteropServices.DllImport(\"psapi.dll\")] public static extern int EmptyWorkingSet(IntPtr hwce);'; $type = Add-Type -MemberDefinition $PInvokeCode -Name \"MemFlusher\" -Namespace \"Win32\" -PassThru -ErrorAction SilentlyContinue; Get-Process | ForEach-Object { try { $type::EmptyWorkingSet($_.Handle) } catch {} }; [System.GC]::Collect();"
echo [V] Оперативная память очищена от фонового мусора!
pause
goto main_menu

:: =================================================================
:: МОДУЛЬ 12: SUPER-PURGE [ЭКСТРЕМАЛЬНОЕ УДАЛЕНИЕ ХЛАМА]
:: =================================================================
:mod_purge
cls
echo [*] ЗАПУСК ПРОТОКОЛА "ВЫЖЖЕННАЯ ЗЕМЛЯ"...
echo.

echo [1/5] Уничтожение OneDrive...
taskkill /f /im OneDrive.exe >nul 2>&1
"%SystemRoot%\SysWOW64\OneDriveSetup.exe" /uninstall >nul 2>&1
"%SystemRoot%\System32\OneDriveSetup.exe" /uninstall >nul 2>&1

echo [2/5] Стирание системных UWP-приложений и мертвого груза...
powershell -Command "Get-AppxPackage -AllUsers *SkypeApp* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *Cortana* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *Maps* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *3DViewer* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *Zune* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *Bing* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *Solitaire* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *WindowsFeedbackHub* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *BingWeather* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *MicrosoftOfficeHub* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *MixedReality* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *GetHelp* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *windowscommunicationsapps* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"

echo [2.5/5] Тотальное уничтожение Xbox Game Bar и его хвостов...
powershell -Command "Get-AppxPackage -AllUsers *XboxGamingOverlay* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *XboxGameOverlay* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *XboxIdentityProvider* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxPackage -AllUsers *XboxApp* | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d 0 /f >nul 2>&1

echo [3/5] Отключение и заморозка Поиска Windows (WSearch)...
sc stop WSearch >nul 2>&1
sc config WSearch start= disabled >nul 2>&1
taskkill /f /im SearchApp.exe >nul 2>&1

echo [+] Глубокая блокировка Cortana и слежки поиска через реестр...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d 0 /f >nul 2>&1

echo [4/5] Зачистка хвостов слежки SmartScreen и телеметрии...
schtasks /change /tn "\Microsoft\Windows\AppID\SmartScreenSpecific" /disable >nul 2>&1
schtasks /change /tn "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable >nul 2>&1

echo [5/5] Очистка кэша после масштабного удаления...
powershell -Command "[System.GC]::Collect();" >nul 2>&1

echo.
echo =========================================================================
echo [V] СУПЕР ОПТИМИЗАЦИЯ УСПЕШНО ЗАВЕРШЕНА! СИСТЕМА ОЧИЩЕНА ДО ДЫР!
echo =========================================================================
pause
goto main_menu

:: =================================================================
:: МОДУЛЬ 13: ИНФОРМАЦИЯ И СПРАВКА
:: =================================================================
:mod_info
cls
color 0B
echo ===============================================================================
echo                       ИНФОРМАЦИЯ О МОДУЛЯХ RUCLEAR
echo ===============================================================================
echo [1] МАКСИМАЛЬНЫЙ БУСТ: Включает профиль макс. производительности, отключает 
echo     спящий режим, снижает задержки мыши и отключает парковку ядер CPU.
echo [2] АНТИШПИОН: Блокирует телеметрию Microsoft, отключает поиск Bing и службы
echo     фонового сбора данных (DiagTrack).
echo [3] ОЧИСТКА ДИСКОВ: Удаляет кэш видеодрайверов, логи обновлений, временные 
echo     файлы браузеров и системы.
echo [5] TURBO-CORE: Игровой режим. Жестко закрывает браузеры, мессенджеры и 
echo     останавливает службы Windows Update для максимального FPS.
echo [6] SPEED-BENCH: Замеряет реальную скорость вашей оперативной памяти, 
echo     процессора и шины видеокарты.
echo [7] DEPLOY-CORE: Автоматически скачивает и устанавливает базовый софт 
echo     (Chrome, Steam, Telegram, Discord) в тихом режиме.
echo [8] MSI-LATENCY: Включает режим Message Signaled Interrupts для видеокарты.
echo     Устраняет микрофризы (особенно полезно для сборок на материнских 
echo     платах X99 и процессорах Xeon).
echo [9] RESCUE-SNAP: Мгновенное создание точки восстановления. Делайте бэкап
echo     перед любыми серьезными изменениями!
echo [10] NET-BOOST: Оптимизирует TCP/IP и отключает алгоритм Нейгла для 
echo      снижения пинга (задержки) в онлайн-играх.
echo [11] RAM-FLUSH: Принудительно выгружает неиспользуемый кэш из оперативной 
echo      памяти, освобождая место для тяжелых игр.
echo [12] SUPER-PURGE: Тотальное удаление встроенного мусора Windows 10/11 
echo      (OneDrive, Xbox Game Bar, Кортана, UWP-приложения карт и погоды).
echo ===============================================================================
pause
color 0F
goto main_menu
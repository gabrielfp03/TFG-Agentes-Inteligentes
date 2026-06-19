@echo off
chcp 65001 >nul
title Panel de Control TFG - Modular
mode con cols=90 lines=28
color 0b

:menu
cls
echo ==========================================================================
echo                   PANEL DE CONTROL MAESTRO - TFG
echo ==========================================================================
echo.
echo   [1] INICIALIZAR ENTORNO (Docker + Contenedores + Navegador)
echo.
echo   [2] GESTIÓN DEL PROMPT (Subir prompt_paquita.md)
echo.
echo   [3] GESTIÓN DE BASES DE DATOS (Descargar/Subir .db)
echo.
echo   [4] REINICIAR CONTENEDORES (Refresh Langflow)
echo.
echo   [5] SALIR
echo.
echo ==========================================================================
set /p opcion="Seleccione una opción [1-5]: "

if "%opcion%"=="1" goto inicializar
if "%opcion%"=="2" goto prompt
if "%opcion%"=="3" goto submenú_bd
if "%opcion%"=="4" goto reiniciar
if "%opcion%"=="5" exit
goto menu

:inicializar
cls
echo [>] Iniciando Docker Desktop...
start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
echo Esperando a que el motor de Docker responda (45s)...
timeout /t 45 /nobreak
echo [>] Levantando infraestructura...
cd /d "C:\Users\MITAR\Documents\1. Universidad\Informatica\TFG Informática\Docker\langflow\docker_example"
docker-compose up -d
echo [>] Estabilizando sistema (15s)...
timeout /t 15 /nobreak
echo [>] Abriendo interfaz de Langflow...
start http://localhost:7860
pause
goto menu

:prompt
cls
echo [>] Subiendo prompt_paquita.md al contenedor...
docker cp "C:\Users\MITAR\Documents\1. Universidad\Informatica\TFG Informática\prompt_paquita.md" docker_example-langflow-1:/app/prompt_paquita.md
if %ERRORLEVEL% EQU 0 (echo [OK] Prompt actualizado.) else (echo [!] ERROR: Verifica que el contenedor esté corriendo.)
pause
goto menu

:submenú_bd
cls
echo ==========================================================================
echo                      GESTIÓN DE BASES DE DATOS (.db)
echo ==========================================================================
echo   [A] DESCARGAR del Contenedor a Windows
echo   [B] SUBIR de Windows al Contenedor
echo   [V] VOLVER
echo.
set /p op_bd="Elija una acción [A, B o V]: "

if /i "%op_bd%"=="A" goto bd_descargar
if /i "%op_bd%"=="B" goto bd_subir
if /i "%op_bd%"=="V" goto menu
goto submenú_bd

:bd_descargar
echo [>] Descargando archivos desde /app/inventario_pyme.db...
:: Copia el archivo del contenedor y lo guarda con los dos nombres en tu PC
docker cp docker_example-langflow-1:/app/inventario_pyme.db "C:\Users\MITAR\Documents\1. Universidad\Informatica\TFG Informática\BDs\crm_pyme.db"
docker cp docker_example-langflow-1:/app/inventario_pyme.db "C:\Users\MITAR\Documents\1. Universidad\Informatica\TFG Informática\BDs\inventario_pyme.db"
echo [OK] Archivos descargados en la carpeta BDs.
pause
goto submenú_bd

:bd_subir
echo [>] Subiendo archivos desde Windows al contenedor...
:: Aquí subimos el archivo que prefieras al destino /app/inventario_pyme.db
docker cp "C:\Users\MITAR\Documents\1. Universidad\Informatica\TFG Informática\BDs\inventario_pyme.db" docker_example-langflow-1:/app/inventario_pyme.db
echo [OK] Archivo subido correctamente al contenedor.
pause
goto submenú_bd

:reiniciar
cls
echo [>] Reiniciando contenedores...
cd /d "C:\Users\MITAR\Documents\1. Universidad\Informatica\TFG Informática\Docker\langflow\docker_example"
docker-compose restart
echo [OK] Reinicio completado.
pause
goto menu
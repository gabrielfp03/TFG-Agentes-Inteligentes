@echo off
chcp 65001 >nul
title Gestión de Bases de Datos - TFG
color 0f

:menu
cls
echo ===========================================================
echo       CENTRO DE GESTIÓN DE BASES DE DATOS (DOCKER)
echo ===========================================================
echo.
echo [1] DESCARGAR BDs (Del Contenedor --^> Windows)
echo [2] SUBIR BDs    (De Windows --^> Al Contenedor)
echo [3] SALIR
echo.
echo ===========================================================
set /p opcion="Selecciona una opción [1, 2 o 3]: "

if "%opcion%"=="1" goto descargar
if "%opcion%"=="2" goto subir
if "%opcion%"=="3" exit
goto menu

:descargar
cls
echo ===========================================================
echo DESCARGANDO BASES DE DATOS A WINDOWS...
echo ===========================================================
:: Descargar CRM
docker cp docker_example-langflow-1:/app/crm_pyme.db "C:\Users\MITAR\Documents\1. Universidad\Informatica\TFG Informática\BDs\crm_pyme.db"
:: Descargar Inventario
docker cp docker_example-langflow-1:/app/inventario_pyme.db "C:\Users\MITAR\Documents\1. Universidad\Informatica\TFG Informática\BDs\inventario_pyme.db"

echo.
echo [OK] Proceso de descarga finalizado.
pause
goto menu

:subir
cls
echo ===========================================================
echo SUBIENDO BASES DE DATOS AL CONTENEDOR...
echo ===========================================================
:: Subir CRM
docker cp "C:\Users\MITAR\Documents\1. Universidad\Informatica\TFG Informática\BDs\crm_pyme.db" docker_example-langflow-1:/app/crm_pyme.db
:: Subir Inventario
docker cp "C:\Users\MITAR\Documents\1. Universidad\Informatica\TFG Informática\BDs\inventario_pyme.db" docker_example-langflow-1:/app/inventario_pyme.db

echo.
echo [OK] Proceso de subida finalizado.
pause
goto menu
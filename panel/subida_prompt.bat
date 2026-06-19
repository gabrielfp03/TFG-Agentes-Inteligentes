@echo off
:: Configurar UTF-8 para evitar problemas con la tilde de "Informática"
chcp 65001 >nul
title Actualizar Prompt - Docker
color 7a

echo ===========================================================
echo ACTUALIZANDO PROMPT EN EL CONTENEDOR
echo ===========================================================

:: Ejecutar la copia del archivo local al contenedor
docker cp "C:\Users\MITAR\Documents\1. Universidad\Informatica\TFG Informática\prompt_paquita.md" docker_example-langflow-1:/app/prompt_paquita.md

:: Verificar si el comando anterior tuvo éxito
if %ERRORLEVEL% EQU 0 (
    echo.
    echo [OK] Archivo 'prompt_paquita.md' copiado correctamente.
    echo Ubicación: /app/ dentro del contenedor.
) else (
    echo.
    echo [ERROR] No se pudo copiar el archivo. 
    echo Asegúrate de que Docker Desktop esté abierto y el contenedor iniciado.
)

echo ===========================================================
echo.
pause
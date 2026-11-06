@echo off
setlocal
title DentalFlow - Ambiente Local
cd /d "%~dp0"
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js nao foi encontrado. Instale Node.js 22.12 ou superior.
  pause
  exit /b 1
)
echo Iniciando DentalFlow e verificando a conexao entre os servicos...
node scripts\start-system.cjs
if errorlevel 1 (
  echo.
  echo A inicializacao falhou. Consulte a mensagem acima.
  pause
  exit /b 1
)

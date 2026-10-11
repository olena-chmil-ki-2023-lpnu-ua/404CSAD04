@echo off
setlocal

cargo build
if errorlevel 1 exit /b %errorlevel%

cargo test
if errorlevel 1 exit /b %errorlevel%

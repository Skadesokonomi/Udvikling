
echo on
call "C:\Program Files\QGIS 3.22.0\bin\o4w_env.bat"
@echo on
"C:\Program Files\QGIS 3.22.0\apps\Python39\Scripts\pylupdate5.exe" %0\..%prj%\i18n\%prj%.pro
pause

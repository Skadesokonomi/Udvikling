echo on
call "C:\Program Files\QGIS 3.22.4\bin\o4w_env.bat"
@echo on
"C:\Program Files\QGIS 3.22.4\apps\Python39\Scripts\pylupdate5.exe" %0\..%prj%\i18n\%prj%.pro
pause


echo on
set qprogdir=C:\Program Files\QGIS 3.34.1
call "%qprogdir%\bin\o4w_env.bat"
call "%qprogdir%\bin\qt5_env.bat"
call "%qprogdir%\bin\py3_env.bat"
@echo on
"%qprogdir%\apps\Python39\Scripts\pylupdate5.exe" -noobsolete OS2DamageCost.pro
pause

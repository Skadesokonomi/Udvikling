echo on
set prj=eco_model_da

cd %0\..\%prj%\i18n
pause
start/wait "C:\Program Files\QGIS 3.20.3\OSGeo4W.bat" "C:\Program Files\QGIS 3.20.3\apps\Python39\Scripts\pylupdate5.exe" %prj%.pro
pause

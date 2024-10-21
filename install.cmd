@echo on
set idir=OS2DamageCost
rmdir /s /q "%appdata%\QGIS\QGIS3\profiles\default\python\plugins\%idir%"
call .\%idir%\pyrcc5x.cmd
xcopy .\%idir%\* "%appdata%\QGIS\QGIS3\profiles\default\python\plugins\%idir%" /i /e /h /f 

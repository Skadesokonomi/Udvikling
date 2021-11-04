rem
rem --- Dette script kræver at, følgende tre installationsfiler findes i samme mappe som scriptet. 
rem
rem     Installationsfil for PostgreSQL ver 13: postgresql-13.4-2-windows-x64.exe
rem 
rem     Installationsfil for PostGIS ver. 3.1: postgis_3_1_pg13.exe
rem
rem     Installationsfil for PGAdmin4.6: pgadmin4-6.1-x64.exe (https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v6.1/windows/pgadmin4-6.1-x64.exe)
rem 

rem ---- kan aendres ---
set pg_pass=ukulemy
set pg_port=5499

rem ---- resten maa ikke aendres ----
set pgs_inst=%0\..\postgresql-13.4-2-windows-x64.exe
set pgi_inst=%0\..\postgis_3_1_pg13.exe
set pga_inst=%0\..\pgadmin4-6.1-x64.exe

set pg_dir=C:\Program Files\PostgreSQL\13
%pgs_inst% --mode unattended --unattendedmodeui minimalWithDialogs --superpassword %pg_pass% --serverport %pg_port% --disable-components pgAdmin --prefix "%pg_dir%" --datadir "%pg_dir%\data" 
%pgi_inst% /S /D=%pg_dir%
%pga_inst% /VERYSILENT /NORESTART

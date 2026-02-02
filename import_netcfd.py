# --- parameters I/O ---

input_file = os.path.join('D:/projekter/tgv/envidan/Caseberegninger/Soevang - Simpel - Loesning A1/groundwater','dk1_2020_100m_phreatic_10km_616_72.nc')
db_parameters = 'postgresql://postgres:ukulemy@localhost:5433/tgv'


# --- parameter_group default extra ---

parameter_dict = {}
parameter_dict['import_schema'] ='tgv_import'
parameter_dict['import_table'] ='raadata'
parameter_dict['import_date'] = 'time'
parameter_dict['import_depth'] = 'depth to phreatic surface (negative)'
parameter_dict['import_x'] = 'X'
parameter_dict['import_y'] = 'Y'
parameter_dict['cell_size'] = 100.0


wkt = 'MultiPolygon (((727337.14333881 6163949.53417956, 727795.71684437 6164209.89600394, 728048.46844713 6164773.51362908, 728434.97546012 6164315.97788101, 728196.98307504 6163842.76046416, 728158.24012863 6163800.32771333, 727742.21468028 6163552.64959165, 727720.53707932 6163596.00479358, 727560.03058705 6163570.63738819, 727510.67945294 6163555.18633218, 727337.14333881 6163949.53417956)))'

project_name = 'Markby4'
model_name = 'Initial data'
parameter_name = 'default'
epsg_code = 25832
original = True

# ======== No changes below this line ==========

import time
import os
import csv
import xarray as xr 
from sqlalchemy import create_engine, text
from io import StringIO
from osgeo import ogr
import json

def psql_insert_copy(table, conn, keys, data_iter):
    dbapi_conn = conn.connection
    with dbapi_conn.cursor() as cur:

        s_buf = StringIO()
        writer = csv.writer(s_buf)
        writer.writerows(data_iter)
        s_buf.seek(0)

        columns = ', '.join('"{}"'.format(k) for k in keys)

        if table.schema:
            table_name = '"{}"."{}"'.format(table.schema, table.name)
        else:
            table_name = '"{}"'.format(table.name)

        sql = 'COPY {} ({}) FROM STDIN WITH CSV'.format(
            table_name, columns)
        cur.copy_expert(sql=sql, file=s_buf)


# --- program start

print ('Starting... ',time.asctime())
engine = create_engine(db_parameters)

print ('Open dataset... ',time.asctime())
ds = xr.open_dataset(input_file)

print ('Convert to Pandas dataframe... ',time.asctime())
df = ds.to_dataframe()

print ('Filter on xmin..xmax, ymin..ymax  ',time.asctime())
#--- Find envelope from wkt geometry +/- cell_size
geom = ogr.CreateGeometryFromWkt(wkt)
extent = geom.GetEnvelope()

xcol = parameter_dict['import_x']
ycol = parameter_dict['import_y']

#--- extensions from envelope +/- cell_size
xmi = extent[0] - parameter_dict['cell_size']  
xma = extent[1] + parameter_dict['cell_size']  
ymi = extent[2] - parameter_dict['cell_size']  
yma = extent[3] + parameter_dict['cell_size']  

filter = '{xcol} > {xmi} and {xcol} < {xma} and {ycol} > {ymi} and {ycol} < {yma}'.format(xcol=xcol,ycol=ycol,xmi=xmi,ymi=ymi,xma=xma,yma=yma)
dff = df.query(filter)

print ('Import data... ',time.asctime())
dff.to_sql(parameter_dict['import_table'], engine, method=psql_insert_copy,schema=parameter_dict['import_schema'],if_exists='replace')

with engine.connect() as conn:

    print ('Updating relevant parameter block to reflect the structure of the imported table... ',time.asctime())
    sql = "SELECT tgv_functions.parameter_groups_update('{}','{}',{})".format(parameter_name, json.dumps(parameter_dict),True)
    result = conn.execute(text(sql))

    print ('Creating project... ',time.asctime())
    sql = "SELECT tgv_functions.projects_create('{}','{}',{})".format(project_name, wkt, epsg_code)
    print(sql)
    result = conn.execute(text(sql))

    print ('Creating model... ',time.asctime())
    sql = "SELECT tgv_functions.models_create('{}','{}',{},'{}')".format(project_name, model_name, original, parameter_name)
    print(sql)
    result = conn.execute(text(sql))

    print ('Creating project cells... ',time.asctime())
    sql = "SELECT tgv_functions.cells_create_from_project_parameter('{}','{}')".format(project_name, parameter_name)
    result = conn.execute(text(sql))

#    print ('Importing raw data to project cells... ',time.asctime())
#    sql = "SELECT tgv_functions.cells_create_from_import('{}','{}',{},'{}','{}')".format(project_name, parameter_name)
#    result = conn.execute(text(sql))

    print ('Importing raw data til project cell_values... ',time.asctime())
    sql = "SELECT tgv_functions.cell_values_create_from_import('{}','{}')".format(project_name, model_name)
    result = conn.execute(text(sql))
    conn.commit()

print ('Ending... ',time.asctime())

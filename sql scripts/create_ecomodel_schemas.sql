

CREATE EXTENSION postgis;

DROP SCHEMA IF EXISTS {ecomodel_admin} CASCADE;
CREATE SCHEMA {ecomodel_admin};

DROP SCHEMA IF EXISTS {ecomodel_data} CASCADE;
CREATE SCHEMA {ecomodel_data};

DROP SCHEMA IF EXISTS {ecomodel_results} CASCADE;
CREATE SCHEMA {ecomodel_results};

SET SEARCH PATH {ecomodel_admin}, pg_catalog;




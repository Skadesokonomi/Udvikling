/* 
-----------------------------------------------------------------------
--   Patch 2022-02-26: Model q_building_new (2. time)
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/

SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

DELETE FROM parametre WHERE parent = 'q_building_new' OR name = 'q_building_new';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_building_new'                  , 'q_building_new', 'fid'                           , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_building_new'                  , 'q_building_new', 'geom'                          , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_building_new'        , 'q_building_new', 'skadebeloeb_nutid_kr'          , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_building_new'         , 'q_building_new', 'skadebeloeb_fremtid_kr'        , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_cellar_damage_present_q_building_new' , 'q_building_new', 'skadebeloeb_kaelder_nutid_kr'  , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_cellar_damage_future_q_building_new'  , 'q_building_new', 'skadebeloeb_kaelder_fremtid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_loss_present_q_building_new'          , 'q_building_new', 'vaerditab_nutid_kr'            , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_loss_future_q_building_new'           , 'q_building_new', 'vaerditab_fremtid_kr'          , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_building_new'                  , 'q_building_new', 'risiko_kr'                     , 'T', '', '', '', '', '', 1, 'T');

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_building_new', 'Queries', 
'
SELECT
    b.*,
    d.{f_category_t_damage} AS skade_kategori,
    d.{f_type_t_damage} AS skade_type,
	''{Skadeberegning for kælder}'' AS kaelder_beregning,
    {Værditab, skaderamte bygninger (%)}::NUMERIC(12,2) as tab_procent,
    k.{f_sqmprice_t_sqmprice}::NUMERIC(12,2) as kvm_pris_kr,
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    n.*,
    f.*,
    r.*
    FROM {t_building} b
    LEFT JOIN {t_build_usage} u on b.{f_usage_code_t_building} = u.{f_pkey_t_build_usage}
    LEFT JOIN {t_damage} d on u.{f_category_t_build_usage} = d.{f_category_t_damage} AND d.{f_type_t_damage} = ''{Skadetype}''   
    LEFT JOIN {t_sqmprice} k on (b.{f_muncode_t_building} = k.{f_muncode_t_sqmprice}),
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm,
            CASE WHEN COUNT (*) > 0 THEN d.b0 + st_area(b.{f_geom_t_building}) * (d.b1 * ln(GREATEST(MAX({f_depth_Oversvømmelsesmodel, nutid})*100.00, 1.0)) + d.b2) ELSE 0 END::NUMERIC(12,2) AS {f_damage_present_q_building_new},
            CASE WHEN COUNT (*) > 0 AND ''{Skadeberegning for kælder}'' = ''Medtages'' THEN COALESCE(b.{f_cellar_area_t_building},0.0) * d.c0 ELSE 0 END::NUMERIC(12,2) as {f_cellar_damage_present_q_building_new},
            CASE WHEN COUNT (*) > 0 THEN k.kvm_pris * st_area(b.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)}/100.0 ELSE 0 END::NUMERIC(12,2) as {f_loss_present_q_building_new}             
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm,
            CASE WHEN COUNT (*) > 0 THEN d.b0 + st_area(b.{f_geom_t_building}) * (d.b1 * ln(GREATEST(MAX({f_depth_Oversvømmelsesmodel, fremtid})*100.00, 1.0)) + d.b2) ELSE 0 END::NUMERIC(12,2) AS {f_damage_future_q_building_new},
            CASE WHEN COUNT (*) > 0 AND ''{Skadeberegning for kælder}'' = ''Medtages'' THEN COALESCE(b.{f_cellar_area_t_building},0.0) * d.c0 ELSE 0 END::NUMERIC(12,2) as {f_cellar_damage_future_q_building_new},
            CASE WHEN COUNT (*) > 0 THEN k.kvm_pris * st_area(b.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)}/100.0 ELSE 0 END::NUMERIC(12,2) as {f_loss_future_q_building_new}                
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
          ''{Medtag i risikoberegninger}'' AS risiko_beregning,
		  {Returperiode, antal år} AS retur_periode,
          ((0.219058829 * CASE
          WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN n.{f_damage_present_q_building_new} + n.{f_cellar_damage_present_q_building_new}
          WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN n.{f_loss_present_q_building_new}
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN n.{f_damage_present_q_building_new} + n.{f_cellar_damage_present_q_building_new} + n.{f_loss_present_q_building_new} 
          END + 
          0.089925625 * CASE
          WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN f.{f_damage_future_q_building_new} + f.{f_cellar_damage_future_q_building_new}
          WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN f.{f_loss_future_q_building_new}
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN f.{f_damage_future_q_building_new} + f.{f_cellar_damage_future_q_building_new} + f.{f_loss_future_q_building_new} 
          END)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_building_new},
          '''' AS omraade
    ) r
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0', 'P', '', '', '', '', 'SQL template for buildings new model ', 8, ' ');

-- Patch  2022-02-26: Model q_building_new slut --


/* 
-----------------------------------------------------------------------
--   Patch 2022-02-27: Model q_tourism_spatial_new (2. time)
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

DELETE FROM parametre WHERE parent = 'q_tourism_spatial_new' OR name = 'q_tourism_spatial_new' OR "default" = 'q_tourism_spatial_new';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Turisme, Kort - ny model'              , 'Turisme'              , ''                      , 'T', '', '', '', 'q_tourism_spatial_new', 'Sæt hak såfremt der skal beregnes økonomiske tab for overnatningssteder som anvendes til turistformål. De berørte bygninger vises geografisk på et kort.  ', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_tourism_spatial_new'          , 'q_tourism_spatial_new', 'fid'                   , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_tourism_spatial_new'          , 'q_tourism_spatial_new', 'geom'                  , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_tourism_spatial_new', 'q_tourism_spatial_new', 'skadebeloeb_nutid_kr'  , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_tourism_spatial_new' , 'q_tourism_spatial_new', 'skadebeloeb_fremtid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_tourism_spatial_new'          , 'q_tourism_spatial_new', 'risiko_kr'             , 'T', '', '', '', '', '', 1, 'T');

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_tourism_spatial_new'                 , 'Queries',
'
SELECT
    b.{f_pkey_t_building} as {f_pkey_q_tourism_spatial_new},
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_anv_kode,
    t.bbr_anv_tekst AS bbr_anv_tekst,
    t.kapacitet AS kapacitet,
    t.omkostning AS omkostninger,
    {Antal tabte døgn} AS tabte_dage,
    {Antal tabte døgn} * t.kapacitet AS tabte_overnatninger,
    st_force2d(b.{f_geom_t_building}) AS {f_geom_q_tourism_spatial_new},
    n.*,
    f.*,
    r.*
    FROM {t_building} b
    INNER JOIN {t_tourism} t  ON t.{f_pkey_t_tourism} = b.{f_usage_code_t_building},  
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm,
            CASE WHEN COUNT (*) > 0 THEN {Antal tabte døgn} * t.omkostning * t.kapacitet ELSE 0 END::NUMERIC(12,2) AS {f_damage_present_q_tourism_spatial_new}
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm,
            CASE WHEN COUNT (*) > 0 THEN {Antal tabte døgn} * t.omkostning * t.kapacitet ELSE 0 END::NUMERIC(12,2) AS {f_damage_future_q_tourism_spatial_new}
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
          ''{Medtag i risikoberegninger}'' AS risiko_beregning,
		  {Returperiode, antal år} AS retur_periode,
          ((0.219058829 * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN n.{f_damage_present_q_tourism_spatial_new} ELSE 0.0 END + 
          0.089925625   * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN f.{f_damage_future_q_tourism_spatial_new} ELSE 0.0 END)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_tourism_spatial_new},
          '''' AS omraade
    ) r
	WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
', 'P', '', '', '', '', 'SQL template for buildings new model ', 8, ' ');

-- Patch  2022-02-27: Model q_tourism_spatial_new slut --

/*
-----------------------------------------------------------------------
--   Patch 2022-03-09: Model q_infrastructure_new
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

DELETE FROM parametre WHERE parent = 'q_infrastructure_new' OR name = 'q_infrastructure_new' OR "default" = 'q_infrastructure_new';
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmet infrastruktur, ny model'  , 'Kritisk infrastruktur', ''        , 'T', '', '', '', 'q_infrastructure_new', 'Udpegning af oversvømmet kritisk infrastruktur. Den berørte infrastruktur vises geografisk på et kort.  ', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_infrastructure_new'          , 'q_infrastructure_new' , 'objectid', 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_infrastructure_new'          , 'q_infrastructure_new' , 'geom'    , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_infrastructure_new', 'Queries',
'
SELECT DISTINCT ON (o.{f_pkey_t_infrastructure}) 
    o.*,
    b.{f_pkey_t_building} AS object_id_b, 
    b.{f_muncode_t_building} AS komkode_b,
    b.{f_usage_code_t_building} AS bbr_anv_kode_b, 
    b.{f_usage_text_t_building} AS bbr_anv_tekst_b, 
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    n.*,
    f.*
    FROM {t_infrastructure} o
    LEFT JOIN {t_building} b ON st_intersects(o.{f_geom_t_infrastructure},b.{f_geom_t_building}), 
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(COALESCE (b.{f_geom_t_building},o.{f_geom_t_infrastructure}),{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)} AND st_intersects(COALESCE (b.{f_geom_t_building},o.{f_geom_t_infrastructure}),{f_geom_Oversvømmelsesmodel, nutid}) 
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(COALESCE (b.{f_geom_t_building},o.{f_geom_t_infrastructure}),{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)} AND st_intersects(COALESCE (b.{f_geom_t_building},o.{f_geom_t_infrastructure}),{f_geom_Oversvømmelsesmodel, fremtid}) 
    ) f
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
', 'P', '', '', '', '', 'SQL template for infrastructure new model ', 8, ' ');
	

DELETE FROM parametre WHERE parent = 'q_publicservice_new' OR name = 'q_publicservice_new' OR "default" = 'q_publicservice_new';
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmet offentlig service, ny model'  , 'Offentlig service', ''      , 'T', '', '', '', 'q_publicservice_new', 'Udpegning af oversvømmet kritisk infrastruktur. Den berørte infrastruktur vises geografisk på et kort.  ', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_publicservice_new'          , 'q_publicservice_new' , 'objectid', 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_publicservice_new'          , 'q_publicservice_new' , 'geom'    , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_publicservice_new', 'Queries',
'
SELECT DISTINCT ON (o.{f_pkey_t_publicservice}) 
    o.*,
    b.{f_pkey_t_building} AS object_id_b, 
    b.{f_muncode_t_building} AS komkode_b,
    b.{f_usage_code_t_building} AS bbr_anv_kode_b, 
    b.{f_usage_text_t_building} AS bbr_anv_tekst_b, 
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    n.*,
    f.*
    FROM {t_publicservice} o
    LEFT JOIN {t_building} b ON st_intersects(o.{f_geom_t_publicservice},b.{f_geom_t_building}), 
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)} AND st_intersects(COALESCE (b.{f_geom_t_building},o.{f_geom_t_publicservice}),{f_geom_Oversvømmelsesmodel, nutid}) 
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
', 'P', '', '', '', '', 'SQL template for public service new model ', 8, ' ');
	
-- Patch  2022-03-09: Model q_publicservice_new slut --


SELECT 
    b.{f_pkey_t_building} as {f_pkey_q_human_health_new},
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_anv_kode,
    b.{f_usage_text_t_building} AS bbr_anv_tekst,
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    st_multi(st_force2d(b.{f_geom_t_building}))::Geometry(Multipolygon,25832) AS {f_geom_q_human_health_new},
    n.*,
    f.*,
    h.*,
    r.*
    FROM {t_building} b,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid})))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid})))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
            COUNT(*) AS mennesker_total,
            COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 0 AND 6) AS mennesker_0_6,
            COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 7 AND 17) AS mennesker_7_17,
            COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) AS mennesker_18_70,
            COUNT(*) FILTER (WHERE {f_age_t_human_health} > 70) AS mennesker_71plus,
            CASE WHEN n.cnt_oversvoem_nutid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (138 * 301) ELSE 0 END::integer AS arbejdstid_nutid_kr,
            CASE WHEN n.cnt_oversvoem_nutid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (23  * 301) ELSE 0 END::integer AS rejsetid_nutid_kr,
            CASE WHEN n.cnt_oversvoem_nutid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (64  * 301) ELSE 0 END::integer AS sygetimer_nutid_kr, 
            CASE WHEN n.cnt_oversvoem_nutid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (26  * 301) ELSE 0 END::integer AS ferietimer_nutid_kr, 
            CASE WHEN f.cnt_oversvoem_fremtid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (138 * 301) ELSE 0 END::integer AS arbejdstid_fremtid_kr,
            CASE WHEN f.cnt_oversvoem_fremtid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (23  * 301) ELSE 0 END::integer AS rejsetid_fremtid_kr,
            CASE WHEN f.cnt_oversvoem_fremtid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (64  * 301) ELSE 0 END::integer AS sygetimer_fremtid_kr, 
            CASE WHEN f.cnt_oversvoem_fremtid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (26  * 301) ELSE 0 END::integer AS ferietimer_fremtid_kr 
        FROM {t_human_health} WHERE ST_CoveredBy({f_geom_t_human_health},b.{f_geom_t_building})
    ) h,
    LATERAL (
        SELECT
		    h.arbejdstid_nutid_kr + h.rejsetid_nutid_kr + h.sygetimer_nutid_kr + h.ferietimer_nutid_kr AS {f_damage_present_q_human_health_new},
            h.arbejdstid_fremtid_kr + h.rejsetid_fremtid_kr + h.sygetimer_fremtid_kr + h.ferietimer_fremtid_kr AS {f_damage_future_q_human_health_new},
            '{Medtag i risikoberegninger}' AS risiko_beregning,
		    {Returperiode, antal år} AS retur_periode,
            (0.219058829 * (CASE WHEN '{Medtag i risikoberegninger}' IN ('Skadebeløb','Skadebeløb og værditab') THEN 
			    h.arbejdstid_nutid_kr + h.rejsetid_nutid_kr + h.sygetimer_nutid_kr + h.ferietimer_nutid_kr ELSE 0 END) +
			0.089925625 * (CASE WHEN '{Medtag i risikoberegninger}' IN ('Skadebeløb','Skadebeløb og værditab') THEN
			    h.arbejdstid_fremtid_kr + h.rejsetid_fremtid_kr + h.sygetimer_fremtid_kr + h.ferietimer_fremtid_kr ELSE 0 END)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_human_health_new},
            '' AS omraade
    ) r
    WHERE (f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0) AND h.mennesker_total > 0


WITH ob AS (
  SELECT
    b.{f_pkey_t_building} as {f_pkey_q_human_health},
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_anv_kode,
    b.{f_usage_text_t_building} AS bbr_anv_tekst,
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    (SUM(st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_t_flood}))))::NUMERIC(12,2) AS areal_oversvoem_m2,
    (MIN(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS min_vanddybde_cm,
    (MAX(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS max_vanddybde_cm,
    (AVG(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS avg_vanddybde_cm,
    --(SUM(o.{f_depth_t_flood}*st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_t_flood}))) * 100.0 / SUM(st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_t_flood}))))::NUMERIC(12,2) AS avg_vanddybde_cm,
    st_force2d(b.{f_geom_t_building}) AS {f_geom_q_human_health}
    FROM {t_building} b
    INNER JOIN {t_flood} o on st_intersects(b.{f_geom_t_building},o.{f_geom_t_flood})
    WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}
    GROUP BY b.{f_pkey_t_building}, b.{f_muncode_t_building}, b.{f_usage_code_t_building}, b.{f_usage_text_t_building}, b.{f_geom_t_building}
),
om AS ( 
  SELECT 
    ob.{f_pkey_q_human_health},
    ob.kom_kode,
    ob.bbr_anv_kode,
    ob.bbr_anv_tekst,
	ob.areal_byg_m2,
	ob.areal_oversvoem_m2, 
	ob.min_vanddybde_cm, 
	ob.max_vanddybde_cm, 
	ob.avg_vanddybde_cm,
    ob.{f_geom_q_human_health},
    COUNT(*) as mennesker_total,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 0 AND 6) AS mennesker_0_6,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 7 AND 17) AS mennesker_7_17,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 18 AND 70) AS mennesker_18_70,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} > 70) AS mennesker_71plus,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 18 AND 70) * (138 * 301)::integer AS arbejdstid_kr,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 18 AND 70) * (23  * 301)::integer AS rejsetid_kr,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 18 AND 70) * (64  * 301)::integer AS sygetimer_kr, 
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 18 AND 70) * (26  * 301)::integer AS ferietimer_kr 
  FROM ob 
  INNER JOIN {t_human_health} m ON st_intersects (ob.{f_geom_q_human_health}, m.{f_geom_t_human_health})
  GROUP BY ob.{f_pkey_q_human_health}, ob.kom_kode, ob.bbr_anv_kode, ob.bbr_anv_tekst, ob.areal_byg_m2, ob.areal_oversvoem_m2, ob.min_vanddybde_cm, ob.max_vanddybde_cm, ob.avg_vanddybde_cm, ob.{f_geom_q_human_health}
)

SELECT 
    om.*,
    om.rejsetid_kr + om.sygetimer_kr + om.ferietimer_kr + om.arbejdstid_kr AS omkostning_kr,
	(
	CASE
	    WHEN '{Medtag i risikoberegninger}' = 'Intet (0 kr.)' THEN 0.0
	    WHEN '{Medtag i risikoberegninger}' = 'Skadebeløb' THEN om.arbejdstid_kr + om.rejsetid_kr + om.sygetimer_kr + om.ferietimer_kr
	    WHEN '{Medtag i risikoberegninger}' = 'Værditab' THEN 0.0
	    WHEN '{Medtag i risikoberegninger}' = 'Skadebeløb og værditab' THEN 0.0 + om.arbejdstid_kr + om.rejsetid_kr + om.sygetimer_kr + om.ferietimer_kr 
	END * (0.089925/{Returperiode for hændelse i fremtiden (år)} + 0.21905/{Returperiode for hændelse i dag (år)}))::NUMERIC(12,2) AS risiko_kr
FROM om






SELECT
    b.{f_pkey_t_recreative} as {f_pkey_q_recreative_new},
    st_force2d(b.{f_geom_t_recreative}) AS {f_geom_q_recreative_new},
    b.gridcode AS gridcode, 
    b.valuationk AS valuation_kr,
    st_area(b.{f_geom_t_recreative})::NUMERIC(12,2)  AS areal_org_m2,
    {Antal dage med oversvømmelse} AS oversvoemmelse_dage, 
    n.*,
    f.*,
    r.*
    FROM {t_recreative} b,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, nutid})))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm,
            CASE WHEN COUNT (*) > 0 THEN 100.0 * COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, nutid})))),0)/st_area(b.{f_geom_t_recreative}) 
                ELSE 0 END::NUMERIC(12,2) AS oversvoem_nutid_pct,
            CASE WHEN COUNT (*) > 0 THEN b.valuationk * ({Antal dage med oversvømmelse}/365.0) * COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, nutid})))),0)/st_area(b.{f_geom_t_recreative}) 
			    ELSE 0 END::NUMERIC(12,2)  AS {f_damage_present_q_recreative_new}
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, fremtid})))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm,
            CASE WHEN COUNT (*) > 0 THEN 100.0 * COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, fremtid})))),0)/st_area(b.{f_geom_t_recreative}) 
                ELSE 0 END::NUMERIC(12,2) AS oversvoem_fremtid_pct,
            CASE WHEN COUNT (*) > 0 THEN b.valuationk * ({Antal dage med oversvømmelse}/365.0) * COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, fremtid})))),0)/st_area(b.{f_geom_t_recreative}) 
			    ELSE 0 END::NUMERIC(12,2)  AS {f_damage_future_q_recreative_new}
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
          '{Medtag i risikoberegninger}' AS risiko_beregning,
		  {Returperiode, antal år} AS retur_periode,
          ((0.219058829 * CASE WHEN '{Medtag i risikoberegninger}' IN ('Skadebeløb','Skadebeløb og værditab') THEN n.{f_damage_present_q_recreative_new} ELSE 0.0 END + 
          0.089925625   * CASE WHEN '{Medtag i risikoberegninger}' IN ('Skadebeløb','Skadebeløb og værditab') THEN f.{f_damage_future_q_recreative_new} ELSE 0.0 END)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_recreative_new},
          '' AS omraade
    ) r
	WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0







INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Admin data', 'Data', '', 'G', '', '', '', '', 'Gruppe for administration af Lookup tabeller', 2, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Flood data',  'Data', '', 'G', '', '', '', '', 'Gruppe for administration af Oversvømmelses tabeller', 2, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Sector data', 'Data', '', 'G', '', '', '', '', 'Gruppe for administration af Sektor tabeller', 2, ' ');

INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood'   , 'Flood data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 1, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_2' , 'Flood data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 2, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_3' , 'Flood data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 3, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_4' , 'Flood data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 4, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_5' , 'Flood data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 5, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_6' , 'Flood data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 6, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_7' , 'Flood data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 7, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_8' , 'Flood data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 8, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_9' , 'Flood data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 9, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_10', 'Flood data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_11', 'Flood data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 11, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood'   , 't_flood'   , 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_2' , 't_flood_2' , 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_3' , 't_flood_3' , 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_4' , 't_flood_4' , 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_5' , 't_flood_5' , 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_6' , 't_flood_6' , 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_7' , 't_flood_7' , 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_8' , 't_flood_8' , 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_9' , 't_flood_9' , 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_10', 't_flood_10', 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_11', 't_flood_11', 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood'   , 't_flood'   , 'vanddybde_m', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_2' , 't_flood_2' , 'vanddybde_m', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_3' , 't_flood_3' , 'vanddybde_m', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_4' , 't_flood_4' , 'vanddybde_m', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_5' , 't_flood_5' , 'vanddybde_m', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_6' , 't_flood_6' , 'vanddybde_m', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_7' , 't_flood_7' , 'vanddybde_m', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_8' , 't_flood_8' , 'vanddybde_m', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_9' , 't_flood_9' , 'vanddybde_m', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_10', 't_flood_10', 'vanddybde_m', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_11', 't_flood_11', 'vanddybde_m', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ') ON CONFLICT (name) DO NOTHING;

UPDATE parametre SET parent = 'Admin data' WHERE name= 't_tourism';
UPDATE parametre SET parent = 'Admin data' WHERE name= 't_build_usage';
UPDATE parametre SET parent = 'Admin data' WHERE name= 't_sqmprice';
UPDATE parametre SET parent = 'Admin data' WHERE name= 't_damage';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_company';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_publicservice';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_road_traffic';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_bioscore';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_human_health';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_recreative';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_infrastructure';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_building';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_2';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_3';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_4';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_5';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_6';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_7';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_8';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_9';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_10';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_11';



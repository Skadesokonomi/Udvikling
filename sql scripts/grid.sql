-- Run once: Create grid using sql. Area is Aabenraa in EPSG:25832. Cell size is 100.0 meter. Cell table is: data.grid_xx
drop table if exists data.grid_xx;
create table data.grid_xx as
  with g as (
    select (
      st_squaregrid(100, ST_GeomFromEWKT('SRID=25832; POLYGON((525800 6100500, 529300 6100500, 529300 6096600, 525800 6096600, 525800 6100500))'))).*
    )
    select *, 0.0 AS val, 0 AS num from g;

-- Run once: Add primary key and spatial index
alter table data.grid_xx add primary key (i, j);
create index on data.grid_xx using gist (geom);


-- Run for every result table: Add weighted values from result table, here: results."Bygninger_2021_08_27_11_05_33_251", to cell table (data.grid_xx)
-- Split data from result table using cell table geometries and calculate weighted values
with cte AS (
  select
    a.i AS i,
    a.j AS j,
    sum(b.skadesbeloeb_kr * st_area(st_intersection(a.geom,b.geom_byg))/st_area(b.geom_byg)) as sum_value,
    count(*) as count_number
  from data.grid_xx a join results."Bygninger_2021_08_27_11_05_33_251" b on st_intersects (a.geom, b.geom_byg)
  group by a.i, a.j
)
-- Update cell table with weighted values
UPDATE data.grid_xx
  SET
    val = val + sum_value,
    num = num + count_number
FROM cte



WHERE data.grid_xx.i = cte.i and data.grid_xx.j = cte.j; 
select  
    a.id AS group_id,
	b.fid as byg_id,
	st_intersection(a.geom,b.geom_byg) as geom,
    b.skadesbeloeb_kr * st_area(st_intersection(a.geom,b.geom_byg))/st_area(b.geom_byg) as sum_value
	
  from data.grid3 a join results."Bygninger_2021_08_27_11_05_33_251" b on st_intersects (a.geom, b.geom_byg) and a.id = 356
  order by b.fid


drop table results.xxx;
create table results.xxx as
    with a as (
        select st_union(b.geom) as geom from data.bygninger b join data.oversvoem a on st_intersects(a.geom, b.geom) where a."Vanddybde" >= 0.3
    )
    select distinct b.fid as fid, st_force2d(b.geom) as geom from data.bygninger b join a on st_dwithin(a.geom, b.geom, 300.0) 
    except
    select distinct b.fid as fid, st_force2d(b.geom) as geom from data.bygninger b join data.oversvoem a on st_intersects(a.geom, b.geom) where a."Vanddybde" >= 0.3;
CREATE INDEX ON results.xxx USING GIST (geom);
ALTER TABLE results.xxx ADD PRIMARY KEY (fid);  

    with vb as (select st_union(b.geom) as geom from data.bygninger b join data.oversvoem a on st_intersects(a.geom, b.geom) where a."Vanddybde" >= 0.3),
	     ob as (select distinct b.fid as fid, st_force2d(b.geom) as geom from data.bygninger b join data.oversvoem a on st_intersects(a.geom, b.geom) where a."Vanddybde" >= 0.3)

    select distinct b.fid as fid, st_force2d(b.geom) as geom from data.bygninger b left join ob on (ob.fid=b.fid) join vb on st_dwithin(vb.geom, b.geom, 300.0) where ob.fid is null

    with vb as (select st_union(b.geom) as geom from data.bygninger b join data.oversvoem a on st_intersects(a.geom, b.geom) where a."Vanddybde" >= 0.3),
	     ob as (select distinct b.fid as fid, st_force2d(b.geom) as geom from data.bygninger b join data.oversvoem a on st_intersects(a.geom, b.geom) where a."Vanddybde" >= 0.3)

    select distinct b.fid as fid, st_force2d(b.geom) as geom from data.bygninger b join vb on st_dwithin(vb.geom, b.geom, 300.0) left join ob on (ob.fid=b.fid) where ob.fid is null

SELECT
  b.{f_key_building} as fid,
  MIN(b.{f_muncode_building}) AS kom_kode,
  MIN(b.{f_buildcat_building}) AS byg_type,
  st_area(MIN(b.{f_geom_building}))::NUMERIC(12,2) AS areal_byg_m2,
  MIN(k.{f_sqmprice})::NUMERIC(12,2) as kvm_pris_kr,
  {v_loss_pct}::NUMERIC(12,2) as tab_procent,
  (SUM(k.{f_sqmprice} * st_area(b.{f_geom_building})) * {v_loss_pct} / 100.0)::NUMERIC(12,2) as vaerditab_kr,
  st_force2d(MIN(b.{f_geom_building})) AS geom_byg,
  COUNT (*) AS cnt_oversvoem,
  (SUM(st_area(st_intersection(b.{f_geom_building},o.{f_geom_flood}))))::NUMERIC(12,2) AS areal_oversvoem_m2,
  (MIN(o.{f_depth}) * 100.00)::NUMERIC(12,2) AS min_vanddybde_cm,
  (MAX(o.{f_depth}) * 100.00)::NUMERIC(12,2) AS max_vanddybde_cm,
  (SUM(o.{f_depth}*st_area(st_intersection(b.{f_geom_building},o.{f_geom_flood}))) * 100.0 / SUM(st_area(st_intersection(b.{f_geom_building},o.{f_geom_flood}))))::NUMERIC(12,2) AS avg_vanddybde_cm,

  /* Skadesberegning */
  CASE MIN(b.{f_buildcat_building})
    WHEN 'Helårsbeboelse' THEN 202270.0 * LN(MAX(o.{f_depth}) * 100.00) - 128509.0
    WHEN 'Sommerhus'      THEN 168171.0 * LN(MAX(o.{f_depth}) * 100.00) - 212887.0
    WHEN 'Garage mm.'     THEN 30000.0
    WHEN 'Anneks'         THEN 30000.0                                               /* Som Garage */
    WHEN 'Erhverv'        THEN 693968.0 * LN(MAX(o.{f_depth}) * 100.00) - 440902.0
    WHEN 'Kultur'         THEN 693968.0 * LN(MAX(o.{f_depth}) * 100.00) - 440902.0 /* Som Erhverv */
    WHEN 'Forsyning'      THEN 693968.0 * LN(MAX(o.{f_depth}) * 100.00) - 440902.0 /* Som Erhverv */
    WHEN 'Offentlig'      THEN 693968.0 * LN(MAX(o.{f_depth}) * 100.00) - 440902.0 /* Som Erhverv */
    WHEN 'Ingen data'     THEN 150000.0
    WHEN 'Andet'          THEN 150000.0                                              /* Som Ingen data */
    ELSE                  0.0
  END::NUMERIC(12,2) skadesbeloeb_kr




with 
    vb as (
        select
            st_union(b.geom) as geom 
	    from data.bygninger b 
	    join data.oversvoem o 
	    on st_intersects(o.geom, b.geom) 
	    where o."Vanddybde" >= 0.3),
	
    ob as (
	    select 
		    distinct b."OBJECTID" 
		from data.bygninger b 
		join data.oversvoem o 
		on st_intersects(o.geom, b.geom) 
		where o."Vanddybde" >= 0.3)
		
SELECT
    b."OBJECTID" as fid,
    b.komkode AS kom_kode,
    b."Kategori2" AS byg_type,
    st_area(b.geom)::NUMERIC(12,2) AS areal_byg_m2,
    k.kvmpris::NUMERIC(12,2) as kvm_pris_kr,
    10.0::NUMERIC(12,2) as tab_procent,
    k.kvmpris * st_area(b.geom)) * 10.0 / 100.0)::NUMERIC(12,2) as vaerditab_kr,
    st_force2d(MIN(b.geom)) AS geom_byg,
    
    FROM data.bygninger b
	left join ob on (ob."OBJECTID"=b."OBJECTID") 
    LEFT JOIN data.kvmpris k on (b.komkode=k.komkode)
    join vb on st_dwithin(vb.geom, b.geom, 300.0) 
    where ob."OBJECTID" is null		


	    select b."OBJECTID", st_force2d(b.geom) as geom from data.bygninger b join vb on st_dwithin(vb.geom, b.geom, 300.0) left join ob on (ob."OBJECTID"=b."OBJECTID") where ob."OBJECTID" is null




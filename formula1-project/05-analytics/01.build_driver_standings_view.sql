-- Databricks notebook source
-- MAGIC %md
-- MAGIC ##### Produce driver standings

-- COMMAND ----------

CREATE OR REPLACE VIEW formula1.gold.v_driver_standing
AS
WITH drivers_session_summary
as (select r.season,
d.driver_id,
d.driver_name,
d.nationality,
count(*) as race_starts,
sum(r.points) as total_points,
COUNT_IF(r.is_wim) as number_of_wins,
count_if(r.is_podium) as number_of_podiums
 from 
formula1.gold.fact_session_results r 
join formula1.gold.dim_drivers d 
on r.driver_id = d.driver_id
group by r.season,
d.driver_id,
d.driver_name,
d.nationality
)
select season,
driver_id,
driver_name,
nationality,
rank() over (partition by season order by total_points desc , number_of_wins desc) as standings ,
race_starts,
total_points,
number_of_wins,
number_of_podiums
 from drivers_session_summary

-- COMMAND ----------

 SELECT * FROM formula1.gold.v_driver_standing where season=2025

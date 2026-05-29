-- Databricks notebook source
-- MAGIC %md
-- MAGIC ##### Produce constructor standings

-- COMMAND ----------


CREATE OR REPLACE VIEW formula1.gold.v_constructor_standing
AS
WITH constructors_session_summary
as (select r.season,
c.constructor_id,
c.constructor_name,
c.nationality,
count(*) as race_starts,
sum(r.points) as total_points,
COUNT_IF(r.is_wim) as number_of_wins,
count_if(r.is_podium) as number_of_podiums
 from 
formula1.gold.fact_session_results r 
join formula1.gold.dim_constructors c
on r.constructor_id = c.constructor_id
group by r.season,
c.constructor_id,
c.constructor_name,
c.nationality
)
select season,
constructor_id,
constructor_name,
nationality,
rank() over (partition by season order by total_points desc , number_of_wins desc) as standings ,
race_starts,
total_points,
number_of_wins,
number_of_podiums
 from constructors_session_summary;

-- COMMAND ----------

 SELECT * FROM formula1.gold.v_constructor_standing where season=2025

-- COMMAND ----------



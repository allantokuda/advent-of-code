-- psql dbname -f run.sql
-- Replace 'test' with 'input' to run actual challenge
-- Replace

-- Import CSV line to a single cell
drop table if exists rawfish;
create table rawfish (data varchar);
copy rawfish(data) from '/Users/atokuda/advent-of-code/2021/06/input';

-- Convert to rows
drop table if exists fish;
create table fish as select unnest(regexp_split_to_array(data, ',')::bigint[]) as age from rawfish;

-- Initialize empty table of zeros
drop table if exists ages;
create table ages as select generate_series(0,8) as age, 0::bigint as count;

-- Overwrite zeros with input counts
with input as (
  select age, count(age) from fish group by age
) update ages set count = input.count from input where ages.age = input.age;

select * from ages order by age;

create or replace function daystep() returns real as $$
begin
  for i in 1..256 loop
    update ages set age = age - 1;
    update ages set count = coalesce((select count from ages where age = -1),0) + count where age = 6;
    update ages set age = 8 where age = -1;
  end loop;
  return 0;
end
$$ language plpgsql;

select daystep();

select * from ages order by age;
select sum(count) from ages;
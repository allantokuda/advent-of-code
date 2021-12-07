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

create or replace function daystep(int) returns bigint as $$
begin
  for i in 1..$1 loop
    update ages set age = age - 1;
    update ages set count = count + (select count from ages where age = -1) where age = 6;
    update ages set age = 8 where age = -1;
  end loop;
  return (
    select sum(count) as part1 from ages
  );
end
$$ language plpgsql;

-- Part 1: 388419 lanternfish
select daystep(80) as part1;

-- Part 2: 1740449478328 lanternfish! :)
select daystep(256-80) as part2;
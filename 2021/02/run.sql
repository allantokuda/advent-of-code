-- psql a -f run.sql
drop table if exists commands;
create table commands (command varchar, value integer);
copy commands(command,value) from '/Users/atokuda/advent-of-code/2021/02/input' delimiter ' ';

select sum(dx) as x, sum(dy) as y, sum(dx)*sum(dy) as solution1 from (
  select
  case when command = 'forward' then value
       else 0
       end as dx,
  case when command = 'up' then -value
       when command = 'down' then value
       else 0
       end as dy
  from commands
) deltas;
-- psql a -f run.sql
drop table if exists commands;
create table commands (command varchar, value integer);
copy commands(command,value) from '/Users/atokuda/advent-of-code/2021/02/input' delimiter ' ';

-- Part 1
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

-- Part 2
select sum(dx) as x, sum(dy) as y, sum(dx)*sum(dy) as solution2 from (
  select command, value, aim,
    case when command = 'forward' then value else 0 end as dx,
    case when command = 'forward' then value * aim else 0 end as dy

  from (
    select command, value, sum(
      case when command = 'up' then -value
           when command = 'down' then value
           else 0
           end
    ) over (rows between unbounded preceding and current row) as aim from commands
  ) as aimed
) deltas;
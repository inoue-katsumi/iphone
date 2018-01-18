-- References:
--   https://www.richinfante.com/2017/3/16/reverse-engineering-the-ios-backup
--   [...]
--
-- Below 2 are sqlite db file names.
-- This can be queried from Manifest.db as I explained in my blog.
-- https://katsumiinoue.wordpress.com/2018/01/17/itunes%e3%83%90%e3%83%83%e3%82%af%e3%82%a2%e3%83%83%e3%83%97%e3%81%8b%e3%82%89iphone%e3%81%ae%e9%80%9a%e8%a9%b1%e5%b1%a5%e6%ad%b4%e3%82%92sqlite%e3%81%a7%e5%8f%96%e3%82%8a%e5%87%ba%e3%81%99/
attach "31/31bb7ba8914766d4ba40d6dfb6113c8b614be442" as ab;
attach "5a/5a4935c78a5255723f707230a451d79c540d2741" as cl;
--
select
case zoriginated when '0' then 'Incoming' when '1' then 'Outgoing' END as Direction,
cast(round(ZDURATION) as integer) as Duration, 
datetime('2001-01-01','+' || ZDATE || ' second','localtime') as Date, 
c0First||' '||c1Last||' ',cl.ZCALLRECORD.ZADDRESS as Number
--
-- TODO: 'CASE' didn't work
--case instr(c16Phone, substr(cl.ZCALLRECORD.ZADDRESS,2))
--  when not null then c0First||' '||c1Last
--       ELSE ZADDRESS END as Number
--
from cl.ZCALLRECORD left outer join ab.ABPersonFullTextSearch_content
--
-- WARNING:
--   I needed to mask 1st digit in phone number to find matches for some entries.
--   i.e.) substr(cl.ZCALLRECORD.ZADDRESS,2)
--   1st digit is '+' for international numbers for example. '0' for many Japan numbers.
--   This may generate false matches.
--
on instr(c16Phone, substr(cl.ZCALLRECORD.ZADDRESS,2))
order by 3 asc;
--
--.quit

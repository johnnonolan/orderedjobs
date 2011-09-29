DECLARE @jobs varchar(max)
DECLARE @delimiter  varchar(10)
select @delimiter = CHAR(13)+CHAR(10)
DECLARE @xml xml


select @jobs = 'a => a
b => a 
c => a
'

-- change dependantjobs into an element
select @jobs = replace(@jobs, ' => ', '<dependency>')
select @jobs = replace(@jobs, @delimiter, '</dependency>'+@delimiter)
select @jobs = '<jobs><job>'+replace(@jobs,@delimiter ,'</job><job>')+'</job></jobs>'
SELECT @xml = cast(@jobs as xml)
SELECT @xml
select @jobs

--SELECT @xml = cast(('<jobs><job>'+replace(@jobs,@delimiter ,'</job><job>')+'</job></jobs>') as xml)
--SELECT @xml
select 
  t.value('.','varchar(1)') as [jobs]
from @xml.nodes('//jobs/job') as a(t)

DECLARE @stringList AS TABLE(string varchar(max)) 
INSERT INTO @stringList
SELECT 
  t.value('.','varchar(30)')

FROM @xml.nodes('//jobs/job') as a(t)


  DECLARE @retval varchar(MAX) 
 
    SET @retval = STUFF((SELECT ',' + CAST( string AS varchar (8000)) FROM @stringList
                        FOR
                         XML PATH('')), 1, 1, '')
 
    SELECT @retval
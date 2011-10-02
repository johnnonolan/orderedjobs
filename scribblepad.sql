DECLARE @jobs varchar(max)
DECLARE @delimiter  varchar(10)
select @delimiter = CHAR(13)+CHAR(10)
DECLARE @xml xml


select @jobs = 'a => b
b => c 
c =>  
'

-- change dependantjobs into an element
select @jobs = replace(@jobs, ' => ', '<dependency>')
select @jobs = replace(@jobs, @delimiter, '</dependency>'+@delimiter)
-- then get the jobs
select @jobs = '<jobs><job>'+replace(@jobs,@delimiter ,'</job><job>')+'</job></jobs>'
SELECT @xml = cast(@jobs as xml)
--SELECT @xml
--select @jobs

--SELECT @xml = cast(('<jobs><job>'+replace(@jobs,@delimiter ,'</job><job>')+'</job></jobs>') as xml)
--SELECT @xml
select 
  jobs.job.value('.','varchar(1)') as [jobs],
  jobs.job.query('dependency').value('.','varchar(max)') as deps
from @xml.nodes('//jobs/job') as jobs(job)
where 
jobs.job.value('.','varchar(1)') <> ''
order by 2 
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
    
    
    
    for each job i need to find if there are any dependencies 
    if not i can sent them to the queue.
    if there are i need to 
    
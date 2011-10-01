SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
 
alter procedure OrderJobs
(
	@jobs varchar(max)
)

AS
BEGIN

DECLARE @delimiter  varchar(10)
select @delimiter = CHAR(13)+CHAR(10)
DECLARE @xml xml



-- change dependant jobs into an element
select @jobs = replace(@jobs, ' => ', '<dependency>')
select @jobs = replace(@jobs, @delimiter, '</dependency>'+@delimiter)
-- then get the jobs and change them
select @jobs = '<jobs><job>'+replace(@jobs,@delimiter ,'</job><job>')+'</job></jobs>'
print @jobs
-- make me xml
SELECT @xml = cast(@jobs as xml)

--select 
--  jobs.job.value('.','varchar(1)') as [jobs],
--  jobs.job.query('dependency').value('.','varchar(max)') as deps
--from @xml.nodes('//jobs/job') as jobs(job)
--where 
--jobs.job.value('.','varchar(1)') <> ''
--order by 2 

DECLARE @stringList AS TABLE(job varchar(1),deps varchar(1)) 
INSERT INTO @stringList
SELECT 
 jobs.job.value('.','varchar(1)') as [jobs],
  jobs.job.query('dependency').value('.','varchar(max)') as deps
from @xml.nodes('//jobs/job') as jobs(job)
where 
jobs.job.value('.','varchar(1)') <> ''


  DECLARE @retval varchar(MAX) 
 
    SET @retval = STUFF((SELECT ',' + CAST( job AS varchar (8000)) FROM @stringList
						order by deps 
                        FOR
                         XML PATH('')), 1, 1, '')
                         
 
    SELECT @retval

END
GO


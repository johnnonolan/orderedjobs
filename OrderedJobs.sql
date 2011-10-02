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
DECLARE @retval varchar(MAX) 

-- change dependant jobs into an element
select @jobs = replace(@jobs, ' => ', '<dependency>')
select @jobs = replace(@jobs, @delimiter, '</dependency>'+@delimiter)
-- then get the jobs and change them
select @jobs = '<jobs><job>'+replace(@jobs,@delimiter ,'</job><job>')+'</job></jobs>'
-- make me xml
SELECT @xml = cast(@jobs as xml)

DECLARE @stringList AS TABLE(job varchar(1),deps varchar(1)) 
INSERT INTO @stringList
SELECT 
 jobs.job.value('.','varchar(1)') as [jobs],
  jobs.job.query('dependency').value('.','varchar(max)') as deps
from @xml.nodes('//jobs/job') as jobs(job)
where 
jobs.job.value('.','varchar(1)') <> '';

 IF  EXISTS( SELECT 1 FROM @stringlist WHERE job = deps ) 
 BEGIN
    SELECT 'Cannot self reference you''ll go blind!';
    RETURN
 END;
 BEGIN TRY
WITH OrderedJobs (job, deps, level)
AS
(
-- Anchor member definition
    SELECT job,deps,0 as level FROM @stringlist
    UNION ALL
-- Recursive member definition
    SELECT myx.job,myx.deps,
        level + 1 
    FROM @stringlist myx
    inner join orderedjobs on
      myx.job = orderedjobs.deps

)
-- Statement that executes the CTE
    SELECT @retval = STUFF((SELECT  ',' + CAST( job AS varchar (8000)) FROM OrderedJobs
					group by job
					order by Max(level) desc, min(deps)
                       FOR
                         XML PATH('')), 1, 1, '')
                         
 END TRY
 BEGIN CATCH
    SELECT @retval = 'Circular dependencies: like sleeping with your cousin'
 END CATCH
    SELECT @retval

END
GO


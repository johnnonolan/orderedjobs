SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --aligator  => crocodile
 
 
alter procedure OrderJobs
(
	@jobs varchar(max)
)

AS
BEGIN
	DECLARE @result varchar(max)
	DECLARE @CrLf CHAR(2)
	SELECT @CrLf = CHAR(13) + CHAR(10);

    
	SELECT @result= ''

	IF (CHARINDEX('=>',@jobs) <> -1)	
	    SELECT @result=  Substring(@jobs, 1,1)

    'a => '+@CrLf+'b => '+@CrLf+'c => '
	SELECT @result 
	-- a => c
	-- b =>
	-- c =>


END
GO


DECLARE @CrLf CHAR(2)
SELECT @CrLf = CHAR(13) + CHAR(10);

--Step 1
EXEC dbo.OrderJobs '' 

--Step 2
EXEC dbo.OrderJobs 'b =>' 

--Step 3
declare @input varchar(max) = 
'a =>
b =>
c =>'

 
EXEC dbo.OrderJobs @input 
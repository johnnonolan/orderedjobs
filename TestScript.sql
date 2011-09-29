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
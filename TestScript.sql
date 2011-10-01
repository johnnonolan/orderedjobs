----Step 1
EXEC dbo.OrderJobs '' 

----Step 2
EXEC dbo.OrderJobs 'b =>' 

--Step 3
declare @input varchar(max) 
select @input = 
'a =>  
b =>   
c => 
'
EXEC dbo.OrderJobs @input 

--step 4
select @input = 
'a =>  
b => c   
c => 
'
EXEC dbo.OrderJobs @input 

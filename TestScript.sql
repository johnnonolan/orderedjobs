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

--step 5 
select @input =

'a => 
b => c
c => f
d => a
e => b
f => 
'
EXEC dbo.OrderJobs @input 

--step 6

select @input = 

'a => 
b => 
c => c
'
EXEC dbo.OrderJobs @input

--step 7
select @input = 
'a => 
b => c
c => f
d => a
e => 
f => b
'

EXEC dbo.OrderJobs @input

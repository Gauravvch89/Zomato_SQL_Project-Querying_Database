

					
					/* ###########################################   QUERYING DATABASE ZOMATOBASE   ############################################# */

Use Zomatobase

                                                       /*    A. DATA MANIPULATION LANGUAGE (DML)    */


                             
							 /* =================================== INSERT COMMAND =================================== */


-- Inserting Records/ Values in RESTAURANTS TABLE

INSERT INTO Restaurants
	(rest_id, restaurant_name, restaurant_type, avg_cost_2_people, online_order, table_booking, area, local_address, cuisines_type)
VALUES
	(999956, 'Gourmet Haven', 'Casual Dining', 600, 1, 0, 'Indiranagar', '789 MG Road', 'Italian'),
	(999972, 'Dazzling Delights', 'Fast Food', 900, 1, 1, 'Koramangala', '456 Brigade Road', 'Burger and Pizza'),
	(999989, 'Whisk & Crumb', 'Bakery', 1200, 1, 1, 'Whitefield', '123 Residency Road',  'Cakes and Cafe');

Select * From Restaurants


-- Inserting Records/ Values in RATINGS TABLE

INSERT INTO Ratings
	(rest_Id, restaurant_name, ratings_out_of_5, num_of_ratings, rating_Colour, feedback)
VALUES
	(999956, 'Gourmet Haven', 4.2, 1256,'Green', 'Very Good'), 
	(999972, 'Dazzling Delights', 3.8, 670,'Yellow', 'Good'),
	(999989, 'Whisk & Crumb', 4.8, 1890,'Dark Green', 'Excellent');

Select * From Ratings


-- Inserting Records/ Values in PHONE_NO TABLE

INSERT INTO Phone_no
	(rest_Id, restaurant_name, phone_no)
VALUES
	(999956, 'Gourmet Haven', '+91 9845009872'),
	(999972, 'Dazzling Delights', '+91 9000089765'),
	(999989, 'Whisk & Crumb', '+91 8755555500');

SELECT * FROM Phone_no


                                         /* ------------------------------------ INSERT COMMAND END ------------------------------------ */

							 
							  /* ==================================== UPDATE COMMAND =================================== */



--1. Update the phone numbers for restaurant "Madeena Hotel" to +91 8765432109.
Update Phone_no
	Set phone_no = '+91 8765432109'
	Where restaurant_name = 'Madeena Hotel'

--2. Increase the average cost for two people by 5% for all restaurants in 'Brigade Road' having ratings above 4.3 that offer online ordering.
Update Restaurants
	Set avg_cost_2_people = (R.avg_cost_2_people * 1.05)
	From Restaurants As R
	Join Ratings As Rate On R.rest_Id = Rate.rest_Id
	Where area = 'Brigade Road' and Rate.ratings_out_of_5 > 4.3 and R.online_order = 1
	
--3. Change the restaurant type for restaurant "Bhavani Chats" with rest_id = 192168 from 'Quick Bite' to 'Fast Food'.
Update Restaurants
	Set restaurant_type = 'Fast Food'
	Where rest_Id = 192168 and restaurant_name = 'Bhavani Chats';

--4. Set the table booking option to 'Yes' for restaurants in a particular area with an average rating above 4.
Update Restaurants
	Set table_booking = 1
	From Restaurants as R
	Join Ratings as Rate On R.rest_Id = Rate.rest_Id
	Where area = 'JP Nagar' and ratings_out_of_5 > 4


                                        
										/* ------------------------------------ UPDATE COMMAND END ------------------------------------ */

                                                      
													  
													   /*    B. DATA QUERY LANGUAGE (DQL)    */



							  /* ===================================== SELECT COMMANDS =================================== */
							  


-- 1. How many restaurants offer online ordering?
Select
	COUNT(*) as Offers_online_ordering
From Restaurants
Where online_order = 1


-- 2. Which restaurants have a rating of 4 or higher and more than 1000 ratings?
Select 
	restaurant_name,
	ratings_out_of_5,
	num_of_ratings
From Ratings
Where ratings_out_of_5 >= 4 And num_of_ratings > 1000
Order By
	ratings_out_of_5 Desc, num_of_ratings Desc


-- 3. Top 1 City with highest number of restaurants?
Select Top 1
	area,
	local_address,
	Count(restaurant_name) As num_resturants
From Restaurants
Group By
	area, local_address
Order By
	num_resturants Desc


-- 4. What are the top 5 cuisines with the highest number of restaurants?
Select Top 5
	cuisines_type,
	COUNT(restaurant_name) As num_resturants
From Restaurants
Group By cuisines_type
Order By num_resturants Desc


-- 5. Which restaurants in 'Brookefield' offer online ordering and have an average cost for two people less than 500?
Select
	restaurant_name,
	avg_cost_2_people
From Restaurants
Where 
	area = 'Brookefield' and online_order = 1 and avg_cost_2_people < 500
Order By avg_cost_2_people Desc


-- 6. How many restaurants have word pizza in their name.
Select 
	COUNT(*) as Restaurant_Count
From Restaurants
Where restaurant_name like '%Pizza%'


-- 7. Calculate the percentage of restaurants that offer online ordering and table booking, grouped by restaurant type.
Select 
	restaurant_type,
	COUNT(*) AS 'Total_Restaurants',
	(COUNT(Case When online_order = 1 and table_booking = 1 Then 1 END)*100 / COUNT(*)) AS Percentage
From Restaurants
Group by restaurant_type
Order by percentage Desc


-- 8. Determine the top 3 areas with the highest average ratings.
Select Top 3
	R.area,
	ROUND(AVG(Rate.ratings_out_of_5),1) AS Avg_Ratings
From Restaurants AS R
JOIN Ratings AS Rate ON R.rest_Id = Rate.rest_Id 
Group By R.area
Order By Avg_Ratings DESC


-- 9. Find the cuisine type that has the highest average cost for two people.
Select 
	cuisines_type,
	Avg(avg_cost_2_people) as AVG_Cost
From Restaurants
Group by cuisines_type
Order by AVG_Cost DESC


-- 10. Determine the percentage of restaurants that offer online ordering in each cuisine type.
Select
	cuisines_type,
	COUNT(*) AS Total_Restaurants,
	(COUNT(Case When online_order = 1 Then 1 End)*100 / Count(*)) AS percentage
From Restaurants
Group By cuisines_type
Order By percentage Desc


-- 11. Find the top 5 cuisines with the highest average cost for two people, but only consider restaurants with a rating of 4 or higher.
Select TOP 5 
	cuisines_type,
	avg_cost_2_people,
	ratings		
From Restaurants
Where ratings >= 4
Order By avg_cost_2_people DESC, ratings DESC

Select Top 5 
	R.Cuisines_type,
	AVG(R.AVG_COST_2_people) as AVG_Ratings,
	Rate.ratings_out_of_5 as Ratings
From Restaurants as R
Join Ratings as Rate On R.rest_id = Rate.rest_id
WHere ratings_out_of_5 >= 4
Group By Cuisines_type, ratings_out_of_5
Order By AVG_Ratings DESC




							  /* =====================================  JOINS COMMANDS  =================================== */		 						 


-- 1. Retrieve the names and cuisines of restaurants that have received ratings of 'Excellent' (feedback) and have an average cost for two people less than 500.

Select
	Rest.restaurant_name,
	Rest.cuisines_type,
	Rest.avg_cost_2_people,
	Rate.feedback
From Restaurants as Rest
Inner Join Ratings as Rate
On Rest.rest_Id = Rate.rest_Id
Where Feedback = 'Excellent' and avg_cost_2_people < 500
Order By avg_cost_2_people ASC


-- 2. Get the average rating for each cuisine type, considering only the restaurants that offer online ordering.

Select
	Rest.cuisines_type,
	ROUND(AVG(Rate.ratings_out_of_5),1) as Avg_Ratings
From Restaurants as Rest 
Inner Join Ratings as Rate On Rest.rest_id = Rate.rest_Id
Where online_order = 1
Group By
	Rest.cuisines_type
Order By
	Avg_ratings Desc;


-- 3. Find the names of restaurants along with their phone numbers in the 'Malleshwaram' area that offer online ordering.

Select
	R.restaurant_name,
	Phone.phone_no
From Restaurants AS R 
Full JOIN 
	Phone_no AS Phone On R.rest_Id = Phone.rest_Id
Where R.area = 'Malleshwaram';


/* 4. Which restaurants in a specific area offer online ordering and have an average cost for two people less than 800? 
Make sure the restaurants should not have words like "Average", "Not satisfactory' and "Good" in their feedback.*/

Select
	R.restaurant_name,
	R.area,
	R.avg_cost_2_people,
	Rate.feedback
From Restaurants as R
Join Ratings as Rate On R.rest_Id = Rate.rest_Id
Where R.online_order = 1 and feedback NOT IN('Average','Not Satisfactory','Good') and R.avg_cost_2_people < 800
Group by 
	R.area,
	R.restaurant_name,
	R.avg_cost_2_people,
	Rate.feedback
Order by R.avg_cost_2_people;

/* 5. Which restaurants have the highest number of ratings in the area 'Brigade Road'? 
Only retrieve the restaurants having ratings more than 4.5 along with their Phone Numbers.*/

Select
	R.restaurant_name,
	R.restaurant_type,
	Sum(Rate.num_of_ratings) AS Total_Ratings,
	Rate.ratings_out_of_5,
	Phone.phone_no
From Restaurants AS R
INNER JOIN Ratings AS Rate ON R.rest_Id = Rate.rest_Id
INNER JOIN Phone_no AS Phone ON R.rest_Id = Phone.rest_Id
Where R.area = 'Brigade Road' and
	Rate.ratings_out_of_5 > 4.5
Group By
	R.restaurant_name,
	R.restaurant_type,
	Rate.ratings_out_of_5,
	Phone.phone_no
Order by 
	Total_Ratings Desc ,
	Rate.ratings_out_of_5 Desc

					
					/* ###########################################   END QUERYING DATABASE ZOMATOBASE   ############################################# */
                                                            
															
															
														       /*****    MICROSOFT SQL SERVER 2019    *****/
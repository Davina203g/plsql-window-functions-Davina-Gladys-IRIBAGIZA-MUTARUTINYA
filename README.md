# plsql-window-functions-Davina-Gladys-IRIBAGIZA-MUTARUTINYA

Business context: Fresh Fruit Market is small fruit retail business operating through it's sales and operations department across 3 Regions of Rwanda (Kigali, Muhanga, Huye) serving customers through market stalls and retail shops, mobile vendors.

Data Challenge: The sales and operations department lacks insight into which fruits perform best by district and season, identifying valuable customers, and can not plan inventory allocation leading to waste and missed opportunities.

Expected Outcome: The analysis will help department identify top-performing fruits by region, segment customers for targeted market, optmise inventory aallocation and make data_driven decisions about expansion and product lines.

Success Criteria:

1.Top 5 products per region -> RANK():
Identify highest selling fruit in each region for each quarter to optmise inventory allocation.

2. Running monthly sales total -> SUM() Over():
   Track cumulative sales performance through out the month to monitor cashflow and seasonal trends.

3. Month-Over-Month growth -> LAG(), LEAD():
   Calculate percentage change in monthly sales compared to previous month to identify growth with patterns and declining performance.
   
4. Customer quartiles -> NTILE(4): segment customer into 4 value-based groups (high, medium-high, medium-low, low spenders) for targeted marketing strategies.

5. 3-month moving averages -> AVG(), OVER():
   Calculating rolling 3-month average sales by region to smoothen Seasonal fluctuation and identify underlying trends for inventory planning.
   

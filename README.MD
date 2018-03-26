# cs122b-winter18-team-44
----------------------
## Project 1

### Checklist:
* Created the createtable.sql
* Populated DB from movie-data.sql
* Successfully installed tomcat and opened tomcat app manager
* Built dynamic web project on eclipse and installed JDBC driver
* Setup aws ubuntu 14.04 instance
* Installed apache2, mysql, java and tomcat on instance
* Created Github Repo and push local project repository to github in master branch
* Add ignore to avoid local setting conflicts
* Modify the servlet file, output the top 20 movies' information in descending order.
* To improve user experience, make modification using css.
-------------------------
## Project 2

### Checklist:
* 1.Designed login page. For login page, achieve following functions:
  * Checked valid email and password input, which is not null and legal;
  * Achieved sign up funtion, which would add a customer in the user table;
  * If anyone typed the url to try to get to other pages, return to login and alert for login;
  * Used POST to hide the password;
* 2.Designed main movie list page. For the structure idea, we added search and browse in this page;
* 3.Implemented searching by fuzzy search by title, director, star name and direct search by year.
* 4.Implemented browsing by genres or by initial.
* 5.Implemented prev/next,  "N results per page", sort on title and year.
* 6.In main page, showed the title(hyperlinked), year, director, genreslist and starslist(hyperlinked);
* 7.For single movie page: showed title,year,director,genreslist(hyperlinked),starslist(hyperlinked);
* 8.For single star page : showed name,dob, movielist(hyperlinked)
* 9.The single movie and star page can jump to each other by clicking the hyperlinked records;
* 10.In each page above, the user can jump to "mycart" page by clicking "add to cart" or the cart button;
* 11.In mycart page, users can modify or delete the record. 
* 12.If the user choose to proceed(only when he/she has some items in the cart already),jump to checkout page;
* 13.Checked for valid payment information to finish checkout. Otherwise, jumped back.
* 14.After each successful checkout, renew the user information and record the sale in the table;
* 15.Handle exceptions. Avoid 404, 500 error pages.
* 16.Lot of effort on CSS to make the page user friendly. 
-------------------------
## Project 3

### Checklist:
* 1. Using Recaptcha in login and signup.
* 2. Set https constraints to the web application.
* 3. Use stored procedure to handle update request of the data from web
* 4. Use SAX Parsing and batch insert for increasing speed in parsing.


-------------------------
## Project 4

### Checklist:
* 1. Improve GUI by using AJAX
* 2. Complete normal search and full text search
* 3. Develop Android MyFlix App with login, search and movielist.
* 4. Implemented fuzzy search using UDF.


-------------------------
## Project 5
### Checklist:
#### *The report file "Project 5 report.docx" is located in https://github.com/UCI-Chenli-teaching/cs122b-winter18-team-44/blob/master/Other_file/Project%205%20report.docx
* 1. All log files are under https://github.com/UCI-Chenli-teaching/cs122b-winter18-team-44/tree/master/Other_file/testdata
* 2. test.py under Other_files is used to process log files to calculate the average TS and TJ. Please modify the input filename accordingly:
![](https://github.com/UCI-Chenli-teaching/cs122b-winter18-team-44/blob/master/WebContent/ex1.png)
* 3.Please also note to modify one judgement sentence from "T" to "T:" for test1_2.txt,test2_1_master.txt and test2_1_slave.txt:
![](https://github.com/UCI-Chenli-teaching/cs122b-winter18-team-44/blob/master/WebContent/ex3.png)
* 4.The console should show the TS and TJ for each query line by line and show the avg TS and TJ at bottom:
![](https://github.com/UCI-Chenli-teaching/cs122b-winter18-team-44/blob/master/WebContent/ex2.png)
* 5. We rearrange the items shown in HTML files. Please read the titles carefully and it may not be compliant with the original format:)

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
String loginUser = "root";
String loginPassword = "qwertyu";
String loginUrl = "jdbc:mysql://localhost:3306/moviedb";


String catalog = null;
String schemaPattern = null;
String tableNamePattern = null;
String columnNamePattern = null;
String[] types = null;
Connection myConn = null;
ResultSet myRs = null;
ResultSet myRs2=null;
String f =  "customers";
try {
	// 1. Get a connection to database
    myConn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);

	// 2. Get metadata
	DatabaseMetaData databaseMetaData = myConn.getMetaData();

	myRs = databaseMetaData.getColumns(catalog, schemaPattern, f, columnNamePattern);

	while (myRs.next()) {
            String s = myRs.getString("COLUMN_NAME");
		%><br>
		<%=s %>
		<%  
	}

} catch (Exception exc) {
	exc.printStackTrace();
} 
if (myRs != null) {
	myRs.close();
}

if (myConn != null) {
	myConn.close();
}

%>

</body>
</html>
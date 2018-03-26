

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;

import com.google.gson.JsonObject;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Applogin
 */

public class Applogin extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Applogin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub	
		PrintWriter out = response.getWriter();
	String userEmail = request.getParameter("email");
	String userPassword = request.getParameter("password");
	
	String loginUser = "root";
    String loginPassword = "qwertyu";
    String loginUrl = "jdbc:mysql://localhost:3306/usercc";
    
    try {
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection conn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
    Statement stmt = conn.createStatement();
    String sql = "SELECT * FROM user AS c WHERE c.email ='" + userEmail + "' AND c.password ='" + userPassword +"'";
    ResultSet rs = stmt.executeQuery(sql);
    if(rs.next()){
		JsonObject responseJsonObject = new JsonObject();
		responseJsonObject.addProperty("info", "yes");
		
		response.getWriter().write(responseJsonObject.toString());
    }
    else{
		JsonObject responseJsonObject = new JsonObject();
		responseJsonObject.addProperty("info", "no");
		
		response.getWriter().write(responseJsonObject.toString());
    }
    rs.close();
    stmt.close();
    conn.close();
    }catch(Exception e) {
    }
}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}

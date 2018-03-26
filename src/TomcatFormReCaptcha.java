
/* A servlet to display the contents of the MySQL movieDB database */

import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class TomcatFormReCaptcha extends HttpServlet
{
    public String getServletInfo()
    {
       return "Servlet connects to MySQL database and displays result of a SELECT";
    }

    // Use http GET

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
        // Output stream to STDOUT
        PrintWriter out = response.getWriter();

	String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
	String em=request.getParameter("email");
	String pwd=request.getParameter("password");
	String fun= request.getParameter("funcID");
	// Verify CAPTCHA.
	boolean valid = VerifyUtils.verify(gRecaptchaResponse);
	if (!valid) {
	    //errorString = "Captcha invalid!";
	    out.println("<HTML>" +
			"<HEAD></HEAD>\n<BODY>" +
			"<P>Recaptcha WRONG!!!! </P><br>"
			+ "<a href=\"/cs122b-winter18-team-44/login.jsp\">Return to login</a></BODY></HTML>");
	    return;
	}else {
        //sendRedirect("/a.jsp");
        response.sendRedirect("/cs122b-winter18-team-44/login.jsp?email="+em+"&password="+pwd+"&funcID="+fun+"");
    } 
	
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
	doGet(request, response);
    }
}
 
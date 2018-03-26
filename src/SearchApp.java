import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonObject;

/**
 * Servlet implementation class SearchApp
 */
public class SearchApp extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SearchApp() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

	String res = "no";
	int page =0;
	
	
	String loginUser = "root";
    String loginPassword = "qwertyu";
    String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
    
    try {
	String title = request.getParameter("title");
	ArrayList<String> token = getToken(title);
    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection conn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
    Statement stmt = conn.createStatement();
    
    
    
    String cur ="";
    int count = 0;
    for(int i = 0; i < token.size(); i++)
    {
    		 cur += "+" + token.get(i).trim() + "* ";
    		 count++;
    }
    cur=cur.trim();

    
    String sql = "SELECT movies.id,movies.title FROM movies WHERE MATCH (title) AGAINST ('" + cur + "' IN BOOLEAN MODE) or ed(title, '" + title + "')<= '" + count + "'  ";
    ResultSet rs = stmt.executeQuery(sql);
    while(rs.next()){
    	res="yes";
    	page++;
    }
    String curString = String.valueOf(page);
	JsonObject responseJsonObject = new JsonObject();
	responseJsonObject.addProperty("info", res);
	responseJsonObject.addProperty("results", curString);
	response.getWriter().write(responseJsonObject.toString());
	
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
	
	private ArrayList<String> getToken(String query) {
		ArrayList<String> tokens = new ArrayList<>();
		if(query == null || query.trim().isEmpty() || query.length() < 3) {
			return tokens;
		}
		
		tokens = new ArrayList<String>(Arrays.asList(query.trim().split(" ")));
		
		return tokens;
	}
	
	

}
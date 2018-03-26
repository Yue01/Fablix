
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.mysql.jdbc.PreparedStatement;

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

// server endpoint URL
public class Search extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	/*
	 * populate the Marvel heros and DC heros hash map.
	 * Key is hero ID. Value is hero name.
	 */
	public static HashMap<String, String> moviesMap = new HashMap<>();
	public static HashMap<String, String> starsMap = new HashMap<>();
	
	public static HashMap<String, JsonArray> queryMap = new HashMap<>();
    
    public Search() {
        super();
    }

    /*
     * 
     * Match the query against movies and stars and return a JSON response.
     * 
     * For example, if the query is "super":
     * The JSON response look like this:
     * [
     * 	{ "value": "Superman", "data": { "category": "dc", "heroID": 101 } },
     * 	{ "value": "Supergirl", "data": { "category": "dc", "heroID": 113 } }
     * ]
     * 
     * The format is like this because it can be directly used by the 
     *   JSON auto complete library this example is using. So that you don't have to convert the format.
     *   
     * The response contains a list of suggestions.
     * In each suggestion object, the "value" is the item string shown in the dropdown list,
     *   the "data" object can contain any additional information.
     * 
     * 
     */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out = response.getWriter();
		
	    
		try {
			// setup the response json arrray
			JsonArray jsonArray = new JsonArray();
			// get the query string from parameter
			String query = request.getParameter("query");
			System.out.println(query + " length: " + query.length());

			ArrayList<String> tokens = getTokens(query);
			
			// return the empty json array if query is null or empty
			if (tokens == null || tokens.size() == 0) {
				response.getWriter().write(jsonArray.toString());
				return;
			}	
			
			// search on marvel heros and DC heros and add the results to JSON Array
			// this example only does a substring match
			// TODO: in project 4, you should do full text search with MySQL to find the matches on movies and stars
			
			if(queryMap.containsKey(query)) {
				JsonArray previousArray = queryMap.get(query);
				response.getWriter().write(previousArray.toString());
				return;
			}
						
		    try {
		    	Context initCtx = new InitialContext();
		        Context envCtx = (Context) initCtx.lookup("java:comp/env");
		        DataSource ds = (DataSource) envCtx.lookup("jdbc/TestDB");
		        Connection conn = ds.getConnection();

		        
		        String sql ="";
		        int count = 0;
		        for(int i = 0; i < tokens.size(); i++)
		        {
		        		 sql += "+" + tokens.get(i).trim() + "* ";
		        		 count++;
		        }
		        sql = sql.trim();
		        System.out.println("-----------------------------");
		        System.out.println("sql: " + sql);
//		        Statement stmt = conn.createStatement();
//		        Statement stmt1 = conn.createStatement();
		        
		        //or ed(title, '" + query + "')<= 1 
		        String sqlMovie = "SELECT movies.id,movies.title FROM movies WHERE MATCH (title) AGAINST (' ? ' IN BOOLEAN MODE) or ed(title, ' ? ')<= ' ? ' LIMIT 5";
		        PreparedStatement stmt = (PreparedStatement) conn.prepareStatement(sqlMovie);
		        stmt.setString(1, sql);
		        stmt.setString(2, query);
		        stmt.setInt(3, count);
		        
		        ResultSet rsMovies = stmt.executeQuery(sqlMovie);
//		        System.out.println("-----------------------------");
//		        System.out.println("正确的sql: " + sqlMovie);
	        
		        while(rsMovies.next()){
		            String movieId = rsMovies.getString("movies.id");
		            String movieTitle = rsMovies.getString("movies.title");

		            
		            if(movieId != null) {
//			            moviesMap.put(movieId, movieTitle);
			            jsonArray.add(generateJsonObject(movieId, movieTitle, "Movies"));
			            System.out.println(movieId + ": " + movieTitle);
		            }
		        }
		        
		        
		        //or ed(title, '" + query + "') <= 1 
		        String sqlStar = "SELECT id,name FROM stars WHERE MATCH (name) AGAINST (' ? ' IN BOOLEAN MODE) or ed(name, ' ? ')<= ' ? ' LIMIT 5";

		        PreparedStatement stmt1 = (PreparedStatement)conn.prepareStatement(sqlStar);
		        stmt1.setString(1, sql);
		        stmt1.setString(2, query);
		        stmt1.setInt(3, count);
		        ResultSet rsStars = stmt1.executeQuery(sqlStar);
		        
		        while(rsStars.next()){
		            String starId = rsStars.getString("id");
		            String starName = rsStars.getString("name");
		            
		            if(starId != null) {
//			            starsMap.put(starId, starName);
			            jsonArray.add(generateJsonObject(starId, starName, "Stars"));
			            System.out.println(starId + ": " + starName);
		            }  
		            
		        }
		        
		        queryMap.put(query, jsonArray);
		        System.out.println("******************");
		        System.out.println(queryMap.size());
		        
		        rsMovies.close();
		        rsStars.close();
		        stmt.close();
		        stmt1.close();
		        conn.close();
		        
		        } catch (Exception e) {
		        		System.out.println(e);
		        }
			
				response.getWriter().write(jsonArray.toString());
				return;
		} catch (Exception e) {
			System.out.println(e);
			response.sendError(500, e.getMessage());
		}
	}
	
	private ArrayList<String> getTokens(String query) {
		ArrayList<String> tokens = new ArrayList<>();
		if(query == null || query.trim().isEmpty() || query.length() < 3) {
			return tokens;
		}
		
		tokens = new ArrayList<String>(Arrays.asList(query.trim().split(" ")));
		
		return tokens;
	}
	
	/*
	 * Generate the JSON Object from hero and category to be like this format:
	 * {
	 *   "value": "Iron Man",
	 *   "data": { "category": "marvel", "heroID": 11 }
	 * }
	 * 
	 */
	private static JsonObject generateJsonObject(String ID, String Name, String categoryName) {
		JsonObject jsonObject = new JsonObject();
		jsonObject.addProperty("value", Name);
		
		JsonObject additionalDataJsonObject = new JsonObject();
		additionalDataJsonObject.addProperty("category", categoryName);
		additionalDataJsonObject.addProperty("ID", ID);
		
		jsonObject.add("data", additionalDataJsonObject);
		return jsonObject;
	}


}

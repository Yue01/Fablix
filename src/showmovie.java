

import java.io.IOException;
import java.sql.Array;
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

import javax.naming.InitialContext;
import javax.naming.Context;
import javax.sql.DataSource;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.mysql.jdbc.PreparedStatement;

/**
 * Servlet implementation class showmovie
 */
public class showmovie extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public showmovie() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		// Time an event in a program to nanosecond precision
		long TS_start = System.nanoTime();
		long TJ = 0;



    try {
    	JsonArray jsonArray = new JsonArray();
	String title = request.getParameter("title");
	String pagenum = request.getParameter("page");
	int curpage = Integer.parseInt(pagenum);
	curpage = curpage*50;
	pagenum=String.valueOf(curpage);
	ArrayList<String> token = getToken(title);
    Context initCtx = new InitialContext();
    Context envCtx = (Context) initCtx.lookup("java:comp/env");
    DataSource ds = (DataSource) envCtx.lookup("jdbc/TestDB");
    Connection conn = ds.getConnection();
//    Statement statement=null;

//	String loginUser = "root";
//    String loginPassword = "qwertyu";
//    String loginUrl = "jdbc:mysql://localhost:3306/moviedb?autoReconnect=true&amp;useSSL=True&amp;cachePrepStmts=true";
//
//
    long TJ_start = System.nanoTime();
//    Class.forName("com.mysql.jdbc.Driver").newInstance();
//    Connection conn = DriverManager.getConnection(loginUrl, loginUser, loginPassword);




    String cur ="";
    for(int i = 0; i < token.size(); i++)
    {
    		 cur += "+" + token.get(i).trim() + "* ";
    }
    cur=cur.trim();


    String sql = "SELECT m.id,m.title,m.year,m.director FROM movies as m WHERE MATCH (title) AGAINST (' ? ' IN BOOLEAN MODE) LIMIT 50 OFFSET ' ? '";
    PreparedStatement stmt  = (PreparedStatement) conn.prepareStatement(sql); 
    stmt.setString(1, cur);
    stmt.setInt(2, curpage);

    ResultSet rs = stmt.executeQuery();
    long TJ_end = System.nanoTime();
    TJ = TJ_end - TJ_start;


    while(rs.next()){
    	String m_title = rs.getString("m.title");
    	String m_id = rs.getString("m.id");
    	String m_year = rs.getString("m.year");
    	String m_director = rs.getString("m.director");
    	String genres = "";
    	String star="";

    	String sqlGenre = "SELECT g.id, g.name FROM genres_in_movies AS gim, genres AS g WHERE gim.movieId = '" + m_id +"' AND gim.genreId = g.id";
	    Statement stmtGenre = conn.createStatement();
		ResultSet rsGenre = stmtGenre.executeQuery(sqlGenre);
		while(rsGenre.next()){
			genres =genres  +  rsGenre.getString("g.name")+ ". ";
		}
		rsGenre.close();
		stmtGenre.close();

		String sqlStar = "SELECT s.id, s.name FROM stars_in_movies AS sim, stars AS s WHERE sim.movieId = '" + m_id +"' AND sim.starId = s.id";
	    Statement stmtStar = conn.createStatement();
		ResultSet rsStar = stmtStar.executeQuery(sqlStar);
		while(rsStar.next()){
			star = star + rsStar.getString("s.name")+ ". ";
		}
		rsStar.close();
		stmtStar.close();


    	JsonObject responseJsonObject = new JsonObject();
    	responseJsonObject.addProperty("feedback", m_title);
    	responseJsonObject.addProperty("year", m_year);
    	responseJsonObject.addProperty("director", m_director);
    	responseJsonObject.addProperty("b_url", genres);
    	responseJsonObject.addProperty("t_url", star);
    	jsonArray.add(responseJsonObject);
    }
	response.getWriter().write(jsonArray.toString());

    rs.close();
    stmt.close();
    conn.close();

	long TS_end = System.nanoTime();
	long TS = TS_end - TS_start; // elapsed time in nano seconds. Note: print the values in nano seconds
	System.out.println("T: " + TS + " " + TJ);


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

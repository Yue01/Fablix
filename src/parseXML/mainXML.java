package parseXML;

import java.sql.*;
import java.io.*;
import java.util.*;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;





/**For the mains243.xml file:
 * tag<t> for title
 * tag<year> for year
 * tag<dirn> for director
 * tag<cat> for genres
 */

public class mainXML {
	
	boolean dtag = false;
	boolean ttag =false;
	boolean ytag = false;
	boolean ctag = false;
	int page;
	int flag =0;
	String tempval = null;
	List<Mv> mvls;
	
	private Mv mvtemp;
	private Mv mvadd;
	
	public mainXML(){
		mvls = new ArrayList();
	}
	
	public void runExample() throws IOException {
			parseDocument();
			dealwithData();
			insertIntoDB();

	}
	
	private void insertIntoDB() {
		String loginUser = "root";
	    String loginPassword = "qwertyu";
	    String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
		
		try{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			Connection con = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
			con.setAutoCommit(false);
	 		String sql = "{CALL add_movie(?,?,?,?,?)}"; 
			
	 		CallableStatement stat = con.prepareCall(sql);
		
	 		//mvls.size(); 
	 		for(int j = 0; j < 100 ; j++) {
	 			for(int k = 0; k < 100 && j * 100 + k < mvls.size(); k++) {
	 			int movieYear;
	 			Mv movie = mvls.get(j * 100 + k);
	 			String movieTitle = movie.getTitle();
	 			
	 			if(isNumeric(movie.getYear())) {
	 				movieYear = Integer.parseInt(movie.getYear());
	 			}else {
	 				continue;
	 			}

	 			String movieDirector = movie.getDirector();
	 			
	 			if(movieDirector == null)
	 				continue;
	 			
	 			String movieGenre = movie.getGenres();

	 			
	 			stat.setString(1, movieTitle);
	 			stat.setInt(2, movieYear);
	 			stat.setString(3, movieDirector);
	 			stat.setString(4, "n/a");
	 			stat.setString(5, movieGenre);
	 			stat.addBatch();
	 		}
	 			stat.executeBatch();
	 			con.commit();
	 			 		
	 		}		
	 		System.out.println("Movie Insertion finished!");
			
			stat.close();
			con.close();
		}catch (Exception exc1) {
			exc1.printStackTrace();
		} 
	}
	
	private boolean isNumeric(String s) {
	    if (s != null && !"".equals(s.trim()))
	        return s.matches("^[0-9]*$");
	    else
	        return false;
	} 
	
	
	private void dealwithData(){
		
		System.out.println("No of movies '" + mvls.size() + "'.");
//		for(int i=0;i<mvls.size();i++) {
//			String c_title= mvls.get(i).getTitle();
//			String c_year = mvls.get(i).getYear();
//			String c_dir  = mvls.get(i).getDirector();
//			String c_gen  = mvls.get(i).getGenres();
//			if(c_dir==null) {
//				c_dir = "unknown";
//			}
//			System.out.println(c_title+"    "+c_year+"    "+c_dir+"    "+c_gen);
//		}
		
	}
	
	private void parseDocument() throws IOException {
      SAXParserFactory factory = SAXParserFactory.newInstance();
		try {
			
			//get a new instance of parser
			SAXParser saxParser = factory.newSAXParser();
			//parse the file and let the handler handle it
		    saxParser.parse("src/parseXML/mains243.xml", handler);
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}
	}
	
	
    DefaultHandler handler = new DefaultHandler() {
    	
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
			    tempval="";
				if (qName.equalsIgnoreCase("directorfilms")) {
			    	mvtemp = new Mv();
			    }else if (qName.equalsIgnoreCase("dirname")) {
		            dtag = true;
		        }else if (qName.equalsIgnoreCase("t")) {
			        ttag = true;
			    }else if (qName.equalsIgnoreCase("year")) {
			        ytag = true;
			    }else if (qName.equalsIgnoreCase("cat")) {
			        ctag = true;
			    }
	}
			
	public void endElement(String uri, String localName, String qName) throws SAXException {	
				if(qName.equalsIgnoreCase("film")) {
					String cur = mvtemp.getDirector();
					mvtemp=new Mv();
					mvtemp.setDirector(cur);
					flag=0;
					
				}else if (dtag && qName.equalsIgnoreCase("dirname")) {
			    	mvtemp.setDirector(tempval);                                                   
				     dtag = false;
			    }else if (ttag && qName.equalsIgnoreCase("t")) {
			    	mvtemp.setTitle(tempval);
				     ttag = false;
			    }else if (ytag && qName.equalsIgnoreCase("year")) {
			    	mvtemp.setYear(tempval);
				     ytag = false;
			    }else if (ctag && qName.equalsIgnoreCase("cat")) {
				    	if(flag==0) {
					    	mvtemp.setGenres(tempval);
						     ctag = false;
						     flag++;
							mvls.add(mvtemp);
					    }else{
					    		String tt = mvtemp.getTitle();
					    		String yy = mvtemp.getYear();
					    		String dd = mvtemp.getDirector();
					    		String gg = tempval;
					    		mvadd = new Mv();
		    		    		    mvadd.setTitle(tt);
					    		mvadd.setYear(yy);
					    		mvadd.setDirector(dd);
					    		mvadd.setGenres(gg);
					    		mvls.add(mvadd);
					    		flag++;
					    	}
			    }
			}
			public void characters(char ch[], int start, int length) throws SAXException {
				tempval = new String(ch,start,length);
			}
	
	};
	public static void main(String[] args) throws IOException{
		mainXML spe = new mainXML();
		spe.runExample();
	}
}







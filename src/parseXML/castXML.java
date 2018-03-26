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





/** For the casts124.xml file:
 *  tag<t> for movie title
 *  tag<a> for actors name
 */

public class castXML {
	
	boolean ttag = false;
	boolean atag =false;
	
	String temp = null;
	List<Cast> castls;
	
	private Cast castemp;

	
	public castXML(){
		castls = new ArrayList();
	}
	
	public void runExample() throws IOException {
			parseDocument3();
			dealwithData_cast3();
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
			
	 		for(int j = 0; j < 50 ; j++) {
	 			for(int k = 0; k < 1000 && j * 1000 + k < castls.size(); k++) {
//	 				for(int i = 0; i < castls.size(); i++ ) {
		 			Cast cast = castls.get(j * 1000 + k);
//		 			Cast cast = castls.get(i);
		 			String movieTitle = cast.getMtitle();
		 			String starName = cast.getSname();
	
		 			
		 			stat.setString(1, movieTitle);
		 			stat.setInt(2, 2018);
		 			stat.setString(3, "unknown");
		 			stat.setString(4, starName);
		 			stat.setString(5, "unknown");
		 			stat.addBatch();	
		 			System.out.print(j);
		 			System.out.println(" " + k);
//		 			stat.execute();
		 		}
		 		stat.executeBatch();
		 		con.commit();
	 		}
	 		
	 		System.out.println("Cast Insertion finished!");
			
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
	
	
	private void dealwithData_cast3(){
		
		for(int i=0;i<castls.size();i++) {
			String m_title = castls.get(i).getMtitle();
			String a_name  = castls.get(i).getSname();

				System.out.println(m_title +"   " +a_name);

		}
		
	}
	
	private void parseDocument3() throws IOException {
      SAXParserFactory factory = SAXParserFactory.newInstance();
		try {
			
			//get a new instance of parser
			SAXParser castparser = factory.newSAXParser();
			//parse the file and let the handler handle it
			castparser.parse("src/parseXML/casts124.xml", handler3);
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}
	}
	
	
    DefaultHandler handler3 = new DefaultHandler() {
    	
			public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
			    temp="";
			    if (qName.equalsIgnoreCase("m")) {
			    	castemp=new Cast();
			    }else if (qName.equalsIgnoreCase("t")) {
			    	ttag=true;
			    }else if (qName.equalsIgnoreCase("a")) {
		            atag = true;
		        }
			}
			
			public void endElement(String uri, String localName, String qName) throws SAXException {	
				if (qName.equalsIgnoreCase("m")) {
			    	castls.add(castemp);
			    }else if (qName.equalsIgnoreCase("t")) {
			    	castemp.setMtitle(temp);
		            ttag = false;
		        }else if (qName.equalsIgnoreCase("a")) {
		        	castemp.setSname(temp);
			        atag = false;
			    }
			    
			}
			public void characters(char ch[], int start, int length) throws SAXException {
				temp = new String(ch,start,length);
			}
	
	};
	public static void main(String[] args) throws IOException{
		castXML spe = new castXML();
		spe.runExample();
	}
}









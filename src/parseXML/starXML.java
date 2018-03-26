package parseXML;



import java.sql.*;
import java.io.*;
import java.util.*;

import javax.servlet.http.HttpServlet;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;





/** For the actors63.xml file:
 *  tag<stagename> for name
 *  tag<dob> for dob
 */

public class starXML{
	
	boolean ntag = false;
	boolean dobtag =false;
	
	String temp = null;
	List<Star> starls;
	
	private Star startemp;

	
	public starXML(){
		starls = new ArrayList();
	}
	
	public void runExample() throws IOException {
			parseDocument();
			dealwithData_star();
			insertIntoDB();

	}
	
	private void insertIntoDB() {
		String loginUser = "root";
	    String loginPassword = "qwertyu";
	    String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
		
		try{
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			Connection con = DriverManager.getConnection(loginUrl, loginUser, loginPassword);
	 		String sql = "{CALL add_star(?,?)}"; 
			con.setAutoCommit(false);
	 		CallableStatement stat = con.prepareCall(sql);
	 		
	 		for(int j = 0; j < 7 ; j++) {
	 			for(int k = 0; k < 1000 && j * 1000 + k < starls.size(); k++) {
	 				int starBirthYear;
		 			Star star = starls.get(j*1000 + k);
		 			String starName = star.getName();
		 			if(isNumeric(star.getDob())) {
		 				starBirthYear = Integer.parseInt(star.getDob());
		 			}else {
		 				starBirthYear = -1;
		 			}
		 			
		 			stat.setString(1, starName);
		 			stat.setInt(2, starBirthYear);
		 			stat.addBatch();
		 			
		 			System.out.println(j);
	 			}
	 			stat.executeBatch();
	 			con.commit();
	 		}
	 		
	 		System.out.println("Stars Insertion finished!");
			
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
	
	private void dealwithData_star(){
		
		System.out.println("No of stars '" + starls.size() + "'.");
		for(int i=0;i<starls.size();i++) {
			String s_name = starls.get(i).getName();
			String s_dob  = starls.get(i).getDob();
			if(s_dob == null||s_dob.equals("")) {
				System.out.println(s_name+" no DOB");
			}else {
				System.out.println(s_name+"   " +s_dob);
			}

		}
		
	}
	
	private void parseDocument() throws IOException {
      SAXParserFactory factory = SAXParserFactory.newInstance();
		try {
			
			//get a new instance of parser
			SAXParser starparser = factory.newSAXParser();
			//parse the file and let the handler handle it
			starparser.parse("src/parseXML/actors63.xml", handler2);
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}
	}
	
	
    DefaultHandler handler2 = new DefaultHandler() {
    	
			public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
			    temp="";
				if (qName.equalsIgnoreCase("actor")) {
			    	startemp = new Star();
			    }else if (qName.equalsIgnoreCase("stagename")) {
		            ntag = true;
		        }else if (qName.equalsIgnoreCase("dob")) {
			        dobtag = true;
			    }
			}
			
			public void endElement(String uri, String localName, String qName) throws SAXException {	
				if (qName.equalsIgnoreCase("actor")) {
			    	starls.add(startemp);
			    }else if (qName.equalsIgnoreCase("stagename")) {
			    	startemp.setName(temp);
		            ntag = false;
		        }else if (qName.equalsIgnoreCase("dob")) {
		        	startemp.setDob(temp);
			        dobtag = false;
			    }
			    
			}
			public void characters(char ch[], int start, int length) throws SAXException {
				temp = new String(ch,start,length);
			}
	
	};
	public static void main(String[] args) throws IOException{
		starXML spe = new starXML();
		spe.runExample();
	}
}








import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Scanner;

public class LogParser {
	public static void main(String[] args) throws IOException{
		boolean found = false;
		Scanner s = new Scanner(System.in);
		String inputStr = "";
		while(!found){
			System.out.println("Please enter the file path of the log file or [quit] to terminate: ");
			inputStr = s.nextLine();
			if(inputStr.equalsIgnoreCase("quit")){
				break;
			}
			try {
				//Replace the file path with where the log file is
				FileInputStream fstream = new FileInputStream(inputStr);
				found = true;
				BufferedReader br = new BufferedReader(new InputStreamReader(fstream));
				String line;
				br.readLine();
				ArrayList<Integer> ts = new ArrayList<Integer>();
				ArrayList<Integer> tj = new ArrayList<Integer>();
				while((line = br.readLine()) != null){
					Integer totalExec = Integer.parseInt(line.split("(\\s+)")[2]);
					Integer jdbcExec = Integer.parseInt(line.split("(\\s+)")[6]);
					
					ts.add(totalExec);
					tj.add(jdbcExec);
					br.readLine();
				}
				long tsSum = 0;
				for(Integer i: ts){
					tsSum += i;
				}
				long tsAvg = tsSum/ts.size();
				
				long tjSum = 0;
				for(Integer i: tj){
					tjSum += i;
				}
				long tjAvg = tjSum/tj.size();
				System.out.println("_____________________________________________________________");
				System.out.println("\n=========== Calculated Results From the Log Parser ===========\n");
				System.out.println("Total Number of search queries: " + ts.size());
				System.out.println("Total Search Execution Time (TS) : " + tsSum + " nanosecs.");
				System.out.println("TS Average: " + tsAvg + " nanosecs.");
				System.out.println("Total JDBC Execution Time (TJ): " + tjSum + " nanosecs.");
				System.out.println("TJ Average: " + tjAvg + " nanosecs.");
				System.out.println("_____________________________________________________________");
				br.close();
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				System.out.println("File not found! Please try again.\n");
			}
		}
		s.close();
	}
}

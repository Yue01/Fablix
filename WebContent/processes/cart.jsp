<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%><%@ page import = "java.io.*, java.sql.*" %><%@ page import = "org.json.*" %><%@ page import="java.util.ArrayList"%>
<%
JSONObject movieData = new JSONObject(request.getParameter("movieData"));
ArrayList<JSONObject> cart = new ArrayList<JSONObject>((ArrayList<JSONObject>)session.getAttribute("moviesInCart"));
JSONObject movieToAdd = new JSONObject();

String action = request.getParameter("action");
switch(action){
	case "add":
		if(cart.isEmpty()){
			movieToAdd.put("movieID", movieData.get("movieID"));
			movieToAdd.put("title", movieData.get("title"));
			movieToAdd.put("banner", movieData.get("banner"));
			movieToAdd.put("quantity", 1);
			cart.add(movieToAdd);
		}else{
			int index= 0;
			for(JSONObject movie: (ArrayList<JSONObject>)session.getAttribute("moviesInCart")){
				if(movie.get("movieID").equals(movieData.get("movieID"))){
					int newQuantity = (int)movie.get("quantity") + 1;
					movieToAdd.put("movieID", movie.get("movieID"));
					movieToAdd.put("title", movie.get("title"));
					movieToAdd.put("banner", movieData.get("banner"));
					movieToAdd.put("quantity", newQuantity);
					cart.set(index, movieToAdd);
					break;
				}else{
					if(index == cart.size()-1){
						movieToAdd.put("movieID", movieData.get("movieID"));
						movieToAdd.put("title", movieData.get("title"));
						movieToAdd.put("banner", movieData.get("banner"));
						movieToAdd.put("quantity", 1);
						cart.add(movieToAdd);
						break;
					}
				}
				index += 1;	
			}
		}
		break;
	case "remove":
		int index = 0;
		for(JSONObject movie: (ArrayList<JSONObject>)session.getAttribute("moviesInCart")){
			if(movie.get("movieID").equals(movieData.get("movieID"))){
				if((int)movie.get("quantity") == 1){
					cart.remove(movie);
					break;
				}else{
					int newQuantity = (int)movie.get("quantity")-1;
					cart.get(index).put("quantity", newQuantity);
					break;
				}
			}index+=1;
		}
		break;
}
session.setAttribute("moviesInCart", cart);
response.getWriter().write(session.getAttribute("moviesInCart").toString());

%>
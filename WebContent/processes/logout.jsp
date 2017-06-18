<% 
session.removeAttribute("name");
session.removeAttribute("moviesInCart");
session.invalidate(); 
response.sendRedirect(request.getContextPath());
%>
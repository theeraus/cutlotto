<!DOCTYPE html>
<html>

    <td>
        -----------</br>
        
        <img src="images/chgsumpass.JPG" />
        </br>
    </td>
 <body>
<%
 response.write("My first ASP script!")
 %>
<%  
  Dim dtmHour 

  dtmHour = Hour(Now()) 

  If dtmHour < 12 Then 
    strGreeting = "Good Morning!" 
  Else   
    strGreeting = "Hello!" 
  End If    
%>  
/n
This page was last refreshed on <%= Now() %>. 

<%= strGreeting %> 

 </body>
 </html> 
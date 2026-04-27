<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
    String execName = (String) session.getAttribute("execName");
    Integer execId = (Integer) session.getAttribute("execId");
    String adminName = (String) session.getAttribute("adminName");
    Integer adminId = (Integer) session.getAttribute("adminId");
%>

<!DOCTYPE html>
<html>
<head>
<style>

*{
 margin:0;
 padding:0;
 box-sizing:border-box;
 font-family:'Segoe UI', sans-serif;
}

body{
 height:100vh;
 display:flex;
 justify-content:center;
 align-items:center;
 background: linear-gradient(-45deg,#0f172a,#0f766e,#059669,#0ea5e9);
 background-size:400% 400%;
 animation:gradientBG 10s ease infinite;
}

@keyframes gradientBG{
 0%{background-position:0% 50%;}
 50%{background-position:100% 50%;}
 100%{background-position:0% 50%;}
}

.card{
 background: rgba(255,255,255,0.15);
 backdrop-filter: blur(15px);
 padding:40px;
 border-radius:20px;
 box-shadow:0 20px 60px rgba(0,0,0,0.3);
 text-align:center;
 width:380px;
 color:white;
 animation:fadeIn 0.8s ease;
}

.card h1{
 font-size:28px;
 margin-bottom:10px;
}

.card h2{
 font-size:18px;
 opacity:0.9;
 margin-bottom:20px;
}

.btn{
 display:inline-block;
 margin-top:15px;
 padding:10px 20px;
 border-radius:30px;
 background:white;
 color:#0f766e;
 text-decoration:none;
 font-weight:bold;
 transition:0.3s;
}

.btn:hover{
 transform:scale(1.1);
 box-shadow:0 10px 25px rgba(0,0,0,0.3);
}

.icon{
 font-size:50px;
 margin-bottom:15px;
 animation:float 2s ease-in-out infinite;
}


@keyframes float{
 0%,100%{transform:translateY(0);}
 50%{transform:translateY(-10px);}
}


@keyframes fadeIn{
 from{opacity:0; transform:translateY(20px);}
 to{opacity:1; transform:translateY(0);}
}
</style>
</head>

<body>


   <div class="card">

<div class="icon">👨‍💻</div>

<% if(execName != null){ %>
    <h1>Welcome, <%= execName %> 👋</h1>
    <h2>ID: <%= execId %></h2>
<% } else if(adminName != null){ %>
    <h1>Welcome, Admin <%= adminName %> 👋</h1>
    <h2>ID: <%= adminId %></h2>
<% } else { %>
    <h1>Welcome!</h1>
<% } %>


</div>


</body>
</html>
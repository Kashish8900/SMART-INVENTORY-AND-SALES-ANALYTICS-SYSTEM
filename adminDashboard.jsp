<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
 
String adminName = (String) session.getAttribute("adminName");
Integer adminId = (Integer) session.getAttribute("adminId");

    if(adminName == null){
        response.sendRedirect("auth.jsp?role=admin");
    }
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>
<style>
{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Segoe UI', sans-serif;
}


body{
    height:100vh;
    display:flex;
    background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
}


.sidebar{
    width:230px;
    background: linear-gradient(90deg, #0f766e, #059669);
    color:white;
    display:flex;
    flex-direction:column;
    padding-top:20px;
    box-shadow: 4px 0 20px rgba(0,0,0,0.1);
}

.sidebar h2{
    text-align:center;
    margin-bottom:20px;
    letter-spacing:1px;
}

/* MENU BUTTON */
.sidebar button{
    background:none;
    border:none;
    color:white;
    padding:14px 20px;
    text-align:left;
    font-size:15px;
    cursor:pointer;
    width:100%;
    transition:0.3s;
    border-radius:8px;
}

/* HOVER */
.sidebar button:hover{
    background: rgba(255,255,255,0.2);
    transform: translateX(5px);
}


.sidebar button.active{
    background:white;
    color:#0f766e;
}

.content{
    flex:1;
    padding:15px;
    display:flex;
    flex-direction:column;
}

.topbar{
    height:60px;
    background:white;
    border-radius:12px;
    display:flex;
    align-items:center;
    justify-content:space-between;
    padding:0 20px;
    margin-bottom:10px;
    box-shadow:0 4px 20px rgba(0,0,0,0.08);
}

.user-name{
    font-weight:bold;
    color:#0f172a;
}

.toggle{
    background:#0f766e;
    color:white;
    padding:6px 12px;
    border-radius:8px;
    cursor:pointer;
}

iframe{
    flex:1;
    border:none;
    border-radius:12px;
    background:white;
    box-shadow:0 4px 20px rgba(0,0,0,0.1);
}

.logout{
    margin-top:auto;
    padding:12px;
    border:none;
    background:#ef4444;
    color:white;
    cursor:pointer;
}


.dark{
    background:#0f172a !important;
}

.dark .topbar{
    background:#1e293b;
    color:white;
}

.dark iframe{
    background:#1e293b;
}
</style>
<script>
function loadPage(page){
    document.getElementById("outputFrame").src = page;
}
</script>
</head>
<body>

<div class="sidebar">
    <h2><u>ADMIN PANEL</u></h2>
    <button onclick="loadPage('Customer.jsp')">👥 Customers</button>

<button onclick="loadPage('product.jsp')">📦 Inventory</button>
<button onclick="loadPage('Suppliers.jsp')">🚚 Suppliers</button>
<button onclick="loadPage('sales1.jsp')">💰 Sales</button>
<button onclick="loadPage('total_stock.jsp')">📊 Total Stock</button>
<button onclick="loadPage('purchase_order.jsp')">🧾 Purchase Orders</button>
<button onclick="loadPage('profit_loss.jsp')">📉 Profit-Loss</button>
<form method="post" action="logout.jsp">
    <button type="submit" class="logout">🚪 Logout</button>
</form>
</div>
<div class="content">
    <iframe id="outputFrame" src="welcome.jsp"></iframe>
</div>

</body>
</html>
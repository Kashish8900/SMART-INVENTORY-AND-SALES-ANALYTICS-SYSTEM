<%@ page import="java.sql.*" %>

<%
Connection con = null;
Class.forName("com.mysql.cj.jdbc.Driver");
con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/inventory_system","root","kashish890"
);

String search = request.getParameter("search");

PreparedStatement ps;

if(search != null && !search.trim().isEmpty()){
    ps = con.prepareStatement(
    "SELECT c.id, c.customer_name, c.mobile1, c.email, MAX(i.date) as last_date " +
    "FROM customers c JOIN invoices i ON c.id=i.customer_id " +
    "WHERE c.customer_name LIKE ? OR c.mobile1 LIKE ? OR c.email LIKE ? " +
    "GROUP BY c.id, c.customer_name, c.mobile1, c.email " +
    "ORDER BY last_date DESC"
    );

    String s = "%"+search+"%";
    ps.setString(1, s);
    ps.setString(2, s);
    ps.setString(3, s);

}else{
    ps = con.prepareStatement(
    "SELECT c.id, c.customer_name, c.mobile1, c.email, MAX(i.date) as last_date " +
    "FROM customers c JOIN invoices i ON c.id=i.customer_id " +
    "GROUP BY c.id, c.customer_name, c.mobile1, c.email " +
    "ORDER BY last_date DESC"
    );
}

ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>Invoice Dashboard</title>

<style>

*{
 margin:0;
 padding:0;
 box-sizing:border-box;
 font-family:'Segoe UI', sans-serif;
}

body{
 background: linear-gradient(-45deg,#0f172a,#0f766e,#059669,#0ea5e9);
 background-size: 400% 400%;
 animation: gradientBG 10s ease infinite;
 padding:20px;
}

@keyframes gradientBG{
 0%{background-position:0% 50%;}
 50%{background-position:100% 50%;}
 100%{background-position:0% 50%;}
}

.card{
 background: rgba(255,255,255,0.9);
 padding:25px;
 border-radius:18px;
 box-shadow:0 20px 50px rgba(0,0,0,0.2);
 animation: fadeIn 0.5s ease;
 max-width:1100px;
 margin:auto;
}


h2{
 text-align:center;
 margin-bottom:20px;
 color:#0f766e;
}

input{
 width:100%;
 padding:12px 15px;
 margin-bottom:15px;
 border-radius:25px;
 border:1px solid #ddd;
 outline:none;
 transition:0.3s;
}

input:focus{
 border-color:#0f766e;
 box-shadow:0 0 10px rgba(15,118,110,0.3);
}

table{
 width:100%;
 border-collapse:collapse;
 margin-top:15px;
 overflow:hidden;
 border-radius:10px;
}

th{
 background:linear-gradient(90deg,#0f766e,#059669);
 color:white;
 padding:12px;
}

td{
 padding:12px;
 border-bottom:1px solid #eee;
 transition:0.3s;
}

tr:hover td{
 background:#f0fdfa;
 transform:scale(1.01);
}


.btn{
 padding:8px 16px;
 border:none;
 border-radius:25px;
 cursor:pointer;
 font-size:13px;
 color:white;
 background:linear-gradient(90deg,#0f766e,#059669);
 transition:0.3s;
}


.btn:hover{
 transform:scale(1.1);
 box-shadow:0 8px 20px rgba(0,0,0,0.2);
}


@keyframes fadeIn{
 from{opacity:0; transform:translateY(10px);}
 to{opacity:1; transform:translateY(0);}
}

@media(max-width:768px){
 table{
  font-size:12px;
 }
}
</style>

<script>
function openInvoice(id){
    if(!id){
        alert("Customer ID missing!");
        return;
    }

    let url = "invoice.jsp?id=" + id;
    console.log("Opening:", url);

    let win = window.open(url, "_blank");

    if(!win){
        alert("Popup blocked! Allow popups.");
    }
}
function filterTable(){
    let input = document.getElementById("searchBox").value.toLowerCase();
    let rows = document.querySelectorAll("table tbody tr");

    rows.forEach(row=>{
        let text = row.innerText.toLowerCase();
        row.style.display = text.includes(input) ? "" : "none";
    });
}
</script>

</head>

<body>

<div class="card">

<h2>Invoice Dashboard</h2>

<form method="get">
<input type="text" id="searchBox" placeholder="Search by Name / Mobile / Email..." onkeyup="filterTable()">

</form>

<table>
<thead>
<tr>
<th>ID</th>
<th>Name</th>
<th>Mobile</th>
<th>Email</th>
<th>Last Purchase</th>
<th>Action</th>
</tr>
</thead>

<tbody>

<%
boolean found=false;
while(rs.next()){
found=true;
%>

<tr>
<td><%=rs.getInt("id")%></td>
<td><%=rs.getString("customer_name")%></td>
<td><%=rs.getString("mobile1")%></td>
<td><%=rs.getString("email")%></td>
<td><%=rs.getTimestamp("last_date")%></td>
<td>
<button class="btn" type="button" onclick="window.open('generate_invoice.jsp?id=<%=rs.getInt("id")%>')">
Download Invoice
</button>
</td>
</tr>

<% } %>

<%
if(!found){
%>
<tr>
<td colspan="6" style="color:red;">No Customer Found</td>
</tr>
<%
}
%>

</table>

</div>
</body>
</html> 
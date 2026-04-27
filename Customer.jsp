<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
Class.forName("com.mysql.cj.jdbc.Driver");
Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/inventory_system",
    "root",
    "kashish890"
);

String editId = request.getParameter("edit");
String cname="", office="", email="", city="", billing="", shipping="", cperson="", cemail="", mobile1="", mobile2="", bank="";
double balance = 0;

if(editId != null){
    PreparedStatement psEdit = con.prepareStatement("SELECT * FROM customers WHERE id=?");
    psEdit.setInt(1,Integer.parseInt(editId));
    ResultSet rsEdit = psEdit.executeQuery();
    if(rsEdit.next()){
        cname = rsEdit.getString("customer_name");
        office = rsEdit.getString("office_no");
        email = rsEdit.getString("email");
        city = rsEdit.getString("city");
        billing = rsEdit.getString("billing_address");
        shipping = rsEdit.getString("shipping_address");
        cperson = rsEdit.getString("contact_person");
        cemail = rsEdit.getString("contact_email");
        mobile1 = rsEdit.getString("mobile1");
        mobile2 = rsEdit.getString("mobile2");
        bank = rsEdit.getString("bank_account");
        balance = rsEdit.getDouble("balance");
    }
}

if(request.getParameter("delete")!=null){
    int id = Integer.parseInt(request.getParameter("delete"));
    PreparedStatement psDel = con.prepareStatement("DELETE FROM customers WHERE id=?");
    psDel.setInt(1,id);
    psDel.executeUpdate();
    response.sendRedirect("Customer.jsp");
}

if(request.getParameter("update")!=null){
    int id = Integer.parseInt(request.getParameter("id"));
    email = request.getParameter("email");
    if(email != null && !email.contains("@")) email += "@gmail.com";
    if(request.getParameter("balance")!=null && !request.getParameter("balance").isEmpty()){
        balance = Double.parseDouble(request.getParameter("balance"));
    }

    PreparedStatement psUpd = con.prepareStatement(
        "UPDATE customers SET customer_name=?, office_no=?, email=?, city=?, billing_address=?, shipping_address=?, contact_person=?, contact_email=?, mobile1=?, mobile2=?, bank_account=?, balance=? WHERE id=?"
    );
    psUpd.setString(1,request.getParameter("customer_name"));
    psUpd.setString(2,request.getParameter("office_no"));
    psUpd.setString(3,email);
    psUpd.setString(4,request.getParameter("city"));
    psUpd.setString(5,request.getParameter("billing_address"));
    psUpd.setString(6,request.getParameter("shipping_address"));
    psUpd.setString(7,request.getParameter("contact_person"));
    psUpd.setString(8,request.getParameter("contact_email"));
    psUpd.setString(9,request.getParameter("mobile1"));
    psUpd.setString(10,request.getParameter("mobile2"));
    psUpd.setString(11,request.getParameter("bank_account"));
    psUpd.setDouble(12,balance);
    psUpd.setInt(13,id);
    psUpd.executeUpdate();
    response.sendRedirect("Customer.jsp");
}

if(request.getParameter("save")!=null){
    email = request.getParameter("email");
    if(email!=null && !email.contains("@")){ email += "@gmail.com"; }
    if(request.getParameter("balance")!=null && !request.getParameter("balance").isEmpty()){
        balance = Double.parseDouble(request.getParameter("balance"));
    }

    PreparedStatement ps = con.prepareStatement(
        "INSERT INTO customers(customer_name,office_no,email,city,billing_address,shipping_address,contact_person,contact_email,mobile1,mobile2,bank_account,balance) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)"
    );
    ps.setString(1,request.getParameter("customer_name"));
    ps.setString(2,request.getParameter("office_no"));
    ps.setString(3,email);
    ps.setString(4,request.getParameter("city"));
    ps.setString(5,request.getParameter("billing_address"));
    ps.setString(6,request.getParameter("shipping_address"));
    ps.setString(7,request.getParameter("contact_person"));
    ps.setString(8,request.getParameter("contact_email"));
    ps.setString(9,request.getParameter("mobile1"));
    ps.setString(10,request.getParameter("mobile2"));
    ps.setString(11,request.getParameter("bank_account"));
    ps.setDouble(12,balance);
    ps.executeUpdate();
    response.sendRedirect("Customer.jsp");
}

String search = request.getParameter("search");
PreparedStatement ps2;
if(search!=null && !search.isEmpty()){
    ps2 = con.prepareStatement(
        "SELECT * FROM customers WHERE customer_name LIKE ? OR city LIKE ? OR contact_person LIKE ? OR mobile1 LIKE ? OR billing_address LIKE ? ORDER BY id DESC"
    );
    for(int i=1;i<=5;i++){
        ps2.setString(i,"%"+search+"%");
    }
} else {
    ps2 = con.prepareStatement("SELECT * FROM customers ORDER BY id DESC");
}
ResultSet rs = ps2.executeQuery();

if("excel".equals(request.getParameter("export"))){
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition","attachment; filename=customers.xls");
%>
<table border="1">
<tr><th>ID</th><th>Name</th><th>City</th><th>Contact</th><th>Mobile</th><th>Email</th><th>Balance</th></tr>
<%
while(rs.next()){
%>
<tr>
<td><%=rs.getInt("id")%></td>
<td><%=rs.getString("customer_name")%></td>
<td><%=rs.getString("city")%></td>
<td><%=rs.getString("contact_person")%></td>
<td><%=rs.getString("mobile1")%></td>
<td><%=rs.getString("email")%></td>
<td><%=rs.getDouble("balance")%></td>
</tr>
<%
}
%>
</table>
<%
return; 
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Customer Management</title>
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
}


@keyframes gradientBG{
 0%{background-position:0% 50%;}
 50%{background-position:100% 50%;}
 100%{background-position:0% 50%;}
}

.tabs{
 position:fixed;
 top:0;
 width:100%;
 height:65px;
 display:flex;
 justify-content:center;
 align-items:center;
 gap:15px;
 z-index:1000;

 background: rgba(255,255,255,0.15);
 backdrop-filter: blur(12px);
 border-bottom:1px solid rgba(255,255,255,0.2);
}

.tabs button{
 background: rgba(255,255,255,0.2);
 border:none;
 color:white;
 padding:10px 18px;
 border-radius:30px;
 cursor:pointer;
 transition:0.3s;
}

.tabs button:hover{
 background:white;
 color:#0f766e;
 transform: translateY(-3px);
}

.tabs button.active{
 background:white;
 color:#0f766e;
 font-weight:bold;
 box-shadow:0 5px 15px rgba(0,0,0,0.2);
}

.main{
 margin-top:90px;
 padding:25px;
}

.content{
 background: rgba(255,255,255,0.9);
 border-radius:18px;
 padding:25px;
 box-shadow:0 20px 50px rgba(0,0,0,0.2);
 animation: fadeIn 0.5s ease;
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


input,select,textarea{
 width:100%;
 padding:10px 15px;
 margin:8px 0;
 border-radius:25px;
 border:1px solid #ddd;
 outline:none;
 transition:0.3s;
}

input:focus,select:focus,textarea:focus{
 border-color:#0f766e;
 box-shadow:0 0 10px rgba(15,118,110,0.3);
}

button, .btn{
 padding:8px 18px;
 border:none;
 border-radius:25px;
 cursor:pointer;
 font-size:13px;
 color:white;
 transition:0.3s;
}

.save{
 background:linear-gradient(90deg,#0f766e,#059669);
}

.edit{
 background:linear-gradient(90deg,#0f766e,#059669);
}

.del{
 background:linear-gradient(90deg,#0f766e,#059669);
}

button:hover, .btn:hover{
 transform:scale(1.1);
 box-shadow:0 8px 20px rgba(0,0,0,0.2);
}

.searchbar input{
 padding:10px 15px;
 border-radius:25px;
 border:1px solid #ddd;
 outline:none;
}

.flex{
 display:flex;
 gap:25px;
 flex-wrap:wrap;
}

.section{display:none}
.section.active{
 display:block;
 animation: fadeIn 0.5s ease;
}

@keyframes fadeIn{
 from{opacity:0; transform:translateY(10px);}
 to{opacity:1; transform:translateY(0);}
}

@media(max-width:768px){
 .tabs{
  flex-wrap:wrap;
  height:auto;
  padding:10px;
 }

 .tabs button{
  width:100%;
 }

 .flex{
  flex-direction:column;
 }
}
</style>

<script>
function showTab(id){
    ['all','add','report'].forEach(t=>document.getElementById(t).style.display='none');
    document.getElementById(id).style.display='block';
}
function filterTable(){
    let input = document.getElementById("searchInput").value.toLowerCase();
    let rows = document.querySelectorAll("#customerTable tbody tr");
    rows.forEach(row=>{
        let text = row.innerText.toLowerCase();
        row.style.display = text.includes(input) ? "" : "none";
    });
}
</script>
</head>
<body>

<div class="tabs">
<button onclick="showTab('all')">All Customers</button>
<button onclick="showTab('add')">Add Customer</button>
<button onclick="showTab('report')">Customer Report</button>
</div>

<div class="content main">

<div id="all">
<h3>Customer List</h3>
<div class="searchbar">
<input id="searchInput" placeholder="Search by name/city/contact/mobile" onkeyup="filterTable()">
<form method="get" style="display:inline">
<input type="hidden" name="export" value="excel">
<button>Export Excel</button>
</form>
</div>

<table id="customerTable">
<tr>
<th>ID</th><th>Name</th><th>City</th><th>Contact</th><th>Mobile</th><th>Email</th><th>Balance</th><th>Action</th>
</tr>
<tbody>
<%
while(rs.next()){
%>
<tr>
<td><%=rs.getInt("id")%></td>
<td><%=rs.getString("customer_name")%></td>
<td><%=rs.getString("city")%></td>
<td><%=rs.getString("contact_person")%></td>
<td><%=rs.getString("mobile1")%></td>
<td><%=rs.getString("email")%></td>
<td><%=rs.getDouble("balance")%></td>
<td>
<a href="Customer.jsp?edit=<%=rs.getInt("id")%>">Edit</a> |
<a href="Customer.jsp?delete=<%=rs.getInt("id")%>" onclick="return confirm('Are you sure?')">Delete</a>
</td>
</tr>
<% } %>
</tbody>
</table>
</div>

<div id="add" style="display:none">
<h3><%= (editId != null) ? "Edit Customer" : "Add Customer" %></h3>
<form method="post">
<input type="hidden" name="id" value="<%= editId %>">
<input name="customer_name" value="<%= cname %>" placeholder="Customer Name" required>
<input name="office_no" value="<%= office %>" placeholder="Office Number">
<input name="email" value="<%= email %>" placeholder="Email">
<input name="city" value="<%= city %>" placeholder="City">
<textarea name="billing_address" placeholder="Billing Address"><%= billing %></textarea>
<textarea name="shipping_address" placeholder="Shipping Address"><%= shipping %></textarea>

<input name="contact_person" value="<%= cperson %>" placeholder="Contact Person">
<input name="contact_email" value="<%= cemail %>" placeholder="Contact Email">
<input name="mobile1" value="<%= mobile1 %>" placeholder="Mobile 1">
<input name="mobile2" value="<%= mobile2 %>" placeholder="Mobile 2">

<input name="bank_account" value="<%= bank %>" placeholder="Bank Account">
<input name="balance" value="<%= balance %>">

<div class="actions">
<% if(editId != null){ %>
<button name="update" class="btn save">Update Customer</button>
<% } else { %>
<button class="btn save">Save Customer</button>

<% } %>
</div>
</form>
</div>

<div id="report" style="display:none">
<h3>Customer Report</h3>

<%
if("excel".equals(request.getParameter("exportReport"))){
    // Export all customer details to Excel
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition","attachment; filename=customer_report.xls");

    Statement stRpt = con.createStatement();
    ResultSet rsRpt = stRpt.executeQuery("SELECT * FROM customers ORDER BY id DESC");
%>
<table border="1">
<tr>
<th>ID</th>
<th>Name</th>
<th>Office No</th>
<th>Email</th>
<th>City</th>
<th>Billing Address</th>
<th>Shipping Address</th>
<th>Contact Person</th>
<th>Contact Email</th>
<th>Mobile 1</th>
<th>Mobile 2</th>
<th>Bank Account</th>
<th>Balance</th>
</tr>
<%
while(rsRpt.next()){
%>
<tr>
<td><%= rsRpt.getInt("id") %></td>
<td><%= rsRpt.getString("customer_name") %></td>
<td><%= rsRpt.getString("office_no") %></td>
<td><%= rsRpt.getString("email") %></td>
<td><%= rsRpt.getString("city") %></td>
<td><%= rsRpt.getString("billing_address") %></td>
<td><%= rsRpt.getString("shipping_address") %></td>
<td><%= rsRpt.getString("contact_person") %></td>
<td><%= rsRpt.getString("contact_email") %></td>
<td><%= rsRpt.getString("mobile1") %></td>
<td><%= rsRpt.getString("mobile2") %></td>
<td><%= rsRpt.getString("bank_account") %></td>
<td><%= rsRpt.getDouble("balance") %></td>
</tr>
<%
} 
%>
</table>
<%
    return; 
} 
%>

<form method="get">
<input type="hidden" name="exportReport" value="excel">
<button style="padding:10px 15px;background:#2ed573;color:black;border:none;border-radius:5px;cursor:pointer">
Download Full Customer Report (Excel)
</button>
</form>
</div>

</div>
</body>
</html>
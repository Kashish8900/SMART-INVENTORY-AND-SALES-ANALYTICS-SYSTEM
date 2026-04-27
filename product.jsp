<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
Connection con = null;
try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/inventory_system",
        "root",
        "kashish890"
    );
}catch(Exception e){
    out.println("DB Error: "+e);
}
%>
<%

if(request.getParameter("saveCat")!=null){
PreparedStatement i=con.prepareStatement(
"INSERT INTO categories(category_name,description) VALUES(?,?)");
i.setString(1,request.getParameter("cname"));
i.setString(2,request.getParameter("desc"));
i.executeUpdate();
response.sendRedirect("product.jsp");
}

if(request.getParameter("saveProduct")!=null){
PreparedStatement i=con.prepareStatement(
"INSERT INTO products(product_name,category_id,price,stock) VALUES(?,?,?,?)");
i.setString(1,request.getParameter("pname"));
i.setInt(2,Integer.parseInt(request.getParameter("cat")));
i.setDouble(3,Double.parseDouble(request.getParameter("price")));
i.setInt(4,Integer.parseInt(request.getParameter("stock")));
i.executeUpdate();
response.sendRedirect("product.jsp");
}

if(request.getParameter("updateProduct")!=null){
PreparedStatement u=con.prepareStatement(
"UPDATE products SET product_name=?,category_id=?,price=?,stock=? WHERE product_id=?");
u.setString(1,request.getParameter("pname"));
u.setInt(2,Integer.parseInt(request.getParameter("cat")));
u.setDouble(3,Double.parseDouble(request.getParameter("price")));
u.setInt(4,Integer.parseInt(request.getParameter("stock")));
u.setInt(5,Integer.parseInt(request.getParameter("pid")));
u.executeUpdate();
response.sendRedirect("product.jsp");
}

if(request.getParameter("delp")!=null){
PreparedStatement d=con.prepareStatement(
"DELETE FROM products WHERE product_id=?");
d.setInt(1,Integer.parseInt(request.getParameter("delp")));
d.executeUpdate();
response.sendRedirect("product.jsp");
}

if(request.getParameter("delc")!=null){
PreparedStatement d=con.prepareStatement(
"DELETE FROM categories WHERE category_id=?");
d.setInt(1,Integer.parseInt(request.getParameter("delc")));
d.executeUpdate();
response.sendRedirect("product.jsp");
}

if(request.getParameter("excel")!=null){
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-Disposition","attachment;filename=products.xls");

Statement es=con.createStatement();
ResultSet er=es.executeQuery(
"SELECT p.product_id,p.product_name,c.category_name,p.price FROM products p JOIN categories c ON p.category_id=c.category_id");

out.println("ID\tName\tCategory\tPrice");
while(er.next()){
out.println(er.getInt(1)+"\t"+er.getString(2)+"\t"+
er.getString(3)+"\t"+er.getDouble(4));
}
return;
}
int eid=0, ecat=0;
String epname="";
double eprice=0;
int estock=0;

if(request.getParameter("editp")!=null){
PreparedStatement ep=con.prepareStatement(
"SELECT * FROM products WHERE product_id=?");
ep.setInt(1,Integer.parseInt(request.getParameter("editp")));
ResultSet er=ep.executeQuery();
if(er.next()){
 eid=er.getInt("product_id");
 epname=er.getString("product_name");
 ecat=er.getInt("category_id");
 eprice=er.getDouble("price");
 estock=er.getInt("stock");
}
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Electronic Shop - Products</title>

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


.topbar{
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

.topbar button{
 background: rgba(255,255,255,0.2);
 border:none;
 color:white;
 padding:10px 18px;
 border-radius:30px;
 cursor:pointer;
 transition:0.3s;
}


.topbar button:hover{
 background:white;
 color:#0f766e;
 transform: translateY(-3px);
}

.topbar button.active{
 background:white;
 color:#0f766e;
 font-weight:bold;
 box-shadow:0 5px 15px rgba(0,0,0,0.2);
}

.main{
 margin-top:90px;
 padding:25px;
}

.card{
 background: rgba(255,255,255,0.9);
 border-radius:18px;
 padding:25px;
 box-shadow:0 20px 50px rgba(0,0,0,0.2);
 animation: fadeIn 0.5s ease;
}

.product-header{
 display:flex;
 justify-content:space-between;
 align-items:center;
 margin-bottom:15px;
}

.search{
 padding:10px 15px;
 border-radius:25px;
 border:1px solid #ddd;
 outline:none;
 transition:0.3s;
}

.search:focus{
 border-color:#0f766e;
 box-shadow:0 0 10px rgba(15,118,110,0.4);
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

.btn{
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

.btn:hover{
 transform:scale(1.1);
 box-shadow:0 8px 20px rgba(0,0,0,0.2);
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
 .topbar{
  flex-wrap:wrap;
  height:auto;
  padding:10px;
 }

 .topbar button{
  width:100%;
 }

 .flex{
  flex-direction:column;
 }
}
</style>
<script>
function show(id,btn){
 document.querySelectorAll('.section').forEach(s=>s.classList.remove('active'));
 document.getElementById(id).classList.add('active');

 document.querySelectorAll('.navbtn').forEach(b=>b.classList.remove('active'));
 btn.classList.add('active');
}

function search(inp,table){
 let f=document.getElementById(inp).value.toLowerCase();
 document.querySelectorAll("#"+table+" tbody tr").forEach(r=>{
  r.style.display=r.innerText.toLowerCase().includes(f)?"":"none";
 });
}
</script>
</head>

<body>

<div class="topbar">
 <button class="navbtn active" onclick="show('products',this)"> All Products</button>
 <button class="navbtn" onclick="show('addProduct',this)"> Add Product</button>
 <button class="navbtn" onclick="show('category',this)"> Category</button>
</div>

<div class="main">

<div id="products" class="section active card">


  <div class="product-header">
    <h2>All Products</h2>

    <div class="actions">
      <input id="ps" class="search"
             placeholder="Search product..."
             onkeyup="search('ps','ptable')">

      <a href="product.jsp?excel=1" class="btn save">
        ⬇ Export Excel
      </a>
    </div>
  </div>


  <table id="ptable">
  <thead>
    <tr>
      <th>ID</th>
      <th>Name</th>
      <th>Category</th>
      <th>Price</th>
      <th>Action</th>
    </tr>
  </thead>

  <tbody>
  <%
    PreparedStatement ps = con.prepareStatement(
      "SELECT p.product_id, p.product_name, c.category_name, p.price " +
      "FROM products p JOIN categories c ON p.category_id=c.category_id"
    );
    ResultSet rs = ps.executeQuery();
    while(rs.next()){
  %>
    <tr>
      <td><%=rs.getInt("product_id")%></td>
      <td><%=rs.getString("product_name")%></td>
      <td><%=rs.getString("category_name")%></td>
      <td>₹ <%=rs.getDouble("price")%></td>
      <td>
        <a href="product.jsp?editp=<%=rs.getInt("product_id")%>" class="btn edit">Edit</a>
        <a href="product.jsp?delp=<%=rs.getInt("product_id")%>" class="btn del">Delete</a>
      </td>
    </tr>
  <%
    }
  %>
  </tbody>
</table>
</div>


<div id="addProduct" class="section card">
<h2><%= eid==0?"Add Product":"Edit Product" %></h2>

<form method="post">
<input type="hidden" name="pid" value="<%=eid%>">

<input name="pname" value="<%=epname%>" placeholder="Product Name" 
<%= eid!=0 ? "readonly" : "" %> required>


<select name="cat" <%= eid!=0 ? "disabled" : "" %>>
<%
PreparedStatement cps=con.prepareStatement("SELECT * FROM categories");
ResultSet cr=cps.executeQuery();
while(cr.next()){
%>
<option value="<%=cr.getInt(1)%>" <%=cr.getInt(1)==ecat?"selected":""%>>
<%=cr.getString(2)%>
</option>
<% } %>
</select>

<% if(eid!=0){ %>
<input type="hidden" name="cat" value="<%=ecat%>">
<% } %>

<input name="price" value="<%=eprice%>" placeholder="Price" required>
<input name="stock" value="<%=estock%>" placeholder="Stock Quantity" required>

<button class="btn save" name="<%=eid==0?"saveProduct":"updateProduct"%>">
<%=eid==0?"Save Product":"Update Product"%>
</button>
</form>
</div>

<div id="category" class="section card">
<h2>Add Category</h2>
<div class="flex">

<form method="post" style="flex:1">
<input name="cname" placeholder="Category Name" required>
<textarea name="desc" placeholder="Description (optional)"></textarea>
<button class="btn save" name="saveCat">Add Category</button>
</form>

<div style="flex:1">
<input id="cs" placeholder="Search..." onkeyup="search('cs','ctable')">
<table id="ctable">
<tr><th>ID</th><th>Name</th><th>Action</th></tr>
<%
Statement st=con.createStatement();
ResultSet r2=st.executeQuery("SELECT * FROM categories");
while(r2.next()){
%>
<tr>
<td><%=r2.getInt(1)%></td>
<td><%=r2.getString(2)%></td>
<td>
<a href="product.jsp?delc=<%=r2.getInt(1)%>" class="btn del">Delete</a>
</td>
</tr>
<% } %>
</table>
</div>

</div>
</div>

</div>

</body>
</html>
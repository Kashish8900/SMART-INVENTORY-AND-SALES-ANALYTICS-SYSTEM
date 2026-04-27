<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Date" %> 
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.text.NumberFormat, java.util.*" %>

<%! NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("en", "IN")); %>

<%
String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
String DB_URL = "jdbc:mysql://localhost:3306/inventory_system";
String DB_USER = "root";
String DB_PASS = "kashish890";

String start_date = request.getParameter("start_date");
String end_date = request.getParameter("end_date");
String category_id_str = request.getParameter("category_id");

StringBuilder whereClause = new StringBuilder("WHERE 1=1");

if (start_date != null && !start_date.trim().isEmpty()) {
    whereClause.append(" AND DATE(i.date) >= '").append(start_date).append("'");
}
if (end_date != null && !end_date.trim().isEmpty()) {
    whereClause.append(" AND DATE(i.date) <= '").append(end_date).append("'");
}
if (category_id_str != null && !category_id_str.equals("0") && !category_id_str.trim().isEmpty()) {
    whereClause.append(" AND p.category_id = ").append(category_id_str);
}

Connection conn = null;
PreparedStatement stmt = null;
ResultSet rs = null;

double totalRevenue = 0.0, totalCost = 0.0, totalProfit = 0.0, margin = 0.0;
String profitClass = "profit-card";

try {
    Class.forName(JDBC_DRIVER);
    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

    // ✅ FIXED TOTAL QUERY
  String totalSql = "SELECT " +
    "(SELECT COALESCE(SUM(i.grand_total),0) FROM invoices i " + whereClause + ") AS revenue, " +
    "(SELECT COALESCE(SUM(ii.cost_price * ii.qty),0) " +
    " FROM invoice_items ii " +
    " JOIN products p ON ii.product_id = p.product_id " +
    " JOIN invoices i ON ii.invoice_id = i.id " +
    whereClause + ") AS cost";
    stmt = conn.prepareStatement(totalSql);
    rs = stmt.executeQuery();

    if (rs.next()) {
        totalRevenue = rs.getDouble("revenue");
        totalCost = rs.getDouble("cost");
        totalProfit = totalRevenue - totalCost;
        margin = (totalRevenue > 0) ? (totalProfit / totalRevenue) * 100 : 0.0;
        profitClass = totalProfit >= 0 ? "profit-card" : "loss-card";
    }

    rs.close();
    stmt.close();
    conn.close();

} catch (Exception e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Profit & Loss</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body { background:#f8f9fa; }
.stat-card { padding:20px; border-radius:12px; color:white; }
.revenue-card { background:#667eea; }
.cost-card { background:#f093fb; }
.profit-card { background:#27ae60; }
.loss-card { background:#e74c3c; }
</style>
</head>

<body>

<div class="container mt-4">

<h2 class="text-center mb-4">Profit & Loss Report</h2>

<!-- FILTER -->
<form method="GET" class="row mb-4">

<div class="col-md-3">
<input type="date" name="start_date" class="form-control" value="<%= start_date!=null?start_date:"" %>">
</div>

<div class="col-md-3">
<input type="date" name="end_date" class="form-control" value="<%= end_date!=null?end_date:"" %>">
</div>

<div class="col-md-3">
<select name="category_id" class="form-control">
<option value="0">All Categories</option>

<%
try {
    Class.forName(JDBC_DRIVER);
    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    stmt = conn.prepareStatement("SELECT category_id, category_name FROM categories");
    rs = stmt.executeQuery();

    while(rs.next()){
%>
<option value="<%=rs.getInt("category_id")%>" 
<%= (category_id_str!=null && category_id_str.equals(rs.getString("category_id")))?"selected":"" %>>
<%=rs.getString("category_name")%>
</option>
<%
    }
    rs.close(); stmt.close(); conn.close();
} catch(Exception e){ out.print("Error"); }
%>

</select>
</div>

<div class="col-md-2">
    <button type="submit" class="btn btn-primary w-100">Filter</button>
</div>

<div class="col-md-2">
    <a href="profit_loss.jsp" class="btn btn-secondary w-100">Clear</a>
</div>

</form>

<!-- CARDS -->
<div class="row mb-4">

    <div class="col-lg-3 col-md-6 mb-3">
        <div class="stat-card revenue-card text-center">
            <h5>Total Revenue</h5>
            <h3><%= nf.format(totalRevenue) %></h3>
        </div>
    </div>

    <div class="col-lg-3 col-md-6 mb-3">
        <div class="stat-card cost-card text-center">
            <h5>Total Cost</h5>
            <h3><%= nf.format(totalCost) %></h3>
        </div>
    </div>

    <div class="col-lg-3 col-md-6 mb-3">
        <div class="stat-card <%=profitClass%> text-center">
            <h5><%= totalProfit>=0?"Profit":"Loss" %></h5>
            <h3><%= nf.format(totalProfit) %></h3>
        </div>
    </div>

    <div class="col-lg-3 col-md-6 mb-3">
        <div class="stat-card text-center" style="background:#fd79a8;color:white;">
            <h5>Profit Margin</h5>
            <h3><%= String.format("%.2f", margin) %>%</h3>
        </div>
    </div>

</div>
<!-- TABLE -->
<table class="table table-bordered bg-white">

<tr>
<th>Invoice</th>
<th>Product</th>
<th>Qty</th>
<th>Selling</th>
<th>Cost</th>
<th>Profit</th>
<th>Date</th>
</tr>

<%
try {
    Class.forName(JDBC_DRIVER);
    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

    String detailSql = "SELECT " +
        "i.invoice_no, ii.product_name, ii.qty, " +
        "ii.price AS selling_price, " +
        		"p.price AS cost_price, " +
        		"(ii.price * ii.qty - p.price * ii.qty) AS profit, "+
        "i.date " +
        "FROM invoice_items ii " +
        "JOIN products p ON ii.product_id = p.product_id " +
        "JOIN invoices i ON ii.invoice_id = i.id " +
        whereClause +
        " ORDER BY i.date DESC";

    stmt = conn.prepareStatement(detailSql);
    rs = stmt.executeQuery();

    while(rs.next()){
%>

<tr>
<td><%=rs.getString("invoice_no")%></td>
<td><%=rs.getString("product_name")%></td>
<td><%=rs.getInt("qty")%></td>
<td><%=nf.format(rs.getDouble("selling_price"))%></td>
<td><%=nf.format(rs.getDouble("cost_price"))%></td>
<td><%=nf.format(rs.getDouble("profit"))%></td>
<td><%=rs.getTimestamp("date")%></td>
</tr>

<%
    }
    rs.close(); stmt.close(); conn.close();
} catch(Exception e){
%>

<tr><td colspan="7">Error: <%=e.getMessage()%></td></tr>

<%
}
%>

</table>

</div>

</body>
</html>
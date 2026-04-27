<%@ page import="java.sql.*" %>
<%
String role = request.getParameter("role");
if(role==null){
    response.sendRedirect("selectUser.jsp");
}

String mode = request.getParameter("mode");
if(mode==null) mode="login";

String errorMsg="";
String successMsg="";

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    con=DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/inventory_system","root","kashish890");
    if(request.getParameter("registerBtn")!=null){
        if("admin".equals(role)){
            ps=con.prepareStatement("SELECT * FROM admin WHERE name=? OR email=?");
            ps.setString(1,request.getParameter("name"));
            ps.setString(2,request.getParameter("email"));
            rs=ps.executeQuery();
            if(rs.next()){
                errorMsg="Admin with same name or email already exists!";
            } else {
                ps=con.prepareStatement("INSERT INTO admin(name,email,password) VALUES(?,?,?)");
                ps.setString(1,request.getParameter("name"));
                ps.setString(2,request.getParameter("email"));
                ps.setString(3,request.getParameter("password"));
                ps.executeUpdate();
                successMsg="Admin registered successfully! Please login.";
                mode="login";
            }
        } else {
            ps=con.prepareStatement("SELECT * FROM sales_executive WHERE name=? OR exec_id=?");
            ps.setString(1,request.getParameter("name"));
            ps.setInt(2,Integer.parseInt(request.getParameter("id")));
            rs=ps.executeQuery();
            if(rs.next()){
                errorMsg="Sales Executive with same name or ID already exists!";
            } else {
                ps=con.prepareStatement("INSERT INTO sales_executive(name,exec_id,password) VALUES(?,?,?)");
                ps.setString(1,request.getParameter("name"));
                ps.setInt(2,Integer.parseInt(request.getParameter("id")));
                ps.setString(3,request.getParameter("password"));
                ps.executeUpdate();
                successMsg="Sales Executive registered successfully! Please login.";
                mode="login";
            }
        }
    }
    if(request.getParameter("loginBtn")!=null){
        if("admin".equals(role)){
            ps=con.prepareStatement("SELECT * FROM admin WHERE name=? AND password=?");
            ps.setString(1,request.getParameter("name"));
            ps.setString(2,request.getParameter("password"));
            rs=ps.executeQuery();
            if(rs.next()){
                session.setAttribute("adminName", rs.getString("name"));
                session.setAttribute("adminId", rs.getInt("admin_id"));   
                response.sendRedirect("adminDashboard.jsp");
                return;
            } else { errorMsg="Invalid name or password."; }
        } else {
            ps=con.prepareStatement("SELECT * FROM sales_executive WHERE exec_id=? AND password=?");
            ps.setInt(1,Integer.parseInt(request.getParameter("id")));
            ps.setString(2,request.getParameter("password"));
            rs=ps.executeQuery();
            if(rs.next()){
                session.setAttribute("execName", rs.getString("name"));
                session.setAttribute("execId", rs.getInt("exec_id"));
                response.sendRedirect("salesDashboard.jsp");
                return;
            } else { errorMsg="Invalid Sales ID or password."; }
        }
    }

}catch(Exception e){ errorMsg=e.toString(); }
finally{
    if(rs!=null) rs.close();
    if(ps!=null) ps.close();
    if(con!=null) con.close();
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><%= "admin".equals(role) ? "Admin" : "Sales Executive" %> - Authentication</title>
    <style>
        
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

body {
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
}
.main-box {
    width: 900px;
    height: 500px;
    background: white;
    border-radius: 20px;
    display: flex;
    overflow: hidden;
    box-shadow: 0 20px 60px rgba(15,118,110,0.4)
    border: 1px solid rgba(15,118,110,0.15);
}

.left-panel {
    width: 40%;
   background: linear-gradient(90deg, #0f766e, #059669);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 40px;
    text-align: center;
}

.left-panel h2 {
    margin-bottom: 10px;
}

.left-panel p {
    font-size: 14px;
    opacity: 0.8;
}

.left-panel button {
    margin-top: 20px;
    padding: 10px 20px;
    border-radius: 20px;
    border: none;
    background:white;
    color: black;
    cursor: pointer;
}

.right-panel {
    width: 60%;
    padding: 50px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.form-title {
    font-size: 26px;
    margin-bottom: 20px;
    font-weight: bold;
}

.form-group {
    margin-bottom: 15px;
}

.form-group input {
    width: 100%;
    padding: 12px 15px;
    border-radius: 25px;
    border: 1px solid #ddd;
    outline: none;
    transition: 0.3s;
}

.form-group input:focus {
    border-color: #ff4ecd;
    box-shadow: 0 0 10px rgba(255,78,205,0.3);
}

.btn {
    padding: 12px;
    border: none;
    border-radius: 25px;
    background: linear-gradient(90deg, #0f766e, #059669);
    color: white;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
}

.btn:hover {
    transform: scale(1.05);
}

.alert {
    padding: 10px;
    border-radius: 10px;
    margin-bottom: 15px;
    font-size: 14px;
}

.error { background: #ffe0e0; color: red; }
.success { background: #e0ffe5; color: green; }

.toggle {
    margin-top: 15px;
    font-size: 14px;
}

.toggle a {
    color: linear-gradient(90deg, #0f766e, #059669);
    font-weight: bold;
    text-decoration: none;
}
    </style>
</head>
<body>
    <div class="main-box">
    <div class="left-panel">
        <h2>
    Welcome 
    <span style="color:white;">
        <%= "admin".equals(role) ? "Admin" : "Sales Executive" %>
    </span>!
</h2>
        <p>Manage your inventory smartly and efficiently.</p>
        <button onclick="location.href='selectUser.jsp'">Back</button>
    </div>

    <!-- RIGHT SIDE -->
    <div class="right-panel">

        <div class="form-title">
            <%= "register".equals(mode) ? "Create Account" : "Login" %>
        </div>

        <% if(!errorMsg.isEmpty()) { %>
            <div class="alert error"><%= errorMsg %></div>
        <% } %>

        <% if(!successMsg.isEmpty()) { %>
            <div class="alert success"><%= successMsg %></div>
        <% } %>

        <% if("login".equals(mode)){ %>

        <form method="post">
            <input type="hidden" name="role" value="<%=role%>">

            <% if("admin".equals(role)){ %>
                <div class="form-group">
                    <input type="text" name="name" placeholder="Admin Name" required>
                </div>
            <% } else { %>
                <div class="form-group">
                    <input type="number" name="id" placeholder="Sales ID" required>
                </div>
            <% } %>

            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>

            <button class="btn" name="loginBtn">Login</button>
        </form>

        <div class="toggle">
            Don't have an account?
            <a href="auth.jsp?role=<%=role%>&mode=register">Register</a>
        </div>
</div>
        <% } else { %>

        <form method="post">
            <input type="hidden" name="role" value="<%=role%>">

            <div class="form-group">
                <input type="text" name="name" placeholder="Full Name" required>
            </div>

            <% if("admin".equals(role)){ %>
                <div class="form-group">
                    <input type="email" name="email" placeholder="Email" required>
                </div>
            <% } else { %>
                <div class="form-group">
                    <input type="number" name="id" placeholder="Sales ID" required>
                </div>
            <% } %>

            <div class="form-group">
                <input type="password" name="password" placeholder="Password" required>
            </div>

            <button class="btn" name="registerBtn">Register</button>
        </form>

        <div class="toggle">
            Already have an account?
            <a href="auth.jsp?role=<%=role%>&mode=login">Login</a>
        </div>

        <% } %>
    </div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Inventory Management System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
            padding: 40px 20px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 60px;
            padding: 0 20px;
        }

        .logo {
            font-size: 24px;
            font-weight: 700;
            color: #0f766e;
        }

        .nav {
            display: flex;
            gap: 30px;
        }

        .nav a {
            color: #475569;
            text-decoration: none;
            font-weight: 500;
            font-size: 15px;
            transition: color 0.3s;
        }

        .nav a:hover {
            color: #0f766e;
        }

        .main-container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 60px;
            align-items: center;
        }

        .content-section {
            padding-right: 40px;
        }

        .main-title {
            font-size: 48px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 20px;
            line-height: 1.2;
        }

        .subtitle {
            font-size: 20px;
            color: #475569;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .cta-buttons {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }

        .btn-primary {
            padding: 16px 32px;
            background: linear-gradient(90deg, #0f766e, #059669);
            color: white;
            text-decoration: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            box-shadow: 0 8px 24px rgba(15,118,110,0.3);
            transition: all 0.3s ease;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 32px rgba(15,118,110,0.4);
        }

        .btn-secondary {
            padding: 16px 32px;
            background: transparent;
            border: 2px solid #0f766e;
            color: #0f766e;
            text-decoration: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-secondary:hover {
            background: #0f766e;
            color: white;
            transform: translateY(-2px);
        }

     
        .illustration {
            position: relative;
            height: 500px;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }

        .hero-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
        }

        .features {
            margin-top: 80px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 30px;
            padding: 0 20px;
        }

        .feature-card {
            background: white;
            padding: 32px;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            text-align: center;
            border: 1px solid rgba(15,118,110,0.1);
            transition: all 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 40px rgba(0,0,0,0.15);
        }

        .feature-icon {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #0f766e, #059669);
            border-radius: 16px;
            margin: 0 auto 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }

        .feature-title {
            font-size: 20px;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 12px;
        }

        .feature-desc {
            color: #64748b;
            line-height: 1.6;
        }
    </style>
</head>
<body>
 
    <div class="header">
        <div class="logo">WELCOME USERS</div>
        <div class="nav">
            <a href="#">Home</a>
            <a href="#">Features</a>
            <a href="#">Company</a>
            <a href="#">Pricing</a>
           
        </div>
    </div>

  
    <div class="main-container">
        <div class="content-section">
            <h1 class="main-title">Inventory Management</h1>
            <p class="subtitle">
                Advanced inventory tracking, sales analytics, and business 
                management tools designed for modern businesses.
            </p>
            <div class="cta-buttons">
       
                <a href="selectUser.jsp" class="btn-secondary">Get Started</a>
            </div>
        </div>
        
        <div class="illustration">
            <img src="invt.jpg" alt="Inventory Management Illustration" class="hero-image">
        </div>
    </div>

    <div class="features">
        <div class="feature-card">
            <div class="feature-icon">📦</div>
            <h3 class="feature-title">Real-time Tracking</h3>
            <p class="feature-desc">Monitor inventory levels, track stock movements, and receive instant alerts.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">📊</div>
            <h3 class="feature-title">Sales Analytics</h3>
            <p class="feature-desc">Get insights into sales performance, trends, and profitability with powerful dashboards.</p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🔒</div>
            <h3 class="feature-title">Secure & Scalable</h3>
            <p class="feature-desc">Enterprise-grade security and scalability for businesses of all sizes.</p>
        </div>
    </div>
</body>
</html>
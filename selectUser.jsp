<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
   
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
            padding: 60px 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .container {
            background: white;
            padding: 60px 70px;
            border-radius: 24px;
            text-align: center;
            max-width: 500px;
            width: 100%;
            box-shadow: 0 20px 50px rgba(0,0,0,0.1);
            border: 1px solid rgba(15,118,110,0.15);
        }

        .logo {
            font-size: 20px;
            font-weight: 700;
            color: #0f766e;
            margin-bottom: 20px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .main-title {
            font-size: 32px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 15px;
            line-height: 1.3;
        }

        .subtitle {
            font-size: 16px;
            color: #64748b;
            margin-bottom: 40px;
            line-height: 1.6;
        }

        .btn-container {
            display: flex;
            gap: 20px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .user-btn {
            padding: 16px 40px;
            font-size: 16px;
            font-weight: 600;
            border-radius: 12px;
            border: 2px solid #0f766e;
            background: transparent;
            color: #0f766e;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 200px;
            text-decoration: none;
            display: inline-block;
        }

        .user-btn:hover {
            background: linear-gradient(90deg, #0f766e, #059669);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(15,118,110,0.3);
        }

        .user-btn.admin {
            border-color: #0f766e;
        }

        .user-btn.sales {
            border-color: #059669;
        }

        .back-link {
            display: inline-block;
            margin-top: 30px;
            color: #64748b;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: color 0.3s;
        }

        .back-link:hover {
            color: #0f766e;
        }

        @media (max-width: 600px) {
            .container {
                padding: 40px 30px;
                margin: 20px;
            }
            
            .btn-container {
                flex-direction: column;
                align-items: center;
            }
            
            .user-btn {
                width: 100%;
                max-width: 280px;
            }
            
            .main-title {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
       
       

        <h1 class="main-title">Select User Type</h1>
        

        <!-- User Selection Buttons -->
        <div class="btn-container">
            <a href="auth.jsp?role=admin" class="user-btn admin">
                 Admin Dashboard
            </a>
            <a href="auth.jsp?role=sales" class="user-btn sales">
                 Sales Executive
            </a>
        </div>

        <!-- Back Link -->
        <a href="landing.jsp" class="back-link"> Back to Home</a>
    </div>
</body>
</html>
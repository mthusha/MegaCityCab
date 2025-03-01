<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ page import="com.megacitycab.config.JwtTokenProvider" %>
<%@ page import="com.megacitycab.auth.Users" %>
<%@ page import="com.megacitycab.dao.UserDAO" %>

<%
    Cookie[] cookies = request.getCookies();
    String token = null;
    String username = null;

    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if ("token".equals(cookie.getName())) {
                token = cookie.getValue();
                break;
            }
        }
    }

    if (token != null && JwtTokenProvider.getInstance().validateToken(token)) {
        username = JwtTokenProvider.getInstance().getUsernameFromToken(token);
    }

    UserDAO userDAO = UserDAO.getInstance();
    Users user = username != null ? userDAO.findByUsername(username) : null;
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="header">
    <div class="logo">MyTaxi</div>
   <div class="profile_container">
       <div style="text-align: center; place-content: center; position: absolute; right: 0;margin-right: 20px;">
           <% if (user != null) { %>
               <span class="name_container" style="margin-right: 5px; margin-top: 5.5px; font-size: 16px; color: #555555;font-weight: bold;">
                   Hi, <%= user.getUsername() %>
               </span>
                      <div id="profile_dropdown" class="dropdown-menu">
                           <ul>
                               <li><a href="${pageContext.request.contextPath}/profile.jsp">View</a></li>
                              <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                           </ul>
                       </div>
                <a href ="#"><span id="profile_options"><i class="fa-solid fa-chevron-down"></i></span></a>
           <% } else { %>
               <a href="${pageContext.request.contextPath}/login" style="text-decoration: none; color: inherit;">
                   <i style="margin-right: 20px; margin-top: 5.5px; font-size: 22px;" class="fa-solid fa-right-to-bracket"></i>
               </a>
           <% } %>
       </div>

     <div class="menu-toggle" id="menu-toggle">
           <span></span>
           <span></span>
           <span></span>
       </div>
   </div>
</div>

<nav class="nav-menu" id="nav-menu">
    <div class="close-btn" id="close-btn">&times;</div>
    <a href="index.jsp">Home</a>
    <a href="#">About</a>
    <a href="#">Services</a>
    <a href="#">Contact</a>
</nav>

<!-- Styles specific to the header -->
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: Arial, sans-serif;
    }
    .profile_container{
    display:flex
    }
    .header {
        display: flex;
        justify-content: space-around;
        align-items: center;
        padding: 30px;
        background-color: #fff;
        position: fixed;
        width: 100%;
        top: 0;
        z-index: 1000;

    }

    .logo {
        font-size: 24px;
        color: #333;
    }

    .menu-toggle {
        display: flex;
        flex-direction: column;
        cursor: pointer;
    }

    .menu-toggle span {
        height: 3px;
        width: 25px;
        background: #000;
        margin: 4px 0;
        transition: 0.4s;
    }

    .nav-menu {
        position: fixed;
        top: 0;
        right: -300px;
        width: 300px;
        height: 100vh;
        background: #fff;
        flex-direction: column;
        padding: 60px 20px;

        transition: right 0.3s ease;
        z-index: 9999;
    }

    .nav-menu.show {
        right: 0;
    }

    .nav-menu a {
        text-align: center;
        text-decoration: none;
        color: #333;
        font-size: 20px;
        margin-bottom: 20px;
        display: block;
        transition: color 0.3s ease;
    }

    .nav-menu a:hover {
        color: #007BFF;
    }
.dropdown-menu {
    display: none;
    position: absolute;
    right: -10px;
    top: 40px;
    background: #262626;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    border-radius: 5px;
    width: 150px;
    z-index: 1000;
}

.dropdown-menu ul {
    list-style: none;
    margin: 0;
    padding: 0;
}

.dropdown-menu ul li {
    padding: 10px;
    border-bottom: 1px solid #ddd;
}

.dropdown-menu ul li:last-child {
    border-bottom: none;
}

.dropdown-menu ul li a {
        text-decoration: none;
        color: #ffea2e;
        display: block;
        font-weight: bold;
}

.dropdown-menu ul li:hover {
    background: #000000;
}

    .close-btn {
        position: absolute;
        top: 20px;
        right: 20px;
        font-size: 30px;
        cursor: pointer;
        color: #333;
    }
 @media (max-width: 1400px) {
   .header {
      justify-content: space-between;
      }
   .profile_container {
      display: flex;
      margin-right: 50px;
        }
   .name_container{
    display:none;
     }
       }

</style>

<!-- JavaScript for toggle behavior -->
<script>
    const toggle = document.getElementById('menu-toggle');
    const navMenu = document.getElementById('nav-menu');
    const closeBtn = document.getElementById('close-btn');
    const toggleSpans = toggle.querySelectorAll('span');


    toggle.addEventListener('click', () => {
        navMenu.classList.add('show');
        toggleSpans.forEach(span => span.style.backgroundColor = 'transparent');
    });

    closeBtn.addEventListener('click', () => {
        navMenu.classList.remove('show');
        toggleSpans.forEach(span => span.style.backgroundColor = 'black');
    });

    document.addEventListener('click', (event) => {
        if (!navMenu.contains(event.target) && !toggle.contains(event.target)) {
            navMenu.classList.remove('show');
            toggleSpans.forEach(span => span.style.backgroundColor = 'black');
        }
    });

   document.addEventListener("DOMContentLoaded", function () {
       const profileOptions = document.getElementById("profile_options");
       const dropdownMenu = document.getElementById("profile_dropdown");
       if (profileOptions && dropdownMenu) {
           profileOptions.addEventListener("click", function (event) {
               event.stopPropagation();
               dropdownMenu.style.display = dropdownMenu.style.display === "block" ? "none" : "block";
           });

           document.addEventListener("click", function (event) {
               if (!profileOptions.contains(event.target) && !dropdownMenu.contains(event.target)) {
                   dropdownMenu.style.display = "none";
               }
           });
       }
   });


</script>

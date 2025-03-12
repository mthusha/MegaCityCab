
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
<style>
.sidebar {
    width: 200px;
    float: left;
    height: 86vh;
    background-color: #ffffff;
    color: pink;
    padding: 20px;
    box-sizing: border-box;
    transition: transform 0.3s ease;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}
.sidebar ul {
    list-style-type: none;
    padding: 0;
    margin: 0;
}
.sidebar ul li {
    margin: 20px 0;
}
.sidebar ul li a {
   color: #f5c335;
   text-decoration: none;
   display: flex;
   align-items: center;
   padding: 10px;
   font-weight: 600;
   border-radius: 10px;
   transition: background 0.3s;
}
.sidebar ul li a i {
    margin-right: 10px;
    width: 20px;
    text-align: center;
}
.sidebar ul li a:hover, .sidebar ul li a.active {
    background-color: #444;
    border-radius: 10px;
}

.settings {
    margin-top: auto;
}
iframe {
            width: 100%;
            min-height: 750px;
            border: none;
        }
@media (max-width: 768px) {
    .sidebar {
        transform: translateX(-100%);
        position: fixed;
        top: 0;
        left: 0;
        z-index: 1000;
    }
    .sidebar.show {
        transform: translateX(0);
    }
    .sidebar ul li a {
        font-size: 14px;
    }
}
</style>

<div class="sidebar">
    <ul>
        <li><a href="pages/dashboard.jsp" target="contentFrame" class="active"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
        <li><a href="/Gradle___com_MegaCityCab___MegaCityCab_1_0_SNAPSHOT_war/admin/booking" target="contentFrame"><i class="fa-regular fa-rectangle-list"></i> Bookings</a></li>
        <li><a href="/Gradle___com_MegaCityCab___MegaCityCab_1_0_SNAPSHOT_war/admin/customers" target="contentFrame"><i class="fas fa-user"></i>Customer</a></li>
        <li><a href="/Gradle___com_MegaCityCab___MegaCityCab_1_0_SNAPSHOT_war/admin/cabs" target="contentFrame"><i class="fas fa-car"></i> Caps</a></li>
        <li><a href="/Gradle___com_MegaCityCab___MegaCityCab_1_0_SNAPSHOT_war/admin/drivers" target="contentFrame"><i class="fas fa-car"></i> Driver</a></li>
        <li><a href="/Gradle___com_MegaCityCab___MegaCityCab_1_0_SNAPSHOT_war/admin/bills" target="contentFrame"><i class="fa-solid fa-money-bill"></i> Bills</a></li>
    </ul>
    <ul class="settings">
        <li><a href="pages/settings.jsp" target="contentFrame"><i class="fas fa-cog"></i> Settings</a></li>
    </ul>
</div>

<script>
document.querySelectorAll('.sidebar ul li a').forEach(link => {
    link.addEventListener('click', () => {
        document.querySelectorAll('.sidebar ul li a').forEach(item => item.classList.remove('active'));
        link.classList.add('active');
    });
});
</script>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
.toggle-btn{
display:none;
}
.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 20px;
    /* background-color: #1a3c55; */
    color: white;
    /* box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2); */
    border-radius: 10px;
    /* margin: 10px; */
}

    .toggle-box {
        display: none;
    }

    .profile-section {
        display: flex;
        align-items: center;
        gap: 15px;
    }

    .profile-pic {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid white;
    }

    .username {
        margin-right: 10px;
        font-size: 16px;
        font-weight: 500;
        color: #edc553;
    }

    .toggle-btn {
        display: none;
        height: 100%;
        position: relative;
        z-index: 1001;
        background-color: #222;
        color: #ff69b4;
        border: none;
        padding: 10px;
        cursor: pointer;
        border-radius: 5px;
        transition: background-color 0.3s;
    }

    .toggle-btn:hover {
        background-color: #333;
    }

    @media (max-width: 768px) {
        .toggle-btn {
            display: block;
        }
        .profile-section {
            display: none;
        }
    }
</style>

<div class="header">
<div class="toggle-box">
<button class="toggle-btn" onclick="document.querySelector('.sidebar').classList.toggle('show')">☰</button>
</div>
    <h1></h1>
    <div class="profile-section">
            <img src="Gradle___com_MegaCityCab___MegaCityCab_1_0_SNAPSHOT_war/../../resource/img/min.jpg" alt="Profile Picture" class="profile-pic">
            <span class="username">John Doe</span>
        </div>
</div>

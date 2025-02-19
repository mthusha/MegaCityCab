<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<style>
.toggle-btn{
display:none;
}
.header{
    display: flex;
    justify-content: space-between;
}
@media (max-width: 768px) {
     .toggle-btn{
     display:block;
     }
    .toggle-btn {
     height: 100%;
     position: relative;
     /* top: 20px; */
     /* left: 20px; */
     z-index: 1001;
     background-color: #222;
     color: pink;
     border: none;
     padding: 10px;
     cursor: pointer;
    }
}
</style>

<div class="header">
<div class="toggle-box">
<button class="toggle-btn" onclick="document.querySelector('.sidebar').classList.toggle('show')">☰</button>
</div>
    <h1>My Application Header</h1>
</div>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Performance Report Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f7fa;
        }
        .dashboard {
            max-width: 1200px;
            margin: 0 auto;
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        /* Header Styling */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            background-color: #1a3c55; /* Dark blue header background */
            color: white;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2); /* Subtle shadow for depth */
            border-radius: 10px; /* Slight rounding for elegance */
            margin-bottom: 20px;
        }

        .toggle-box {
            display: none; /* Hidden by default on desktop */
        }

        .profile-section {
            display: flex;
            align-items: center;
            gap: 15px; /* Space between image and username */
        }

        .profile-pic {
            width: 40px; /* Size of the profile picture */
            height: 40px;
            border-radius: 50%; /* Circular shape */
            object-fit: cover; /* Ensure image fits without distortion */
            border: 2px solid white; /* White border for contrast */
        }

        .username {
            font-size: 16px;
            font-weight: 500;
            color: #f0f0f0; /* Light color for text */
        }

        .toggle-btn {
            display: none; /* Hidden by default on desktop */
            height: 100%;
            position: relative;
            z-index: 1001;
            background-color: #222;
            color: #ff69b4; /* Pink color for toggle button */
            border: none;
            padding: 10px;
            cursor: pointer;
            border-radius: 5px; /* Rounded corners for button */
            transition: background-color 0.3s; /* Smooth hover effect */
        }

        .toggle-btn:hover {
            background-color: #333; /* Darker shade on hover */
        }

        @media (max-width: 768px) {
            .toggle-btn {
                display: block; /* Show toggle button on mobile */
            }
            .profile-section {
                display: none; /* Hide profile on mobile to save space */
            }
            .header h2 {
                font-size: 18px; /* Smaller font size on mobile */
            }
        }

        /* Sidebar for toggle functionality */
        .sidebar {
            width: 0;
            position: fixed;
            top: 0;
            left: 0;
            height: 100%;
            background-color: #333;
            overflow-x: hidden;
            transition: 0.5s;
            padding-top: 60px;
        }

        .sidebar.show {
            width: 250px; /* Width when sidebar is shown */
        }

        /* Existing Dashboard Styles */
        .date-range {
            color: #f0f0f0; /* Light color to match header */
            font-size: 14px;
        }

        .kpi-container {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }

        .kpi {
            text-align: center;
            padding: 15px;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .kpi-value {
            font-size: 24px;
            font-weight: bold;
            color: #1a3c55;
        }

        .kpi-label {
            color: #666;
            font-size: 14px;
        }

        .trend-up {
            color: green;
        }

        .trend-down {
            color: red;
        }

        .charts-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px; /* Add margin to separate from next section */
        }

        .chart {
            background: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        /* Add a fixed height to the canvas container */
        .chart-canvas-container {
            position: relative;
            height: 200px; /* Fixed height for charts */
            width: 100%;
        }

        canvas {
            width: 100% !important;
            height: 100% !important;
        }

        .legend {
            display: flex;
            justify-content: space-around;
            margin-top: 10px;
        }

        .legend-item {
            display: flex;
            align-items: center;
        }

        .legend-item span {
            width: 12px;
            height: 12px;
            margin-right: 5px;
            display: inline-block;
        }

        /* Update legend colors to match new chart colors */
        .legend-item.primary span {
            background: #f5c335 !important; /* Primary chart color */
        }

        .legend-item.secondary span {
            background: #d4a017 !important; /* Secondary chart color */
        }
    </style>
    <!-- Include Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="dashboard">

        <div class="kpi-container">
            <div class="kpi">
                <div class="kpi-value">100</div>
                <div class="kpi-label">Total leads <span class="trend-down">(-3.5%)</span></div>
            </div>
            <div class="kpi">
                <div class="kpi-value">80</div>
                <div class="kpi-label">Total called leads <span class="trend-down">(-15%)</span></div>
            </div>
            <div class="kpi">
                <div class="kpi-value">120</div>
                <div class="kpi-label">Total applications <span class="trend-up">(+2%)</span></div>
            </div>
            <div class="kpi">
                <div class="kpi-value">18,000</div>
                <div class="kpi-label">Total sales <span class="trend-up">(+2%)</span></div>
            </div>
        </div>
        <div class="charts-container">
            <div class="chart">
                <h3>Costs</h3>
                <div class="chart-canvas-container">
                    <canvas id="pieChart"></canvas>
                </div>
                <div class="legend">
                    <div class="legend-item primary"><span></span>Cost in time frame: 41,077.48</div>
                    <div class="legend-item secondary"><span></span>Cost per sale: 225.29</div>
                </div>
                <p>Total costs: 120,640.50</p>
            </div>
            <div class="chart">
                <h3>Leads & Applications</h3>
                <div class="chart-canvas-container">
                    <canvas id="barChart1"></canvas>
                </div>
                <div class="legend">
                    <div class="legend-item primary"><span></span>Total Leads: 2,203</div>
                    <div class="legend-item secondary"><span></span>Bad Leads: 587</div>
                </div>
            </div>
        </div>
        <div class="chart">
            <h3>Total Leads</h3>
            <div class="chart-canvas-container">
                <canvas id="barChart2"></canvas>
            </div>
        </div>
    </div>

    <!-- Sidebar for toggle functionality -->
    <div class="sidebar">
        <!-- Sidebar content can go here -->
    </div>

    <script>
        // Pie Chart for Costs
        const ctxPie = document.getElementById('pieChart').getContext('2d');
        new Chart(ctxPie, {
            type: 'pie',
            data: {
                labels: ['Cost in time frame', 'Cost per sale'],
                datasets: [{
                    data: [41077.48, 225.29], // Sample data
                    backgroundColor: ['#f5c335', '#d4a017'] // Updated colors
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });

        // Bar Chart for Leads & Applications
        const ctxBar1 = document.getElementById('barChart1').getContext('2d');
        new Chart(ctxBar1, {
            type: 'bar',
            data: {
                labels: ['Abstergo', 'Acme Co.', 'Barone', 'Biffco Ent.', 'Big Kahuna'],
                datasets: [{
                    label: 'Total Leads',
                    data: [1000, 600, 400, 300, 500],
                    backgroundColor: '#f5c335' // Updated color
                }, {
                    label: 'Bad Leads',
                    data: [200, 100, 50, 80, 150],
                    backgroundColor: '#d4a017' // Updated secondary color
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Bar Chart for Total Leads
        const ctxBar2 = document.getElementById('barChart2').getContext('2d');
        new Chart(ctxBar2, {
            type: 'bar',
            data: {
                labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5'],
                datasets: [{
                    label: 'Total Leads',
                    data: [200, 150, 300, 250, 400],
                    backgroundColor: '#f5c335' // Updated color
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Optional: Close sidebar when clicking outside
        document.addEventListener('click', function(event) {
            const sidebar = document.querySelector('.sidebar');
            const toggleBtn = document.querySelector('.toggle-btn');
            if (!sidebar.contains(event.target) && !toggleBtn.contains(event.target) && sidebar.classList.contains('show')) {
                sidebar.classList.remove('show');
            }
        });
    </script>
</body>
</html>
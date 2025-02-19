<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mega City Cab</title>
    <style>
        body, html {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }
        .first_section{
            background-color: #f5c335;
        }
        .home-section {
            display: flex;
            flex-direction: row;
            align-items: center;
            justify-content: space-between;
            background-color: #f5c335;
            width: calc(((100% - 1140px) / 2) + 1140px);
            margin: 0 0 0 auto;
        }

        .info {
            max-width: 50%;
            padding: 20px;
        }

        .u-text-1 {
            font-family: fangsong;
                /* font-family: ui-sans-serif; */
                font-size: 1.25rem;
                line-height: 1.2;
                background-image: none;
                letter-spacing: 6px;
                /* font-family: "PT Sans", sans-serif; */
                text-transform: uppercase;
                font-weight: 400;
                margin: 0;
                font-size: 14px;
                letter-spacing: 2px;
                color: #333;
                margin-bottom: 10px;
        }

        .u-text-2 {
                font-size: 3.75rem;
                letter-spacing: normal;
                font-family: -webkit-body;
                font-weight: 600;
                text-transform: none;
                margin: 9px 0 0;
                /* font-size: 48px; */
                color: #686451;
                /* margin: 10px 0;*/
        }

        .u-text-3 {
            font-size: 14px;
            color: #555;
            margin: 18px 0 0;
        }

        .u-btn-1 {
            color: #555;
            text-decoration: underline;
        }

        .u-btn-2 {
           border-radius: 10px;
           display: inline-block;
           background-color: #333;
           color: #fff;
           text-decoration: none;
           background-image: none;
           text-transform: uppercase;
           letter-spacing: 3px;
           font-weight: 700;
           font-size: 1.5rem;
           border-style: none;
           margin: 45px auto 0 0;
           padding: 15px 50px;
        }

        .image_c {
            min-height: 691px;
            background-image: url('resource/img/min.jpg');
            background-position: center;
            background-size: cover;
            background-repeat: no-repeat;
            width: 50%;
        }
        @media (max-width: 1199px) {
         .home-section {
            width: calc(((100% - 1070px) / 2) + 940px);
                }
        }
        @media (max-width: 768px) {
            .home-section {
                flex-direction: column;
                padding: 10px;
            }

            .info, .image_c {
                 margin-top: 20px;
                max-width: 100%;

            }

            .u-text-2 {
                font-size: 36px;
            }

            .u-btn-2 {
                width: 100%;
                text-align: center;
            }

            .image_c {
                min-height: 620px;
            }
            .home-section {
                background-color: #f3c748;

            }
            .home-section {
                width: 100%;
             }
             .image_c {
                 width: 100%;
             }
        }
        @media (max-width: 468px) {
            .home-section {
                width:100%
            }
            .u-text-2 {
                margin: 15px 0 0;

            }
             .image_c {
             min-height: 500px;
             }
            .home-section {
                background-color: #f2c74c;

            }
        }
    </style>
</head>
<body>

    <%@ include file="utilities/header.jsp" %>

    <div style="margin-top: 80px;">
        <section class="out_section first_section">
        <div class="home-section">
            <div class="u-container info">
                <h5 class="u-text-1">CALL US ANYTIME AT:</h5>
                <h1 class="u-text-2">987-654-321&nbsp;<span style="font-size: 2rem;">or</span><br>456-789-321</h1>
                <p class="u-text-3">Power by <a href="https://www.freepik.com/photos/coffee" class="u-btn-1" target="_blank">Mega City Cab</a></p>
                <a href="user/booking.jsp" class="u-btn-2">Book Now</a>
            </div>
            <div class="u-container image_c"></div>
        </section>
        </div>
    </div>
</body>

</html>

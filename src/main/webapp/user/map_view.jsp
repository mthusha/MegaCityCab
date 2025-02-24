<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Taxi Booking Form</title>
    <script src="<%= request.getContextPath() %>/resource/js/polyfill.min.js"></script>
       <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {

            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;

            width: 100%;
        }
        .form-container {
            height: 92.5%;
            background-color: #fff;
            padding: 2rem;
            border-radius: 0 10px 10px 0;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            /* width: 100%; */
            /* max-width: 400px; */
            position: absolute;
            /* top: 20px; */
            /* left: 50%; */
            /* transform: translateX(-50%); */
            z-index: 1;
        }
        .form-container h2 {
            margin-bottom: 1.5rem;
            text-align: center;
            color: #333;
        }
        .form-container label {
            display: block;
            margin-top: 1rem;
            color: #555;
        }
        .form-container input {
            width: 100%;
            padding: 0.5rem;
            margin-top: 0.5rem;
            border: 1px solid #ffffff;
            background-color: #ebebeb;
            border-radius: 5px;
            font-size: 13px;
        }
        .form-container button {
               margin-top: 1.5rem;
               width: 100%;
               padding: 5px;
               border: none;
               border-radius: 5px;
               background-color: #007BFF;
               color: #fff;
               font-size: 14px;
               cursor: pointer;
               transition: background-color 0.3s;
        }
        .form-container button:hover {
            background-color: #0056b3;
        }
        #map {
            height: 100%;
            width: 100%;
            position: absolute;
            top: 0;
            left: 0;
            z-index: 0;
        }
        #distance {
            margin-top: 1rem;
            text-align: center;
            font-size: 1.2rem;
            color: #333;
        }
        .down_section{
         display: flex;
         gap: 5px;

        }
 @media (max-width: 900px), (max-device-width: 900px) {
     .form-container {
         height: 25%;
         background-color: #fff;
         padding: 2rem;
         border-radius: 0 0 10px 10px;
         box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
         width: 92.7%;
         position: absolute;
         z-index: 1;
     }
     .map_select_items {
         display: flex;
         justify-content: space-between;
     }
     #mapModal {
         padding: 0 !important;
     }
     .down_section{
              display: inline;
              gap: 5px;

   }
   .form-container button {
      width: fit;

           }
 }

    </style>
</head>
<body>
    <div id="map"></div>
    <div class="form-container">
        <h2>Taxi Booking Form</h2>
        <form class="map_select_items">
        <div class="up_section">
            <label for="from">From Location:</label>
            <input type="text" id="from" placeholder="Click on map to select start" required readonly>

            <label for="to">To Location:</label>
            <input type="text" id="to" placeholder="Click on map to select destination" required readonly>

            <div id="distance"></div>
        </div>

        <div class="down_section">
            <button type="button" onclick="resetSelection()"><i class="fa-solid fa-repeat"></i></button>
            <button type="submit"><i class="fa-regular fa-circle-xmark"></i></button>
        </div>
        </form>
    </div>

    <script>
        let map;
        let markers = [];
        let geocoder;
        let directionsService;
        let directionsRenderer;

            function initMap() {
                    map = new google.maps.Map(document.getElementById("map"), {
                        center: { lat: 37.7749, lng: -122.4194 },
                        zoom: 12,
                    });
                    geocoder = new google.maps.Geocoder();
                    directionsService = new google.maps.DirectionsService();
                    directionsRenderer = new google.maps.DirectionsRenderer();
                    directionsRenderer.setMap(map);

                    map.addListener("click", (event) => {
                        if (markers.length < 2) {
                            const marker = new google.maps.Marker({
                                position: event.latLng,
                                map: map,
                            });
                            markers.push(marker);
                            geocodeLatLng(event.latLng, markers.length === 1 ? 'from' : 'to');

                            if (markers.length === 2) {
                                calculateAndDisplayRoute();
                            }
                        } else {
                            alert('You can only select two locations: start and end.');
                        }
                    });
                }

        function geocodeLatLng(latLng, inputId) {
            geocoder.geocode({ location: latLng }, (results, status) => {
                if (status === "OK" && results[0]) {
                    const address = results[0].formatted_address;
                    document.getElementById(inputId).value = address;

                    window.parent.postMessage({ type: inputId, address: address }, "*");

                } else {
                    alert("Geocoder failed due to: " + status);
                }
            });
        }

        function calculateAndDisplayRoute() {
            const origin = markers[0].position;
            const destination = markers[1].position;

            directionsService.route({
                origin: origin,
                destination: destination,
                travelMode: google.maps.TravelMode.DRIVING,
            }, (response, status) => {
                if (status === 'OK') {
                    directionsRenderer.setDirections(response);
                    const distance = response.routes[0].legs[0].distance.text;
                    document.getElementById('distance').innerText = "Distance: " +distance;
                    window.parent.postMessage({ type: "distance", distance: distance }, "*");
                } else {
                    alert('Directions request failed due to ' + status);
                }
            });
        }

        function resetSelection() {
            markers.forEach(marker => marker.map = null);
            markers = [];
            directionsRenderer.setDirections({ routes: [] });
            document.getElementById('from').value = '';
            document.getElementById('to').value = '';
            document.getElementById('distance').innerText = '';
        }

        window.initMap = initMap;
    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA4flsw_NgYeNUW-8xjMjDynxmLH4XjFag&callback=initMap&libraries=places,geometry" async defer></script>
</body>
</html>

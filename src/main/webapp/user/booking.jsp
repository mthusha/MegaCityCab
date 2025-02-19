
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.min.css" rel="stylesheet" />
    <style>
    .div-body {
                   height: fit-content;
                margin-top: 94px;
                position: relative;
                background-color: #eff1f6;;
            }
                .h4, h4 {
                    font-weight: 600;
                }
         .btn-success {
             border: none;
             background-color: #edc553;
         }
         .btn-success:hover {
              background-color:#ffc112;
             }
           .p-4 {
           border:none;
             }
            .map-overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                backdrop-filter: blur(10px);
                -webkit-backdrop-filter: blur(10px);
                background: rgba(255, 255, 255, 0.5);
                z-index: 0;
                pointer-events: none;
            }

            .map {
                 height: 100%;
                    width: 100%;
                    position: absolute;
                    top: 0;
                    left: 0;
                    z-index: 0;

                    background-size: cover;
                    background-position: center;
                    filter: blur(10px);
            }
            .book-head{

            }
         .flex-block{
             display: inline-grid;
         }
         .address_show{
          max-width: 50%;
          font-size: small !important;
         }
         .mx-auto{
         margin:0 !important;
         }
         .booking-time-select{
             height: 35px;
             padding: 10px;
         }
         .end-0 {
             right: 8 !important;
         }
         .booking-date-pick{
            max-width: fit-content;
            padding: 5px;
         }
         .flex-box{
         display:flex;
         justify-content: space-between;
         margin-top:10px;
         margin-bottom:10px;
         }
       .header-container {
           place-items: center;
         background-color: #0c1a2b; ;
         padding: 20px;
         text-align: center;
      }

      .header-title {
       color: white;
       font-size: 26px;
       font-weight: bold;
}

.table>:not(caption)>*>* {
    border: none;
    background-color: #eaeaea;
    padding: .5rem .5rem;
    color: var(--bs-table-color-state, var(--bs-table-color-type, var(--bs-table-color)));
    /* background-color: var(--bs-table-bg); */
    /* border-bottom-width: var(--bs-border-width); */
    /* box-shadow: inset 0 0 0 9999px var(--bs-table-bg-state, var(--bs-table-bg-type, var(--bs-table-accent-bg))); */
}
        @media (max-width: 768px) {
            .container{
                width: 100% !important;
            }
        }
        .list-group-item {
            position: relative;
            display: block;
            padding: var(--bs-list-group-item-padding-y) var(--bs-list-group-item-padding-x);
            color: var(--bs-list-group-color);
            text-decoration: none;
            background-color: var(--bs-list-group-bg);
            border:none;
            border-bottom: 1px dashed #ccc;
            font-size: 13px;
        }
@media (min-width: 768px) {
    .container, .container-md, .container-sm {
        max-width: 1300px;
        padding: 50px;
    }
}
    </style>
    <%@ include file="../utilities/header.jsp" %>


    <div class="div-body">

    <div class="header-container">
        <h3 class="header-title">get a ride in no time! </h3>
        <p style="color: #e7c666;    max-width: 600px; ">Get ahead in your calculations endeavors with our prep work done. It’s time to design a form,<span style="color:white"> are you ready?<span></P>
    </div>

    <div class="container py-5">
        <div class="row g-4">
            <!-- Booking Form -->
            <div class="col-lg-7">
                <div class="card p-4">
                    <h4 class="mb-4">Taxi Booking Form</h4>
                    <div class="mb-3">
                      <div class="d-flex align-items-center justify-content-between mb-2">
                        <label class="form-label fw-semibold" style="font-size: 13px;">Pickup Location</label>
                        <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#mapModal">
                            <i class="fas fa-map-marker-alt"></i> Open Map
                        </button>
                      </div>
                      <div class="address_show p-2 border rounded bg-light">
                          <p id="from" class="mb-1"><strong>From:</strong> </p>
                          <p id="to" class="mb-0"><strong>To:</strong> </p>
                      </div>
                    </div>

                    <div class="flex-box">
                              <div class="mb-3">

                                         <form class="max-w-[8rem] mx-auto">
                                            <label for="time" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Select time:</label>
                                            <div class="relative">
                                                <div class="absolute inset-y-0 end-0 top-0 flex items-center pe-3.5 pointer-events-none">
                                                    <svg class="w-4 h-4 text-gray-500 dark:text-gray-400" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24">
                                                        <path fill-rule="evenodd" d="M2 12C2 6.477 6.477 2 12 2s10 4.477 10 10-4.477 10-10 10S2 17.523 2 12Zm11-4a1 1 0 1 0-2 0v4a1 1 0 0 0 .293.707l3 3a1 1 0 0 0 1.414-1.414L13 11.586V8Z" clip-rule="evenodd"/>
                                                    </svg>
                                                </div>
                                                <input type="time" id="time" class="bg-gray-50 border leading-none border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500 booking-time-select" min="09:00" max="18:00" value="00:00" required />
                                            </div>
                                        </form>

                                        </div>
                                        <div class="mb-3 max-w-[12rem] mx-auto">
                                            <label for="date" class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Select date:</label>
                                            <input type="date" id="date" class="booking-date-pick bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500" required />

                                        </div>
                    </div>


                 <div class="mb-3">
                     <label class="form-label">Number of Seats</label>
                     <!-- Input Number -->
                     <div class="py-2 px-3 bg-white border border-gray-200 rounded-lg dark:bg-neutral-900 dark:border-neutral-700" data-hs-input-number="">
                         <div class="w-full flex justify-between items-center gap-x-3">
                             <div>
                                 <span class="block font-medium text-sm text-gray-800 dark:text-white">
                                     Additional seats
                                 </span>
                                 <span class="block text-xs text-gray-500 dark:text-neutral-400">
                                     Max - 9, Min - 1
                                 </span>
                             </div>
                             <div class="flex items-center gap-x-1.5">
                                 <input id="seatNumber" class="p-0 w-6 bg-transparent border-0 text-gray-800 text-center focus:ring-0 [&::-webkit-inner-spin-button]:appearance-none [&::-webkit-outer-spin-button]:appearance-none dark:text-white" style="-moz-appearance: textfield;" type="number" aria-roledescription="Number field" value="1" min="1" max="9">
                             </div>
                         </div>
                     </div>
                     <!-- End Input Number -->
                 </div>

                 <div class="mb-3">
                     <label class="form-label">Select Vehicle</label>

                     <div id="vehicle-options" class="mt-2 p-2 border border-gray-300 rounded-lg">
                         <!-- Vehicle suggestions will appear here -->
                     </div>
                 </div>

                    <div class="mb-3">
                        <label class="form-label">Comment</label>
                        <textarea class="form-control" rows="3" placeholder="Add any comments"></textarea>
                    </div>
                </div>
            </div>

            <!-- Summary -->
       <div class="col-lg-5">
           <div class="card p-4">
               <h4 class="mb-4">Summary</h4>
               <table class="table">
                   <thead>
                       <tr>
                           <th style="border-radius: 5px 0 0 5px;">Name</th>
                           <th style="border-radius: 0 5px 5px 0;" class="text-end">Total</th>
                       </tr>
                   </thead>
               </table>
               <ul class="list-group mb-3">
                  <li  style="font-size: 15px;" class="list-group-item">
                      <strong>Pickup Location</strong>
                      <p id="pickup-location" class="text-muted small mb-0">
                          From: <br>
                          To: <br>
                          Distance: Calculating...
                      </p>
                      <span class="float-end">$0.00</span>
                  </li>
                   <li class="list-group-item d-flex justify-content-between">
                       <span>Date</span>
                       <span>February 19, 2025</span>
                   </li>
                   <li class="list-group-item d-flex justify-content-between">
                       <span>Time</span>
                       <span>02:30 pm</span>
                   </li>
                   <li class="list-group-item d-flex justify-content-between">
                       <span>Class</span>
                       <span>Economy ($3.00)</span>
                   </li>
                   <li class="list-group-item d-flex justify-content-between">
                       <span>Payment Method</span>
                       <span>Cash</span>
                   </li>
                   <li class="list-group-item d-flex justify-content-between">
                       <span>Comment</span>
                       <span>-</span>
                   </li>
               </ul>
               <div class="mb-3 d-flex justify-content-between">
                   <strong>Total</strong>
                   <strong>$11.26</strong>
               </div>
               <div class="mb-3">
                   <label style="font-size: smaller; font-weight: 600;" class="form-label">Payment Methods</label>
                   <div style="    padding: 10px;background-color: #ebebeb; border-radius: 7px;" class="d-flex align-items-center gap-2">

                       <img src="https://img.icons8.com/color/48/000000/mastercard-logo.png" alt="Mastercard" width="30">
                       <img src="https://img.icons8.com/color/48/000000/visa.png" alt="Visa" width="30">
                       <img src="https://img.icons8.com/color/48/000000/amex.png" alt="Amex" width="30">
                   </div>
               </div>
               <button class="btn btn-success w-100 mb-3">
                   Book Now <i class="fas fa-external-link-alt"></i>
               </button>
               <div class="d-flex gap-2">
                   <button class="btn btn-outline-secondary w-50">PDF Download</button>
                   <button class="btn btn-outline-secondary w-50">Send Quote</button>
               </div>
           </div>
       </div>

        </div>
    </div>
    </div>
     <%@ include file="../utilities/footer.jsp" %>

     <!-- Modal for Map View -->
     <div class="modal fade" id="mapModal" tabindex="-1" aria-labelledby="mapModalLabel" aria-hidden="true">
         <div class="modal-dialog modal-lg">
             <div class="modal-content">

                 <div class="modal-body">
                     <iframe src="map_view.jsp" width="100%" height="500px" style="border: none;"></iframe>
                 </div>
             </div>
         </div>
     </div>

    <script src="https://cdn.jsdelivr.net/npm/flowbite@3.1.2/dist/flowbite.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Set min attribute to today's date for the date picker
    const dateInput = document.getElementById('date');
    const today = new Date().toISOString().split('T')[0];
    dateInput.min = today;


    // vehicle select
        const vehicles = [
            { name: "Sedan", seats: 4, image: "https://via.placeholder.com/100?text=Sedan" },
            { name: "SUV", seats: 5, image: "https://via.placeholder.com/100?text=SUV" },
            { name: "Minivan", seats: 7, image: "https://via.placeholder.com/100?text=Minivan" },
            { name: "Bus", seats: 9, image: "https://via.placeholder.com/100?text=Bus" }
        ];

        const seatInput = document.getElementById('seatNumber');
        const vehicleOptions = document.getElementById('vehicle-options');

        function suggestVehicles() {
            const seatCount = parseInt(seatInput.value, 10);
            const suggested = vehicles.filter(v => v.seats >= seatCount);

            vehicleOptions.innerHTML = suggested.map(vehicle => `
                <label class="flex items-center gap-x-2 p-2 border border-gray-200 rounded-lg cursor-pointer hover:bg-gray-100 dark:hover:bg-neutral-800">
                    <input type="radio" name="vehicle" value="${vehicle.name}" class="form-radio">
                    <img src="${vehicle.image}" alt="${vehicle.name}" class="w-16 h-16 object-cover">
                    <span>${vehicle.name} - Seats: ${vehicle.seats}</span>
                </label>
            `).join('') || '<p class="text-gray-500">No vehicles available for the selected seat number.</p>';
        }

        seatInput.addEventListener('input', suggestVehicles);
        suggestVehicles();

        // map view
         window.addEventListener("message", function(event) {
             if (event.data && (event.data.type === "from" || event.data.type === "to")) {
                 let pickupLocationElement = document.getElementById("pickup-location");
                 document.getElementById(event.data.type).innerHTML =
                     "<strong>" + (event.data.type === "from" ? "From" : "To") + ":</strong> " + event.data.address;

                 setTimeout(() => {
                     let fromElement = document.getElementById("from");
                     let toElement = document.getElementById("to");
                     let fromText = fromElement ? fromElement.textContent.replace(/From:\s*/, "").trim() : "";
                     let toText = toElement ? toElement.textContent.replace(/To:\s*/, "").trim() : "";
                     console.log("Updated From Address:", fromText);
                     console.log("Updated To Address:", toText);

                     pickupLocationElement.innerHTML =
                         "From: " + fromText + "<br>" +
                         "To: " + toText + "<br>" +
                         "Distance: Calculating...";
                 }, 100);
             }
         });
</script>

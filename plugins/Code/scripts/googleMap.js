'use strict';

const METERS_IN_KM = 1000;
const SECONDS_IN_MINUTE = 60;
const MINUTES_IN_HOUR = 60;

var directionsRenderer;
var googleMap;
var marker;
var locationCounter = 0;
var lastLocationTextBox = null;
var distanceInKM = 0;
var totalFare = 0;
var travelPrice = 0;
var mins = 0;
var hrs = 0;
var priceCalculated = false;
var countryFare = null;
var fareList = {
    'France': {
        'currency': '€',
        'startingPrice': 9,
        'pricePerKm': 1.5,
    },
    'Germany': {
        'currency': '€',
        'startingPrice': 9,
        'pricePerKm': 1.5,
    },
    'United Kingdom': {
        'currency': '£',
        'startingPrice': 8,
        'pricePerKm': 1.4,
    },
    'Netherlands': {
        'currency': '€',
        'startingPrice': 3.60,
        'pricePerKm': 2.65,
    },
    'Belgium': {
        'currency': '€',
        'startingPrice': 18,
        'pricePerKm': 2.40,
    }
};

$(document).ready(function () {
    $('#fareDetails').hide();

    $('#btnClearDirections').click(function() {
        if (confirm('Are you sure you want to clear all locations?')) {
            $('#fareDetails').hide();
            priceCalculated = false;
            distanceInKM = 0;
            totalFare = 0;
            travelPrice = 0;
            mins = 0;
            hrs = 0;

            // Clear directions, if any.
            if (directionsRenderer) {
                directionsRenderer.setMap(null);
            }

            $('#frmLocation').get(0).reset();
            $('#locations').empty();
            locationCounter = 0;
            displayInitialLocations();

            // Remove previous marker, if any.
            if (marker) {
                marker.setMap(null);
                marker = null;
            }
        }
    });

    $('#btnAddLocation').click(function () {
        locationCounter++;
        var locationTextBoxId = 'txtLocation' + locationCounter;
        addLocationBox(locationTextBoxId);
        addAutoComplete(locationTextBoxId);
        priceCalculated = false;
    });

    $('#btnGetJson').click(function() {
        if(!priceCalculated) {
            alert('Please calculate the fare first.');
            return;
        }

        var locations = [];

        $('#locations input[type="text"]').each(function (index, locationBox) {
            var location = {
                address: $(locationBox).val(),
                lat: $(locationBox).data('lat'),
                lng: $(locationBox).data('lng')
            };

            locations.push(location);
        });

        var data = {
            locations: locations,
            distanceInKM: distanceInKM,
            startingPrice: countryFare.startingPrice,
            travelPrice: travelPrice,
            totalFare: totalFare,
            mins: mins,
            hrs: hrs
        };

        alert(JSON.stringify(data));
    });

    $('#btnCalculateFare').click(function () {
        // Clear previous directions, if any.
        if (directionsRenderer) {
            directionsRenderer.setMap(null);
        }

        // Also remove the marker, if exists.
        if (marker) {
            marker.setMap(null);
            marker = null;
        }

        // Hide previous fare details.
        $('#fareDetails').hide();

        var directionsService = new google.maps.DirectionsService;

        directionsRenderer = new google.maps.DirectionsRenderer({
            map: googleMap,
            draggable: false
        });

        var source = null;
        var destination = null;
        var location = null;
        var wayPoints = [];
        var valid = true;
        var countryError = false;
        var count = 0;
        var country = null;
        
        $('#locations input[type="text"]').each(function (index, locationBox) {
            count++;

            if($(locationBox).val().trim() === "") {
                alert('Please enter location.');
                $(locationBox).focus();
                valid = false;
                return false;
            }

            if(index === 0) {
                // source = $(locationBox).val();
                source = $(locationBox).data('lat') + ' ' + $(locationBox).data('lng');
            } else {
                if(location !== null) {
                    var wayPoint = {
                        location: location,
                        stopover: true
                    };

                    wayPoints.push(wayPoint);
                }

                // location = $(locationBox).val();
                location = $(locationBox).data('lat') + ' ' + $(locationBox).data('lng');

                if ($(locationBox).data('country') != country) {
                    countryError = true;
                }
            }

            country = $(locationBox).data('country');
        });

        destination = location;

        if(!valid) {
            return;
        } else {
            if(count === 0) {
                alert('Please add source and destination locations.');
                return;
            } else if(count === 1) {
                alert('Please add destination location.');
                return;
            }

            if (countryError) {
                alert('Sorry, we don\'t provide cross border services.');
                return;
            }
        }

        // Check whether the country is within the list
        countryFare = fareList[country];
        if (!countryFare) {
            alert('Sorry, we provide services in below countries only.\n' +
                'France\nGermany\nGreece\nUnited Kingdom\nCanada\nUnited States\nAustralia\n');
            return;
        }

        // Create directions request.
        var directionsRequest = {
            origin: source,
            destination: destination,
            travelMode: google.maps.TravelMode["DRIVING"],
            waypoints: wayPoints,
            optimizeWaypoints: $('#chkOptimizePath').is(':checked')
        };

        // Send request to the directions service.
        directionsService.route(directionsRequest, function (response, status) {
            if (status == google.maps.DirectionsStatus.OK) {
                directionsRenderer.setDirections(response);

                var distanceInMeters = 0;
                var timeInSeconds = 0;

                for (var i = 0; i < response.routes[0].legs.length; i++) {
                    var leg = response.routes[0].legs[i];
                    distanceInMeters += leg.distance.value;
                    timeInSeconds += leg.duration.value;
                }

                distanceInKM = distanceInMeters / METERS_IN_KM;
                var durationInMins = timeInSeconds / SECONDS_IN_MINUTE;
                var durationInHours = durationInMins / MINUTES_IN_HOUR;
                travelPrice = countryFare.pricePerKm * distanceInKM;
                totalFare = countryFare.startingPrice + travelPrice;
                var hoursMins = "";
                mins = 0;
                hrs = 0;
                
                if(durationInHours < 1) {
                    mins = durationInMins.toFixed(0);
                    hoursMins = mins + " minute" + (mins > 1 ? "n" : "");
                } else {
                    mins = (durationInMins % MINUTES_IN_HOUR).toFixed(0);
                    hrs = Math.floor(durationInHours);
                    hoursMins = hrs + "uur" + (hrs > 1 ? "" : "") + ", " + mins + " minute" + (mins > 1 ? "n" : "");
                }

                $('#distance').text(distanceInKM.toFixed(2) + " KM");
                $('#duration').text(hoursMins);
                $('#startingPrice').text(countryFare.currency + countryFare.startingPrice.toFixed(2));
                $('#travelPrice').text(countryFare.currency + travelPrice.toFixed(2));
                $('#fare').text(countryFare.currency + totalFare.toFixed(2));
                $('#totalFare').text(countryFare.currency + totalFare.toFixed(2));

                $('#fareDetails').show();
                priceCalculated = true;
            } else {
                alert('We could not find any result for your search.');
            }
        });
    });
});

function initializeMap() {
    displayInitialLocations();

    var latLng = new google.maps.LatLng(33.7294, 73.0931);

    var mapOptions = {
        center: latLng,
        zoom: 8
    };

    // googleMap = new google.maps.Map(document.getElementById("googleMap"), mapOptions);

    // google.maps.event.addListener(googleMap, 'click', function (e) {
    //     if (lastLocationTextBox === null) {
    //         return;
    //     }

    //     // Remove previous marker, if any.
    //     if (marker) {
    //         marker.setMap(null);
    //         marker = null;
    //     }

    //     // Get address by lat/lng.
    //     var geocoder = new google.maps.Geocoder();
    //     geocoder.geocode({ 'latLng': e.latLng }, function (results, status) {
    //         if (status == google.maps.GeocoderStatus.OK) {
    //             if (results[0]) {
    //                 var address = results[0].formatted_address;

    //                 marker = new google.maps.Marker({
    //                     position: e.latLng,
    //                     map: googleMap,
    //                     title: address
    //                 });

    //                 $('#' + lastLocationTextBox).val(address);
    //                 $('#' + lastLocationTextBox).data('lat', e.latLng.lat());
    //                 $('#' + lastLocationTextBox).data('lng', e.latLng.lng());
    //                 priceCalculated = false;
    //             }
    //         }
    //     });
    // });
}

function addAutoComplete(textBox) {
    $('#' + textBox).focus(function() {
        lastLocationTextBox = textBox;
    });

    // Specify auto complete text box.
    var autoComplete = new google.maps.places.Autocomplete(document.getElementById(textBox));

    // Add auto complete listener.
    autoComplete.addListener('place_changed', function () {
        // Display the place on the map.
        var place = autoComplete.getPlace();
        var country = getCountry(place);
        // googleMap.setCenter(place.geometry.location);
        // googleMap.setZoom(15);

        $('#' + textBox).data('lat', place.geometry.location.lat());
        $('#' + textBox).data('lng', place.geometry.location.lng());
        $('#' + textBox).data('country', country);
        priceCalculated = false;
        
        // Remove previous marker, if any.
        if (marker) {
            marker.setMap(null);
            marker = null;
        }

        // Add a new marker.
        // marker = new google.maps.Marker({
        //     position: place.geometry.location,
        //     map: googleMap,
        //     title: place.formatted_address
        // });
    });
}

function getCountry(place) {
    let country = null;

    for (const component of place.address_components) {
        for (const comType of component.types) {
            switch (comType) {
                case "country":
                    country = component.long_name;
                    break;
            }

            if (country) {
                break;
            }
        }

        if (country) {
            break;
        }
    }

    return country;
}

function addLocationBox(locationTextBoxId, placeHolder) {
    $('#locations').append(
        '<div class="form-group" id="' + locationTextBoxId + 'Fields">' +
            '<label for="' + locationTextBoxId + '" class="sr-only">Location</label>' +
            '<input id="' + locationTextBoxId + '" type="text" placeholder=' +placeHolder+' class="location-box form-control form-control-lg" />' +
           
        '</div>');
}

function addSecondLocationBox(locationTextBoxId, placeHolder) {
    $('#location2').append(
        '<div class="col-md-6 agileits-btm-spc form-text2 dates-wrap" required>' +
            '<label for="' + locationTextBoxId + '" class="sr-only">Location</label>' +
            '<input id="' + locationTextBoxId + '" type="text" name="' + locationTextBoxId + '" placeholder=' +placeHolder+' class="location-box form-control form-control-lg" />' +
           
        '</div>');
}

function removeLocation(locationFields) {
    $('#' + locationFields).remove();
    priceCalculated = false;
}

function displayInitialLocations() {
    locationCounter++;
    var locationTextBoxId = 'txtLocation' + locationCounter;
    addLocationBox(locationTextBoxId, "Van");
    addAutoComplete(locationTextBoxId);

    locationCounter++;
    var locationTextBoxId = 'txtLocation' + locationCounter;
    addLocationBox(locationTextBoxId, "Naar");
    addAutoComplete(locationTextBoxId);

    locationCounter++;
    var locationTextBoxId = 'txtLocation' + locationCounter;
    addSecondLocationBox(locationTextBoxId, "Van");
    addAutoComplete(locationTextBoxId);

    locationCounter++;
    var locationTextBoxId = 'txtLocation' + locationCounter;
    addSecondLocationBox(locationTextBoxId, "Naar");
    addAutoComplete(locationTextBoxId);
}

// Add window load event.
google.maps.event.addDomListener(window, "load", initializeMap);

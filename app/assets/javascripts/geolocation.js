function getGeoLocation() {
  navigator.geolocation.getCurrentPosition(setGeoCookie);
}

function setGeoCookie(position) {
  var cookie_val = position.coords.longitude + "|" + position.coords.latitude;
  console.log(position.coords);
  document.cookie = "coordinates=" + escape(cookie_val);
}
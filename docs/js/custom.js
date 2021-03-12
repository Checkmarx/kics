(function () {
  removeElement(".nav-item a[rel='prev']", true)
  removeElement(".nav-item a[rel='next']", true)
  if (window.location.href.includes('/queries/') && window.location.href.includes('-queries')) {
    removeElement(".container .navbar-light", true)
    var updateElement = document.querySelector("[role='main']");
    updateElement.classList.remove("col-md-9");
    updateElement.classList.add("col-md-12");
  }
})();

function removeElement(querySelector, parentElement) {
  var element = document.querySelector(querySelector);
  if (element) {
    if (parentElement) {
      element = element.parentElement;
    }
    element.remove()
  }
}

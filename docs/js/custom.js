(function () {
  if (window.location.href.includes('/queries/') && window.location.href.includes('-queries')) {
    var removeElement = document.querySelector(".container .navbar-light").parentElement;
    removeElement.remove();
    var updateElement = document.querySelector("[role='main']");
    updateElement.classList.remove("col-md-9");
    updateElement.classList.add("col-md-12");
  }
})();
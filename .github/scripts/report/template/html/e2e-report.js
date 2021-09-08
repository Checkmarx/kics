function filter(filt) {
  const tests = document.querySelectorAll("[data-type='testInfo']");
  tests.forEach((query) => filt !== "all" && filt !== query.getAttribute("data-name") ? query.classList.add("hide") : query.classList.remove("hide"));

  const severitiesCaptions = document.querySelectorAll(".counters > .counter-btn");
  const selectedElement = document.getElementsByClassName(`counter test-status ${filt}`)[0]

  severitiesCaptions.forEach((counter) => {
    filt && selectedElement === counter.getElementsByClassName('counter test-status')[0] ? counter.classList.add("selected") : counter.classList.remove("selected")
  });
}

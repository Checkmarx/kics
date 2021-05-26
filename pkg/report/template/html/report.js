function filter(filt) {
  const queries = document.querySelectorAll("[data-type='severity']");
  queries.forEach((query) => filt !== "TOTAL" && filt !== query.getAttribute("data-name") ? query.classList.add("hide") : query.classList.remove("hide"));

  const severitiesCaptions = document.querySelectorAll(".severity > .caption");
  severitiesCaptions.forEach((caption) => filt && filt === caption.innerText ? caption.classList.add("selected") : caption.classList.remove("selected"));
}

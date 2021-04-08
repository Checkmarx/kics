function filter(filter) {
  const queries = document.querySelectorAll("[data-type='severity']");
  queries.forEach((query) => filter !== "TOTAL" && filter !== query.getAttribute("data-name") ? query.classList.add("hide") : query.classList.remove("hide"));
  
  const severitiesCaptions = document.querySelectorAll(".severity > .caption");
  severitiesCaptions.forEach((caption) => filter && filter === caption.innerText ? caption.classList.add("selected") : caption.classList.remove("selected"));
}

(function () {
  addVersion()
})()

function addVersion() {
  var REL_BASE_URL = base_url;
  var ABS_BASE_URL = normalizePath(window.location.pathname + "/" +
                                   REL_BASE_URL);
  var CURRENT_VERSION = ABS_BASE_URL.split("/").pop();

  function makeSelect(options, selected) {
    var select = document.createElement("select");
    select.classList.add("form-control");
    options.forEach(function(i) {
      var option = new Option(i.text, i.value, undefined,
                              i.value === selected);
      select.add(option);
    });
    return select;
  }

  var xhr = new XMLHttpRequest();
  xhr.open("GET", REL_BASE_URL + "/../versions.json");
  xhr.onload = function() {
    var versions = JSON.parse(this.responseText);

    var realVersion = versions.find(function(i) {
      return i.version === CURRENT_VERSION ||
             i.aliases.includes(CURRENT_VERSION);
    }).version;

    var select = makeSelect(versions.map(function (i) {
      var title = i.title
      if (i.aliases && i.aliases.length && i.aliases.length === 1) {
        title += ` (${i.aliases[0]})`
      }
      return {text: title, value: i.version};
    }), realVersion);
    select.addEventListener("change", function() {
      window.location.href = REL_BASE_URL + "/../" + this.value + "/";
    });

    var container = document.createElement("div");
    container.id = "version-selector";
    container.appendChild(select);

    var title = document.querySelector("#navbar-collapse");
    container.style.height = "30px";
    title.parentNode.insertBefore(container, title.nextSibling);
  };
  xhr.send();
}

function normalizePath(path) {
  var normalized = [];
  path.split("/").forEach(function(bit, i) {
    if (bit === "." || (bit === "" && i !== 0)) {
      return;
    } else if (bit === "..") {
      if (normalized.length === 1 && normalized[0] === "") {
        throw new Error("invalid path");
      } else if (normalized.length === 0 ||
                 normalized[normalized.length - 1] === "..") {
        normalized.push("..");
      } else {
        normalized.pop();
      }
    } else {
      normalized.push(bit);
    }
  });
  return normalized.join("/");
}

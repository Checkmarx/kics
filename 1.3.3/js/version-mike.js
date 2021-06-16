(window.onload = function () {
  var xhr = new XMLHttpRequest();
  var getUrl = window.location;
  var baseUrl = getUrl.protocol + "//" + getUrl.host + "/" + getUrl.pathname.split('/')[1];
  xhr.open("GET", baseUrl + "/../versions.json");
  xhr.onload = function () {
    var versions = JSON.parse(this.responseText);
    var lastVersion = versions.find(i => i.aliases.find(j => j === "latest"))
    var versionItems = document.getElementsByClassName("md-version__link")
    for (var versionItem of versionItems) {
      if (lastVersion.version == versionItem.innerText) {
        versionItem.innerText += " (latest)"
        if (document.getElementsByClassName("md-version__current")[0].innerText == lastVersion.version) {
          document.getElementsByClassName("md-version__current")[0].innerText += " (latest)"
        }
        break
      }
    }
  }
  xhr.send()
})()

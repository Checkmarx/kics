(window.onload = function () {
  var xhr = new XMLHttpRequest();
  var getUrl = window.location;
  var baseUrl = getUrl.protocol + '//' + getUrl.host + '/' + getUrl.pathname.split('/')[1];
  xhr.open('GET', baseUrl + '/../versions.json');
  xhr.onload = function () {
    var versions = JSON.parse(this.responseText);
    var lastVersion = versions.find(i => i.version === 'latest')
    var versionItems = document.getElementsByClassName('md-version__link')
    for (var versionItem of versionItems) {
      if (lastVersion.version == versionItem.innerText) {
        const alias = ` (${lastVersion.aliases[0]})`
        versionItem.innerText += alias
        if (document.getElementsByClassName('md-version__current')[0].innerText == lastVersion.version) {
          document.getElementsByClassName('md-version__current')[0].innerText += alias
        }
        break
      }
    }
    const item = Array.from(document.querySelectorAll('.md-version__item')).find(i => i.textContent.includes('latest'))
    const parentNode = document.getElementsByClassName('md-version__list')[0]
    if (parentNode && item) {
      item.remove()
      parentNode.insertBefore(item, parentNode.firstChild)
      parentNode.scrollTop = 0;
    }
  }
  xhr.send()
})()

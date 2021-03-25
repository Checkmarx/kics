(function () {
  removeElement(".nav-item a[rel='prev']", true)
  removeElement(".nav-item a[rel='next']", true)
  //
  if (window.location.href.includes('/queries/') && window.location.href.includes('-queries')) {
    removeElement(".container .navbar-light", true)
    var updateElement = document.querySelector("[role='main']");
    updateElement.classList.remove("col-md-9");
    updateElement.classList.add("col-md-12");

    //add filter and sort
    var tableHeader = document.querySelectorAll(":not(.modal-body) > table > thead > tr > th")
    for (var i = 0; i < tableHeader.length; i++) {
      tableHeader[i].innerHTML = `${tableHeader[i].innerText} <span style="cursor:pointer;" onclick="executeSort(${i})">&uarr;&darr;</span><br/><input id="query-filter-${i}" type="text" onkeyup="filterQueryTable(${tableHeader.length})" onpaste="pasteFilter(${tableHeader.length})"/>`
    }    
  }
})();

var sortAsc = true

function pasteFilter(numberOfColumns) {
  setTimeout(filterQueryTable, 100, numberOfColumns);
}

function filterQueryTable(numberOfColumns) {
  var allLines = document.querySelectorAll(":not(.modal-body) > table > tbody > tr")
  hideRow = new Set();
  for (var i = 0; i < numberOfColumns; i++) {
    var textToFilter = document.querySelector(`#query-filter-${i}`).value;
    console.log(textToFilter)
    if (textToFilter) {
      allLines.forEach(line => {
        if (!line.children[i].innerText.toLowerCase().includes(textToFilter.toLowerCase())) {
          hideRow.add(line)
        }
      })
    }
  }
  allLines.forEach(line => {
    if (hideRow.has(line) && !line.classList.contains("hide-column-query-table")) {
      line.classList.add("hide-column-query-table")
    } else if (!hideRow.has(line) && line.classList.contains("hide-column-query-table")) {
      line.classList.remove("hide-column-query-table")
    }
  })
}

function sortFunction(index) {
  let sortOrder = 1
  if (!sortAsc) {
    sortOrder = -1
  }
  return function (a, b) {
    return a.children[index].innerText.toLowerCase().localeCompare(b.children[index].innerText.toLowerCase())*sortOrder
  }
}

function executeSort(index) {
  var allLines = Array.prototype.slice.call(document.querySelectorAll(":not(.modal-body) > table > tbody > tr"))
  let sortedLines = allLines.sort(sortFunction(index))
  const body = document.querySelector(":not(.modal-body) > table > tbody ")
  body.innerHTML = ""
  sortedLines.forEach(tr => body.appendChild(tr))
  sortAsc = !sortAsc
}

function removeElement(querySelector, parentElement) {
  var element = document.querySelector(querySelector);
  if (element) {
    if (parentElement) {
      element = element.parentElement;
    }
    element.remove()
  }
}

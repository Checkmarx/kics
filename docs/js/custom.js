var sortAsc = true;
var headerArray = [];

(function () {
  removeElement(".nav-item a[rel='prev']", true)
  removeElement(".nav-item a[rel='next']", true)

  var kics = document.querySelectorAll(".md-ellipsis")
  kics[0].setAttribute("style", "display:none;")

  // For queries pages
  if (window.location.href.includes('/queries/') && window.location.href.includes('-queries')) {
    removeElement("div.md-sidebar.md-sidebar--secondary", false)

    var updateTableHeader = document.getElementsByTagName("th")

    for (var t of updateTableHeader) {
      t.classList.add("queries-th")
    }

    //add filter and sort
    var tableHeader = document.querySelectorAll(":not(.modal-body) > table > thead > tr > th")
    for (var i = 0; i < tableHeader.length; i++) {
      const index = i;
      headerArray.push(tableHeader[i].innerText.toLowerCase())
      const headerText = sanitize(tableHeader[i].innerText)
      if (!tableHeader[i].innerText.toLowerCase().includes("help")) {
        const spanSort = document.createElement("span")
        spanSort.innerText = headerText

        const inputFilter = document.createElement("input")
        inputFilter.setAttribute("id", `query-filter-${i}`)
        inputFilter.setAttribute("type", "text")
        inputFilter.classList.add("border-input-queries")
        inputFilter.addEventListener("keyup", function () { filterQueryTable(tableHeader.length) });
        inputFilter.addEventListener("paste", function () { pasteFilter(tableHeader.length) });

        const lineBreak = document.createElement("br")
        if (!tableHeader[i].innerText.toLowerCase().includes("description")) {
          spanSort.setAttribute("style", "cursor:pointer;")
          spanSort.innerText += " ↑↓"
          spanSort.addEventListener("click", function () { executeSort(index) });
        }
        tableHeader[i].innerHTML = ""
        tableHeader[i].appendChild(spanSort)
        tableHeader[i].appendChild(lineBreak)
        tableHeader[i].appendChild(inputFilter)
      } else {
        tableHeader[i].style.verticalAlign = "initial";
      }
    }
    // var untreatedName = document.getElementsByClassName("md-nav__link md-nav__link--active")[0].innerText
    // var treatedName = untreatedName.replace(/\s+/g, '').toLowerCase()
    // treatedName = htmlEncode(treatedName)
    const csvFilename = `kics-queries.csv`
    const table = document.querySelector(":not(.modal-body) > table")
    const button = document.createElement("a")
    button.innerText = "Download"
    button.classList.add("btn")
    button.classList.add("btn-success")
    button.addEventListener("click", function () { exportToCSV(csvFilename) });
    table.parentNode.insertBefore(button, table)
  }
})();

function sanitize(str) {
  return str.replace(/</g, "&lt;").replace(/>/g, "&gt;")
}

function htmlEncode(str) {
  return String(str).replace(/[^\w. ]/gi, function (c) {
    return '&#' + c.charCodeAt(0) + ';';
  });
}

function pasteFilter(numberOfColumns) {
  setTimeout(filterQueryTable, 100, numberOfColumns);
}

function filterQueryTable(numberOfColumns) {
  var allLines = document.querySelectorAll(":not(.modal-body) > table > tbody > tr")

  var hideRow = new Set();
  for (var i = 0; i < numberOfColumns; i++) {
    const input = document.querySelector(`#query-filter-${i}`)
    var textToFilter = ""
    if (input) {
      textToFilter = input.value
    }

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
  if (!headerArray[index].toLowerCase().includes("severity")) {
    return function (a, b) {
      return a.children[index].innerText.toLowerCase().localeCompare(b.children[index].innerText.toLowerCase()) * sortOrder
    }
  }
  const severityOrder = {
    "high": 0,
    "medium": 1,
    "low": 2,
    "info": 3,
  }
  return function (a, b) {
    const severityA = severityOrder[a.children[index].innerText.toLowerCase().trim()]
    const severityB = severityOrder[b.children[index].innerText.toLowerCase().trim()]
    if (severityA == severityB) {
      return 0
    }
    return severityA < severityB ? -1 * sortOrder : 1 * sortOrder
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

function exportToCSV(filename) {
  var csv = [];
  var rows = document.querySelectorAll(":not(.modal-body) > table tr");

  for (let r of rows) {
    var row = []
    var cols = r.querySelectorAll("td, th")
    for (var j = 0; j < cols.length; j++) {
      var text = `"${cols[j].innerText.replace(/\n/g, " ").replaceAll(/"/g, '').trim()}"`
      if (cols[j].tagName == "TH") {
        text = text.match(/[0-9a-zA-Z ]+/)[0]
        if (headerArray[j] == "query") {
          text = "Query ID,Query Name"
        }
      } else if (headerArray[j] == "help") {
        text = cols[j].children[0].href
      } else if (headerArray[j] == "query") {
        var lastIndex = text.lastIndexOf(" ")
        text = `"${text.substring(lastIndex + 1)},${text.substring(0, lastIndex)}"`
      }
      row.push(text)
    }
    csv.push(row.join(","))
  }

  // Download CSV file
  downloadCSV(csv.join("\n"), filename)
}

function downloadCSV(csv, filename) {
  const downloadLink = document.createElement("a")

  downloadLink.download = filename
  downloadLink.setAttribute('href', 'data:text/csv;charset=utf-8,' + encodeURIComponent(csv));
  downloadLink.style.display = "none"
  document.body.appendChild(downloadLink)
  downloadLink.click()
}

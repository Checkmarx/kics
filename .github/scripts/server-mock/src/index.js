const express = require('express')
const descriptions = require('./descriptions.json')

const app = express()
app.use(express.json())

app.use((req, res, next) => {
  res.setHeader("Content-Security-Policy", "script-src 'self'")
  res.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
  return next()
})

app.post('/kics-mock/api/descriptions', (req, res) => {
  try {
    const descriptionParams = Array.isArray(req.body.descriptions) ? req.body.descriptions : [req.body.descriptions]
    const fetchDescriptions = descriptionParams.reduce((acc, descriptionID) => {
      if (descriptions[descriptionID])
        acc[descriptionID] = descriptions[descriptionID]
      return acc
    }, {})
    return res.json({
        "descriptions": fetchDescriptions,
        "timestamp": "2021-11-05T11:22:32Z",
        "requestID": "f4594caf-5ad0-45b6-bccd-c1d61b825ce1"
    })
  } catch {
    return res.status(500).send({status: 'failed'})
  }
})

app.listen(3000, () => {
  console.log('Server is running on port 3000')
})

const express = require('express')
const jsonDescriptions = require('./descriptions.json')

const app = express()
app.use(express.json())

app.post('/kics-mock/api/descriptions', (req, res) => {
  res.setHeader("Content-Security-Policy", "script-src 'self'")
  res.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
  const requestHash = Math.random().toString(36).substring(7)
  console.log(`[Request: ${requestHash}] Started...`)

  try {
    const { descriptions } = req.body
    const fetchDescriptions = descriptions.reduce((acc, descriptionID) => {
      if (jsonDescriptions[descriptionID])
        acc[descriptionID] = jsonDescriptions[descriptionID]
      return acc
    }, {})

    console.log(`[Request: ${requestHash}] Success!`)
    return res.json({
        "descriptions": fetchDescriptions,
        "timestamp": "2021-11-05T11:22:32Z",
        "requestID": "f4594caf-5ad0-45b6-bccd-c1d61b825ce1"
    })
  } catch {
    console.log(`[Request: ${requestHash}] Failed!`)
    return res.status(500).send({status: 'failed'})
  }
})

app.listen(3000, () => {
  console.log('Server is running on port 3000')
})

const express = require('express')
const descriptions = require('./descriptions.json')

const app = express()
app.use(express.json())

app.post('/kics-mock/api/descriptions', (req, res) => {
  try {
    const fetchDescriptions = req?.body?.descriptions.reduce((acc, descriptionID) => {
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
    return res.status(400).send({status: 'failed'})
  }
})

app.listen(3000, () => {
  console.log('Server is running on port 3000')
})
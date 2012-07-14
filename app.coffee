express = require 'express'

app = express.createServer()
require("./boot").boot app

app.listen process.env.PORT or 3001, -> console.log 'Listening...'
express = require 'express'
stylus = require 'stylus'
assets = require 'connect-assets'

app = express.createServer()
app.use assets()
app.set 'view engine', 'jade'
app.use express.static "#{__dirname}/public"

app.get '/', (req, res) -> res.render 'resume/simple'
app.get '/resume/simple', (req, res) -> res.render 'resume/simple'
app.get '/resume/interactive', (req, res) -> res.render 'resume/interactive'

app.listen process.env.PORT or 3001, -> console.log 'Listening...'
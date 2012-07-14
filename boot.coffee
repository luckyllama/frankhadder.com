fs = require "fs"
express = require "express"
stylus = require 'stylus'
assets = require 'connect-assets'

exports.boot = (app) ->
  bootApplication app
  bootRoutes app

bootApplication = (app) ->
  app.use assets()
  app.set 'view engine', 'jade'
  app.use express.static "#{__dirname}/public"

bootRoutes = (app) ->
  dir = __dirname + "/controllers"
  fs.readdirSync(dir).forEach (file) ->
    require("#{dir}/#{file}") app
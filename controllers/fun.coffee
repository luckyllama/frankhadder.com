module.exports = (app) ->

  app.get '/sudoku', (req, res) -> res.render 'fun/sudoku'
  
  app.get '/sorting', (req, res) -> res.render 'fun/sorting'
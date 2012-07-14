module.exports = (app) ->

	app.get '/sudoku', (req, res) -> res.render 'fun/sudoku'
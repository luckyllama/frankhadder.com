module.exports = (app, db) ->

	app.get '/', (req, res) -> res.render 'index'
	app.get '/resume/simple', (req, res) -> res.render 'resume/simple'
	app.get '/resume/interactive', (req, res) -> res.render 'resume/interactive'
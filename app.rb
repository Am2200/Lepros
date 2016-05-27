#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'Leprosorium.db'
	@db.results_as_hash = true
end

configure do
  init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS Posts (
								id           INTEGER PRIMARY KEY AUTOINCREMENT,
								created_date DATE,
								content      TEXT
							);'
end

before do
  init_db
end

get '/' do
  @results = @db.execute 'SELECT * FROM Posts ORDER BY id desc'
	erb :index
end

get '/new' do
  erb :new
end

post '/new' do
	content = params[:content]
  if content.length <= 0
    @error = 'Type post text'
    return erb :new
  else
    @db.execute 'INSERT INTO Posts (content, created_date) VALUES (?, datetime())', [content]
		erb "You typed #{content}"
  end
end
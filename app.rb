#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

configure do
  set :database, "sqlite3:Leprosorium.db"
end

class Post < ActiveRecord::Base
end

class Comment < ActiveRecord::Base
end

get '/' do
  @posts = Post.all
	erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  newPost = Post.new params[:post]
  newPost.save
  erb :index
end

get '/details/:post_id' do
  post_id = params[:post_id]
	results = @db.execute 'SELECT * FROM Posts where id = ?',[post_id]
  @row = results[0]

  @comments = @db.execute 'SELECT * FROM Comments WHERE post_id = ? ORDER BY id', [post_id]

  erb :details
end

post '/details/:post_id' do
  post_id = params[:post_id]
  content = params[:comment]

  @db.execute 'INSERT INTO Comments (content, created_date, post_id) values (?, datetime(), ?)', [content, post_id]

	redirect to ('/details/' + post_id)
end
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
  erb 'Hello World!'
end

get '/new' do
  erb :new
end

post '/new' do
  newPost = Post.new params[:post]
  newPost.save
  redirect to ('/posts')
end

get '/posts' do
  @posts = Post.all
  erb :index
end

get '/details/:post_id' do
  post_id = params[:post_id]
  @post = Post.find post_id
  @comments = Comment.where("idPost = ?", post_id)
  #@lastComment = Comment.last
  erb :details
end

post '/details/:post_id' do
  newComment = Comment.new params[:comment]
  newComment.save
	redirect to ('/details/' + params[:post_id])
end
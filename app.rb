#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

configure do
  set :database, "sqlite3:Leprosorium.db"
end

class Post < ActiveRecord::Base
  validates :content, presence: true, length: {minimum: 1}
end

class Comment < ActiveRecord::Base
  validates :comment, presence: true, length: {minimum: 1}
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
  @error = newPost.errors.full_messages.first
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
  erb :details
end

post '/details/:post_id' do
  newComment = Comment.new params[:comment]
  newComment.save
	redirect to ('/details/' + params[:post_id])
end
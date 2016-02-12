ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require_relative 'models/link'
require_relative 'models/tag'
require_relative 'models/data_mapper_setup'
# require 'data_mapper'
# require 'dm-postgres-adapter'

class Bookmark < Sinatra::Base

  enable :sessions
  get '/' do
    @links = Link.all
    erb(:links)
  end

  post '/links' do
    link = Link.create(title: params[:title], url: params[:url])
    tag = Tag.first_or_create(tag: params[:tag])
    link.tags << tag
    link.save
    redirect '/'
  end


  get '/links/new' do
    erb(:new_link)
  end

  post '/links/addtags' do
    p params
    p session['link'] = params['link_name']
    redirect '/links/addtags'
  end

  get '/links/addtags' do
   p  @link = session['link']
    erb(:add_tags)
  end

  get '/tags/:tag' do
     tag_1 = Tag.first(tag: params['tag'])
     @links = tag_1 ? tag_1.links : []
     erb(:links)
  end


 #start the server if ruby file executed directly
  run! if app_file == $0
end

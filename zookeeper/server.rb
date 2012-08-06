#!/usr/bin/env ruby 

# ZooKeeper Server. 

# update global path (fix for local paths in ruby 1.9)
$: << File.join(File.dirname(__FILE__), "")

require 'sinatra'
require 'datamapper'
require 'do_mysql'
require 'hashie'
require 'yaml'

require 'models/zoo_data'

# load configuration
app_config = Hashie::Mash.new(YAML.load_file("config/application.yml"))
config = Hashie::Mash.new(YAML.load_file("config/database.yml"))

puts app_config.inspect
puts config.inspect

# connect to database
db = config.databases['database_'+app_config.application.mode]
db_uri =  "mysql://#{db.username}:#{db.password}@#{db.host}:#{db.port}/#{db.database}"

#puts "Connect to: #{db_uri.inspect}"

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default,db_uri)
#if config.databases.migrations
#  DataMapper.auto_migrate! # will kill records, or create your database the first time through
#  build_classifications
#else
#  DataMapper.auto_upgrade! # will not kill data
#end
#DataMapper.finalize

def build_classifications
  a = Classification.new
  a.type = "Mammal"
  a.save
  
  b = Classification.new
  b.type = "Vertebrates"
  b.save
  
  c = Classification.new
  c.type = "In-Vertebrates"
  c.save
  
  if a.saved? && b.saved? && c.saved?
    return true
  else
    return false
  end
end




#

# sinatra bindings
# new, create, update, read, destroy

set :public => "public/"
set :sessions => true

# Main Homepage (List New Animals.. Maybe. Allow user to view animals in each zoo)
get '/' do
  @animals = Animal.all
  @num_animals = @animals.size
  erb :index
end

get '/zoo/new' do
  @notice = session[:notice] unless session[:notice].nil?
  @error = session[:error] unless session[:error].nil?
  erb "zoo/index".to_sym
end

post '/zoo/create' do
  @name = params[:name]
  @open = params[:open]
  zoo = Zoo.new
  zoo.name = @name
  zoo.open = @open
  zoo.save
  
  if zoo.saved?
    session[:notice] = {:type => "Success", :details => "Zoo Created"}
    redirect to ('/zoos/list')
  else
    session[:error] = {:type => "Failed", :details => "Couldn't Create Zoo"}
    redirect to ('/zoo/new')
  end
end
#%r{/hello/([\w]+)}
get %r{/(zoo|zoos)/list} do
  @notice = session[:notice] unless session[:notice].nil?
  @error = session[:error] unless session[:error].nil?
  @zoos = Zoo.all
  erb "zoo/list".to_sym
end

after %r{/(zoo|zoos)/list} do
  clear_messages
end

# Show all Animals in a Zoo
get '/zoo/:id/list' do
  @notice = session[:notice] unless session[:notice].nil?
  @error = session[:error] unless session[:error].nil?
  puts "#{params[:id].to_s}"
  @zoo = Zoo.first(:id => params[:id])
  @animals = Animal.all(:zoo_id => params[:id])
  erb "zoo/show".to_sym
end

# Animals
get '/animal/new' do
  @error = session[:error] unless session[:error].nil?
  @classifications = Classification.all
  @zoos = Zoo.all
  puts @classifications.inspect
  erb "animal/index".to_sym
end

after '/animal/new' do
  session[:error] = nil if !session[:error].nil?
end

# Post (create)
post '/animal/create' do
  puts params.inspect
  #params.classification = 1
  #params.name = whale
  
  animal = Animal.new
  animal.name = params[:name]
  animal.age = 0
  animal.zoo_id = params[:zoo]
  animal.save
  
  puts animal.inspect
  
  if animal.saved?
    
    animal_options = Animalization.new
    
    puts animal_options.inspect
    #<Animalization @id=nil @created_at=nil @animal_id=nil @classification_id=nil>
    animal_options.animal_id = animal.id
    animal_options.classification_id = params[:classification]
    animal_options.save
    
    if animal_options.saved?
      redirect to('/animals/list')
    else
      #puts animal_options.errors[:name]
      session[:error] = {:type => animal_options.errors[:name].join(" "), :details => "add custom details message"}
      redirect to ('/animal/new')
    end
  else
    puts animal.errors[:name]
    session[:error] = {:type => animal.errors[:name].join(" "), :details => "add custom details message"}
    redirect to ('/animal/new')
  end
  
end

# show a specific animal
get '/animal/:id/show' do
  @notice = session[:notice] unless session[:notice].nil?
  @error = session[:error] unless session[:error].nil?
  
  @animal = Animal.first(:id => params[:id])
  
  @animalization = Animalization.all(:animal_id => @animal.id) 
  unless @animalization.nil?
    @animalization.each{|data|
      (@classifications ||= []) << Classification.first(:id => data.classification_id)
    }
  end
  @zoo = Zoo.first(:id => @animal.zoo_id) unless @animal.nil?
  erb "animal/show".to_sym
end

after '/animal/:id/show' do
  clear_messages
end

# kill off an animal
# mapping issue (bug) - DataMapper should kill off animalizations as well on destroy
get '/animal/:id/died' do
  helpless = Animal.get(params[:id])
  #puts helpless.inspect
  
  if helpless.destroy
    session[:notice] = {:type => "Success", :details => "Animal Died"}
    redirect to ('/animals/list')
  else
    session[:error] = {:type => "Failed to Kill Animal", :details => "Animal Didn't Die"}
    redirect to ('/animal/'+params[:id]+'/show')
  end
end

# list animals
get %r{/(animal|animals)/list} do
  @notice = session[:notice] unless session[:notice].nil?
  @error = session[:error] unless session[:error].nil?
  @animals = Animal.all
  erb "animal/list".to_sym
end

after %r{/(animal|animals)/list} do
  clear_messages
end

get '/classification/generate' do
  res = build_classifications
  "#{res}"
end

def clear_messages
  session[:notice] = nil unless session[:notice].nil?
  session[:error] = nil unless session[:error].nil?
end
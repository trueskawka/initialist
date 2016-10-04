get('/styles.css'){ content_type 'text/css', :charset => 'utf-8' ; scss :styles }

enable :sessions

before do
  if session['id']
    @user = User.first(:id => session['id'])
  else
    @user = nil
  end
end

get '/' do
  if session['id']
    @lists = User.get(session['id']).lists.all(:order => [:name])
  end
  slim :index
end

get '/user/create' do
  @action = "/user/create"
  @title = 'register'
  slim :user_form
end

post '/user/create' do
  if User.first(:email => params[:username])
    flash[:notice] = 'A user with this name already exists'
    redirect '/user/create'
  elsif params[:username].length > 0 && params[:password].length > 0
    user = User.create(:email => params[:username], :password => params[:password])
    session['id'] = user.id
    redirect '/'
  else
    flash[:notice] = 'Please provide a username and password'
    redirect '/user/create'
  end
end

post '/:id' do
  List.get(params[:id]).tasks.create params['task']
  redirect '/'
end

delete '/task/:id' do
  Task.get(params[:id]).destroy
  redirect '/'
end

put '/task/:id' do
  task = Task.get params[:id]
  task.completed_at = task.completed_at.nil? ? Time.now : nil
  task.save
  redirect '/'
end

post '/new/list' do
  if session['id']
    User.get(session['id']).lists.create(:name => params[:name])
  end
  redirect '/'
end

delete '/list/:id' do
  List.get(params[:id]).destroy
  redirect '/'
end

get "/auth/login" do
  @action = "/auth/login"
  @title = 'log in'
  slim :user_form
end

post "/auth/login" do
  username = params[:username]
  password = params[:password]
  user = User.first(:email => username)

  if user && user.password == password
    session['id'] = user.id
    flash[:notice] = "You've managed it!"
    redirect '/'
  else
    flash[:notice] = "Bummer!"
    redirect '/auth/login'
  end
end

get "/auth/logout" do
  session.clear
  flash[:notice] = "You're outta here!"
  redirect '/'
end

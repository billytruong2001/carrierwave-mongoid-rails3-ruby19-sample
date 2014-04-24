class UsersController < ApplicationController


  # GridFS doesn't make the files available via HTTP, you'll need to stream them yourself
  def avatar
    @user = User.find(params[:id])
    content = @user.avatar.read
    if stale?(etag: content, last_modified: @user.updated_at.utc, public: true)
      send_data content, type: @user.avatar.file.content_type, disposition: "inline"
      expires_in 0, public: true
    end
  end

  def thumb_avatar
    @user = User.find(params[:id])
    content = @user.avatar.thumb.read
    if stale?(etag: content, last_modified: @user.updated_at.utc, public: true)
      send_data content, type: @user.avatar.thumb.file.content_type, disposition: "inline"
      expires_in 0, public: true
    end
  end

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|

      # just for fun testing
      if @user.name.downcase == "jocelin"
        @user.avatar = File.open('/tmp/avatar/jz.jpg')
      elsif @user.name.downcase == "amir"
        @user.avatar = File.open('/tmp/avatar/amir.jpg')
      elsif @user.name.downcase == "thomas mann"
        @user.avatar = File.open('/tmp/avatar/big-guy.png')
      elsif @user.name.downcase == "matt"
        @user.avatar = File.open('/tmp/avatar/bicycle-guy.jpg')
      else
        @user.avatar = File.open('/tmp/avatar/beezii_solo-04.png')
      end

      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      @user.avatar = File.open('/tmp/amir-avatar/beezii_solo-04.png')
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end

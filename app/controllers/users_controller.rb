class UsersController < Devise::RegistrationsController
  def index
    @users = User.all
  end

  def add
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path, :notice => "User deleted"
  end

  def create_new
    @user = User.new(params[:user])
    if @user.save
      redirect_to add_user_path, :notice => "User created successfully"
    else
      render 'add'
    end
  end

  def batch_new
  end

  def upload
    uploaded_io = params[:file]
    file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    File.open(file_path, 'w') do |file|
      file.write(uploaded_io.read)
    end

    if File.exist?(file_path)
    else
    end

  end

  def batch_create

  end
end

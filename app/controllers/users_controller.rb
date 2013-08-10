class UsersController < Devise::RegistrationsController
  def batch_new
  end

  def upload
    uploaded_io = params[:user_list]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
      file.write(uploaded_io.read)
    end
  end

  def batch_create

  end
end

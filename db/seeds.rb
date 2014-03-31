@user = User.create(:email => 'admin@example.com', :password => 'admin123#', :role => 'admin')
StoreSetting.create(:user_id => @user.id)
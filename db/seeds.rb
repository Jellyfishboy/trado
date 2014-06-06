@user = User.create(:email => 'admin@example.com', :password => 'admin123#')
@role = Role.create(:name => 'admin')
Permission.create(:user_id => @user.id, :role_id => @role.id)
StoreSetting.create(:user_id => @user.id)
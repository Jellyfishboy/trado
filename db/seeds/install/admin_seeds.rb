puts '-----------------------------'
puts 'Executing admin seeds'.colorize(:green)

user = User.create({
    email: 'admin@example.com', 
    password: 'admin123#'
})
role = Role.create({
    name: 'admin'
})
Permission.create({
    user_id: user.id, 
    role_id: role.id
})
store_setting = StoreSetting.create({
    user_id: user.id
})
Attachment.create([
    {
        attachable_id: user.id,
        attachable_type: 'User',
        file: File.open(File.join(Rails.root, '/public/images/tomdallimoreprofile.jpg')),
        default_record: false
    },
    {
        attachable_id: store_setting.id,
        attachable_type: 'StoreSetting',
        file: File.open(File.join(Rails.root, '/public/images/tomdallimore.png')),
        default_record: false
    }
])
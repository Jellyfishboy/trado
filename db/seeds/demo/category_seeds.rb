puts '-----------------------------'
puts 'Executing category seeds'.colorize(:green)

categories = ["Computing", "Storage", "Components", "Software"]

categories.each_with_index do |category, index|
    Category.create(
        name: category, 
        description: "Description about your #{category} category", 
        active: true, 
        sorting: index,
        page_title: "Page title for your #{category} category",
        meta_description: "Meta description for your #{category} category"
    )
end
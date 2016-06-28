puts '-----------------------------'
puts 'Executing page seeds'.colorize(:green)

about_page = Page.create(
    [
        {
            title: 'About',
            menu_title: 'About',
            content: 6.times.map{ "<p>#{Faker::Lorem.paragraph(7)}</p>" }.join(""),
            page_title: 'About',
            meta_description: 'Short description about your store for search engines',
            slug: 'about',
            active: true,
            template_type: 0
        },
        {
            title: 'Contact',
            menu_title: 'Contact',
            content: 2.times.map{ "<p>#{Faker::Lorem.paragraph(7)}</p>" }.join(""),
            page_title: 'Contact',
            meta_description: 'Short description about how to contact your store for the search engines',
            slug: 'contact',
            active: true,
            template_type: 1
        },
        {
            title: 'Terms & Conditions',
            menu_title: 'T&C',
            content: 6.times.map{ "<p>#{Faker::Lorem.paragraph(7)}</p>" }.join(""),
            page_title: 'Contact',
            meta_description: 'Short description about your Terms & Conditions for your store for the search engines',
            slug: 'terms',
            active: true,
            template_type: 0    
        },
        {
            title: 'Frequently asked questions',
            menu_title: 'FAQ',
            content: 6.times.map{ "<p>#{Faker::Lorem.paragraph(7)}</p>" }.join(""),
            page_title: 'Contact',
            meta_description: 'Short description about your FAQ for your store for the search engines',
            slug: 'faq',
            active: true,
            template_type: 0
        },
        {
            title: 'Delivery',
            menu_title: 'Delivery',
            content: 6.times.map{ "<p>#{Faker::Lorem.paragraph(7)}</p>" }.join(""),
            page_title: 'Delivery',
            meta_description: 'Short description about your Delivery for your store for the search engines',
            slug: 'delivery',
            active: true,
            template_type: 0
        }
    ]
)
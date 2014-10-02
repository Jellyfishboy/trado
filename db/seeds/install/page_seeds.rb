puts '-----------------------------'
puts 'Executing page seeds'.colorize(:green)

about_page = Page.new({
    title: 'About',
    content: 'The content for your About page',
    page_title: 'About',
    meta_description: 'Short description about your store for search engines',
    slug: 'about',
    active: true,
    template_type: 0
})
about_page.save(validate: false)
contact_page = Page.new({
    title: 'Contact',
    content: 'The content for your Contact page',
    page_title: 'Contact',
    meta_description: 'Short description about how to contact your store for the search engines',
    slug: 'contact',
    active: true,
    template_type: 0
})
contact_page.save(validate: false)
terms_page = Page.new({
    title: 'Terms & Conditions',
    content: 'The content for your Terms & Conditions page',
    page_title: 'Contact',
    meta_description: 'Short description about your Terms & Conditions for your store for the search engines',
    slug: 'terms',
    active: true,
    template_type: 0    
})
terms_page.save(validate: false)
faq_page = Page.new({
    title: 'FAQ',
    content: 'The content for your FAQ page',
    page_title: 'Contact',
    meta_description: 'Short description about your FAQ for your store for the search engines',
    slug: 'faq',
    active: true,
    template_type: 0
})
faq_page.save(validate: false)

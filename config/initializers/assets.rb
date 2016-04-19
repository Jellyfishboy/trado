# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += [ 'administration.js', 
                                'administration.css',
                                'custom.css', 
                                'css3-fallback.js', 
                                'modernizr/modernizr.js', 
                                'products.js',
                                'admin/soca.datepicker.js',
                                'admin/chart.js',
                                'typeahead.js/dist/typeahead.jquery.min.js',
                                'theia-sticky-sidebar/js/theia-sticky-sidebar.js',
                                'themes'
                              ]

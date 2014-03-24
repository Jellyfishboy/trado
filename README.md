#Trado

[![Build Status](https://magnum.travis-ci.com/Jellyfishboy/trado.png?token=QokxWaDSkksHTjy7pT4N&branch=master)](https://magnum.travis-ci.com/Jellyfishboy/trado)

Trado is an automated enterprise e-commerce solution, built to be easy to manage and lightweight.

#Configuration

##How to configure

Customising Trado to suit your environment has been simplified with a single global YAML setting file, located at *config/settings.yml* - it cannot be moved from this location. The majority of the functionality detailed below has configuration values located within this file, which can be modified to suit your environment requirements. Furthermore, additional setting values can be added to the file for use throughout your application, if required. 

This file is initialized upon running the rails server, before any other configuration initialisation - the **Settings** constant can therefore be accessed by a multitude of application configuration files.

*Please note*: The global YAML setting file should not contain any sensitive data which you wouldn't share with the public. All secure data should be stored in environment variables; you can find a few examples below.



    mailer:
        development:
            server: smtp.mandrillapp.com
            port: 587
            domain: localhost:3000
            user_name: user@example.com
            password: <%= ENV['MANDRILL_PWD'] %>
            host: localhost:3000
        production:
            server: smtp.mandrillapp.com
            port: 587
            domain: www.example.com
            user_name: user@example.com
            password: <%= ENV['MANDRILL_PWD'] %>
            host: www.example.com
    paypal:
        development:
            login: <%= ENV['PAYPAL_DEV_LOGIN'] %>
            password: <%= ENV['PAYPAL_DEV_PWD'] %>
            signature: <%= ENV['PAYPAL_DEV_SIG'] %>
        production:
            login: <%= ENV['PAYPAL_LOGIN'] %>
            password: <%= ENV['PAYPAL_PWD'] %>
            signature: <%= ENV['PAYPAL_SIG'] %>
    aws:
        s3:
            id: <%= ENV['GIMSON_AWS_ID'] %>
            key: <%= ENV['GIMSON_AWS_KEY'] %>
            bucket: example-bucket-production
            region: eu-west-1
        cloudfront:
            host:
                carrierwave: http://cdn0.example.com
                app: http://cdn%d.example.com
            prefix: /assets
    sitemap:
        host: 'http://www.example.com'

##Search

The search engine implementation within Trado is built using **Elasticsearch**. There are three reasons why Trado uses Elasticsearch: auto completion, conversion and personalisation. Auto completion allows search results to be suggested and returned as JSON to the user on the fly. Whereas conversion and personalisation can tailor these suggestions either by frequently visited results or a users recent purchases. This functionality allows the platform to deliver a rich user experience when navigating around the site.

You will need to ensure Elasticsearch has been successfully installed on your environment. Head over to the [Elasticsearch official site](http://www.elasticsearch.org) for more information on installing the service on your operating system.

In order for Rails to communicate with the Elasticsearch server, a gem has been added to the application called [**searchkick**](https://github.com/ankane/searchkick). When operating, the Elasticsearch server usually runs on port 9200 - this can be customised along with several other settings.

If you decide to modify the setup of Elasticsearch, you will need to reindex the index database. This has already been setup in a daily cron job for the conversions, however you can trigger it with the following command:

    rake searchkick:reindex class=PRODUCT

Please note, this example is using product as the target model; be sure to replace this with your relevant model.

##Mail

Mail is an important part of an ecommerce platform, whether its an order confirmation, delivery notice or stock level warning. Therefore, to ensure reliability and scalability, Trado utilises a third party SMTP server called [**Mandrill**](http://www.mandrill.com/).

Mandrill offers a lot of benefits including detailed delivery reporting, reliability and swift delivery times. The platform is built upon the renowned Mailchimp system; taking advantage of an extensive worldwide delivery network. All of this combined with 12,000 free emails per month collates into a formidable delivery system for your platform.

You can acquire your personal API key for Mandrill at www.mandrillapp.com, and in turn modify the global YAML setting file with your new credentials.

If you wish to use an alternative service, you can modify your development and/or production configuration to add your preferred SMTP server details.

##Payment gateway

The payment gateway within Trado utilises the very popular [**activemerchant**](https://github.com/Shopify/active_merchant) gem - an open source project by the Shopify team. The ideology behind the gem is to provide a solution which doesn't require setup and initialisation for each different payment method, thereby removing the requirement of managing each payment method individually.

Currently Trado only supports [**PayPal**](http://www.paypal.com) as a form of payment, although this will be changing in future versions to accommodate for Google checkout and credit card payments.

You will need to define two different API access credentials for development and production, as these indicate which account any successful transactions should be deposited to. You can set up a developer API credential for development and production at the [PayPal developer center](http://developer.paypal.com) and add the new credentials to the global YAML setting file, detailed above. When testing your application on the development environment, utilise the [PayPal Sandbox](https://www.sandbox.paypal.com/) to generate and complete fake payments, receipts and accounts.

Please note, these credentials reference the desired account to receive PayPal payments, so be sure to check your credentials when deploying for production.

##Image processing

Maintaining your media library can quickly become an unnecessary hassle. Trado has been designed to provide efficient and configurable media management, with the help of several third party tools. One of these tools, [**Carrierwave**](https://github.com/carrierwaveuploader/carrierwave), provides the ability to upload media to an external storage and prevent your web server from being consumed by media files. With the additional aid of [**ImageMagik**](http://www.imagemagick.org/), you can define processing dimensions and compression quality (check out the Getting Started documentation for more information on installing ImageMagik to your environment). This will result in quicker response times and allow your media to be securely managed on a separate server.

Trado has been set up to use [**Amazon Web Services (AWS)**](http://aws.amazon.com/) S3 simple storage as the external storage server. These settings can be modified in the global YAML setting file detailed above. If you would like to use a different provider, check out of the Carrierwave documentation in the Github repository wiki. 

Please note, for development purposes, the external media server configuration has only been set up for the production environment. If you would like to save media files to the local filesystem on the production environment, modify *config/initializers/carrierwave_config.rb* to the following:

    CarrierWave.configure do |config|
    	
    	config.storage = :file
    
    end

##Asset management

The asset management within Trado is not your typical setup. When deploying the application to the production server, the application assets are configured to be uploaded to an external storage server - the storage server has been configured as the same for image uploads to ensure a clean collection of resources. There are two reasons for this architechture choice: save web server storage and increase asset response time (response times will be explained further in the Content delivery network section).

If you would like to modify the external storage server configuration to point to a different provider, consult the [**asset_sync**](https://github.com/rumblelabs/asset_sync) gem documentation and modify the global YAML setting file retrospectively.

However, if you would like to retain your application assets on the local web server, remove the asset_sync gem amd the asset_sync.rb initializer file.


##Content delivery network


Ensuring swift response times in your application is an important attribute for your end user experience. In order to improve the speed of Trado, a content delivery network configuration has been introduced. To ensure consistency AWS (Amazon web services) Cloudfront has been utilised.

##Sitemap generator

Gaining a prominent web presence is an important part to running a successful website. Listing rich content from your site on popular search engines is a sure fire way of increasing presence, however updating a sitemap after every update can be a tedious approach. Trado has been set up to automatically create a new sitemap every day, utilising data from category, product, about and contact pages. In turn Google and Bing are pinged to indicate a new sitemap is ready for retrieval and processing.

You will need to modify the *sitemap.host* value in the global YAML setting file detailed above, with your preferred domain name. If you would like more information on configuring this functionality, check out the [**sitemap_generator**](https://github.com/kjvarga/sitemap_generator) gem.


##How to contribute

* Fork the project
* Create your feature or bug fix
* Add the requried tests for it.
* Commit (do not change version or history)
* Send a pull request against the *development* branch

##Copyright

Copyright (c) 2014 Tom Dallimore. See LICENSE for details.

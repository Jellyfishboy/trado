set :output, "/home/gimsonrobotics/current/log/schedule.log"

job_type :rbenv_rake, %Q{export PATH=/opt/rbenv/shims:/opt/rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && RAILS_ENV=production bundle exec rake :task --silent :output }
job_type :rbenv_runner, %Q{export PATH=/opt/rbenv/shims:/opt/rbenv/bin:/usr/bin:$PATH; eval "$(rbenv init -)"; \
                         cd :path && RAILS_ENV=production bundle exec rails runner :task --silent :output }

every 1.day, at: '4:00am' do
    rbenv_runner "Cart.clear_carts"
end

every 1.day, at: '5:00 am' do
    rbenv_rake "-s sitemap:refresh"
end

every 1.day, at: '9:00 am' do
    rbenv_runner "Mailatron4000::Stock.notify"
end

every 1.week, at: '8:00 am' do
    rbenv_runner "RegeneratePopularCountriesJob.perform_later"
end


FROM ruby:2.3.1

# check Dockerfile.development for development version of dockerfile

RUN gem install bundler

# Preinstall gems. This will ensure that Gem Cache wont drop on code change
WORKDIR /tmp
ADD ./puppies/Gemfile Gemfile
ADD ./puppies/Gemfile.lock Gemfile.lock
RUN (bundle check || bundle install --without development test)

RUN mkdir /app
ADD ./puppies/ /app
WORKDIR /app
RUN (bundle check || bundle install --without development test)

RUN RAILS_ENV=production rake assets:precompile

ADD ./docker/start_server.sh /usr/local/bin/
CMD bash /usr/local/bin/start_server.sh

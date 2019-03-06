FROM ruby:2.5

ENV LANG C.UTF-8
ENV WORKSPACE=/usr/local/src

# install bundler.
RUN apt-get update && \
    apt-get install -y vim less && \
    apt-get install -y build-essential libpq-dev && \
    gem install bundler && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

# create user and group.
RUN groupadd -r --gid 1000 rails && \
    useradd -m -r --uid 1000 --gid 1000 rails

# create directory.
RUN mkdir -p $WORKSPACE $BUNDLE_APP_CONFIG && \
    chown -R rails:rails $WORKSPACE && \
    chown -R rails:rails $BUNDLE_APP_CONFIG

USER rails
WORKDIR $WORKSPACE

# bundle install.
COPY --chown=rails:rails Gemfile $WORKSPACE/Gemfile
RUN bundle install && \
    bundle exec rails new . --force --database=mysql && \
    { \
        echo "gem 'therubyracer', platforms: :ruby"; \
    } >> $WORKSPACE/Gemfile && \
    bundle update
COPY --chown=rails:rails database.yml $WORKSPACE/config/database.yml

EXPOSE  3000
CMD ["rails", "server", "-b", "0.0.0.0"]

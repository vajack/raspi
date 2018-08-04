FROM ruby:2.3.1
RUN apt-get update && \
    apt-get install -y mysql-client nodejs --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir /raspi_serve

WORKDIR /raspi_serve

ADD Gemfile /raspi_serve/Gemfile
ADD Gemfile.lock /raspi_serve/Gemfile.lock

RUN gem install bundler
RUN bundle install

ADD . /raspi_serve


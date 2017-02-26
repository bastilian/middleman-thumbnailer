FROM alpine

RUN apk update && apk upgrade
RUN apk add curl wget bash ruby ruby-io-console ruby-bundler nodejs \
        curl-dev ruby-dev build-base libffi-dev imagemagick imagemagick-dev git
RUN npm install phantomjs-prebuilt

RUN mkdir -p /src/middleman-thumbnailer/lib/middleman-thumbnailer
WORKDIR /src/middleman-thumbnailer

COPY Gemfile* /src/middleman-thumbnailer/
COPY middleman-thumbnailer.gemspec /src/middleman-thumbnailer/
COPY lib/middleman-thumbnailer/version.rb \
     /src/middleman-thumbnailer/lib/middleman-thumbnailer/

RUN bundle install --with development,test


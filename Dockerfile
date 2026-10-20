FROM ruby:3.2-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    imagemagick \
    libheif1 \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && bundle install

COPY . .

ENV HOST=0.0.0.0
ENV PORT=4568
EXPOSE 4568

CMD ["bundle", "exec", "ruby", "server.rb"]
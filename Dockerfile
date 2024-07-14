# Dockerfile
FROM ruby:3.3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set environment variables
ENV RAILS_ENV production
ENV BUNDLE_PATH /bundle
ENV SECRET_KEY_BASE your_secret_key_base_here

# Create and set the working directory
RUN mkdir /app
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the image
COPY Gemfile Gemfile.lock ./

# Install gems
RUN gem install bundler && bundle install --verbose

# Copy the rest of the application code
COPY . .

# Precompile assets
RUN bundle exec rails assets:precompile

# Expose port
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

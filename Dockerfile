# Use the official Ruby image from the Docker Hub
FROM ruby:3.3.0

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev curl

# Install Node.js and npm
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install -y nodejs

# Verify that Node.js and npm are installed
RUN node -v
RUN npm -v

# Install Yarn
RUN npm install -g yarn

# Verify that Yarn is installed
RUN yarn -v

# Set an environment variable to store where the app is installed inside the Docker image
ENV RAILS_ROOT=/myapp
RUN mkdir -p $RAILS_ROOT

# Set working directory
WORKDIR $RAILS_ROOT

# Gems and node_modules will be installed here
ENV BUNDLE_PATH=/gems
ENV GEM_HOME=/gems
ENV BUNDLE_APP_CONFIG=/gems

# Copy the Gemfile and Gemfile.lock into the image
COPY Gemfile Gemfile.lock ./

# Install the dependencies
RUN gem install bundler -v 2.5.14
RUN bundle install

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install node dependencies
RUN yarn install

# Copy the rest of the application code into the image
COPY . .

# Precompile assets with debug output
RUN echo "Running assets:precompile"
RUN bundle exec rake assets:precompile --trace || (echo "Precompile failed" && exit 1)

# Expose the port that Puma will listen on
EXPOSE 3000

# Copy the entrypoint script
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["entrypoint.sh"]

# Command to start the server
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

unless ENV['RAILS_DOCKER_BUILD']
module TimestampedMigrations
  def timestamped_migrations
    # Example logic for managing timestamped migrations
    # You can customize this to fit your needs

    # Here, we're just printing a message to the console
    puts "Managing timestamped migrations"

    # You can add any additional logic needed here
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.extend(TimestampedMigrations)
end
end

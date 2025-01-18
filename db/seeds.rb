# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ActiveRecord::Base.transaction do
  5.times do
    Author.create(name: Faker::Book.unique.author)
  end

  author_ids = Author.pluck(:id)

  20.times do
    Book.create(
      title: Faker::Book.title,
      description: Faker::Quote.matz,
      author_id: author_ids.sample
    )
  end

  # Index creation right at import time is not encouraged.
  # Typically, you would call create_index! asynchronously (e.g. in a cron job)
  # However, we are adding it here so that this usage example can run correctly.
  Book.__elasticsearch__.create_index! # Create NoSQL for Elasticsearch.
  Book.import # Sync the existing data into Elasticsearch. Must use a cron job.
end

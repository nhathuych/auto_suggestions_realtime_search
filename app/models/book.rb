class Book < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :author

  after_commit on: [ :create ] do
    self.__elasticsearch__.index_document
    Rails.logger.info "Wait a few minutes for the data to be updated in Elasticsearch."
  end

  after_commit on: [ :update ] do
    self.__elasticsearch__.update_document
    Rails.logger.info "Wait a few minutes for the data to be updated in Elasticsearch."
  end

  after_commit on: [ :destroy ] do
    self.__elasticsearch__.delete_document
    Rails.logger.info "Wait a few minutes for the data to be updated in Elasticsearch."
  rescue Elastic::Transport::Transport::Errors::NotFound => e
    Rails.logger.info "Document with ID #{self.id} was not found in Elasticsearch for deletion, or you may need to wait a few minutes for the data to be updated in Elasticsearch."
    Rails.logger.info "Message: #{e.message}"
  end

  # Override this function if necessary
  # def self.search(query)
  #   __elasticsearch__.search(
  #     {
  #       query: {
  #         multi_match: {
  #           query: query,
  #           fields: [ "title", "description", "author.name" ]
  #         }
  #       }
  #     }
  #   )
  # end

  settings index: { number_of_shards: 1 } do
    mappings dynamic: false do
      indexes :title, analyzer: :english, type: :text
      indexes :description, analyzer: :english, type: :text
      indexes :author do
        indexes :name, analyzer: :english, type: :text
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      only: [ :title, :description ],
      include: {
        author: {
          only: [ :name ]
        }
      }
    )
  end
end

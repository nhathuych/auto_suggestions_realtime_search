class SearchController < ApplicationController
  def search
    @results = search_for_books

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "js-books",
          partial: "books/books",
          locals: { books: @results }
        )
      end
    end
  end

  def suggestions
    @results = search_for_books

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "js-search-suggestions",
          partial: "search/suggestions",
          locals: { results: @results }
        )
      end
    end
  end

  private

  def search_for_books
    return [] if params[:query].blank?

    Book.search(params[:query]).records
  end
end

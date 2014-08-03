class PostsController < ApplicationController

  def index
  	@questions = Post.roots
  end

  def show
  	@questions = Post.roots.where.not(id: params[:id]).first(20)
  	@question = Post.find(params[:id])
  	@responses = @question.children
    @query = @question.title.downcase.gsub(/[^a-z0-9\s]/i, '').split - Post::STOP_WORDS
    @search = Post.solr_search do
      @question = Post.find(params[:id])
      @query = @question.title.downcase.gsub(/[^a-z0-9\s]/i, '').split - Post::STOP_WORDS
      fulltext @query do
        fields(:summary, :title => 10.0)
      end
      # fulltext @query.join(" ") do
      #   phrase_fields :title => 2.0
      #   phrase_slop 20
      # end
      without :entry_id, @question.entry_id
    end
  end

  def related_responses
    @post = Post.find(params[:id])
  end
end

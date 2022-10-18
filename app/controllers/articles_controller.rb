class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    #step 1: when get show/:id request hits #articles_controller
        # find the the instance matching the [:id]
    article = Article.find(params[:id])

    #if the instance is found, 
    if article

      # start keeping track of page_views using session_method
      session[:page_views] ||= 0

      #increment page_view tracker by 1, when user "gets" another show/:id
      session[:page_views] += 1

      #whiles page_views is less than 3, render article
      if session[:page_views] <= 3
        render json: article
      else
        #when page_view tracker is 3 or more:
        render json: {error: "Maximum pageview limit reached"}, status: :unauthorized
      end


    end
  


  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end

class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end

  def show
#     if params[:director].is_a?(String)
#       @movies = Movie.where(director: params[:director])
#       render 'similarDirector.html.haml'
#     end
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort] || session[:sort]
    if params[:director] != nil && params[:director] != ""
      @movies = Movie.where(director: params[:director])
      redirect_to similarD_movies_path(:director => params[:director], :title => params[:title])
      return
    end
    if (params[:director] == nil || params[:director] == "")&& params[:title] != nil
     flash[:notice] = "'#{params[:title]}' has no director info"
      @message = "'#{params[:title]}' has no director info"
   end
    case sort
    when 'title'
      ordering,@title_header = {:title => :asc}, 'bg-warning hilite'
    when 'release_date'
      ordering,@date_header = {:release_date => :asc}, 'bg-warning hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}

    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end

    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
     
    @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def samedirector
    
    
#     if params[:director] == nil
#       flash[:notice] = "'#{params[:title]}' has no director info"
#       redirect_to movies_path 
#       return
#       elsif params[:director] != nil
      #flash[:notice] = "'#{params[:movie_id]}' #{director} has no director info."
       @movies = Movie.where(director: params[:director])
      render 'similarDirector.html.haml'
#     end
  end
end

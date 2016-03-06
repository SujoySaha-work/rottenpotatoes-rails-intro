class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    
     #gather all movies
     @movies = Movie.all
     #extract all ratings
     @all_ratings = @movies.all_ratings
     
     init = Hash.new 
     # create new session and set all to true(1) for first time visit
     if session[:checked] == nil && params[:ratings] == nil
         session[:checked] = init
     	   @all_ratings.each {|x| session[:checked][x] = 1}
     end
     # save current session for ratings for user for non-first time visit
     if params[:ratings] != nil  
       	session[:checked] = params[:ratings] 
       	@checked = session[:checked]
     end
     #save the current session for user preference for alphabetical sorting order of release dates and movie names
     if params[:alphabetical_order] != nil
        session[:alphabetical_order] = params[:alphabetical_order]
        @sorted = params[:alphabetical_order] 
     end
     
     # update @movies with only required movies based on ratings and associated order
     @movies = @movies.where({rating: session[:checked].keys }).order(session[:alphabetical_order])
     
     #use previous session keys to handle edge cases
     if ( session[:checked] != params[:ratings] || session[:alphabetical_order] != params[:alphabetical_order] )
      redirect_to({ 'alphabetical_order': session[:alphabetical_order], 'ratings': session[:checked]})
     end 
   
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

end

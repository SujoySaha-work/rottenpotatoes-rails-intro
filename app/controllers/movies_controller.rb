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

     @all_ratings = Movie.all_ratings
     @checked = params[:ratings]
     init = Hash.new
     if @checked == nil
          @set_now = true #condition for first time
          @all_ratings.each {|x| init[x] = 1}
          @checked = init
     else 
          @set_now = false  
     end 
     if params[:alphabetical_order] != nil
       @movies = Movie.order(params[:alphabetical_order])
       @sorted = params[:alphabetical_order]
     elsif  params[:ratings] != nil
        @movies = Movie.where({rating:  params[:ratings].keys }).order(params[:alphabetical_order])
        @sorted = params[:alphabetical_order]
       
     else 
        @movies = Movie.all
     end

=begin     
     @movies = Movie
     
     @all_ratings = @movies.all_ratings
          
     if session[:checked] == nil    # create new session and set all to true for first time visit
         session[:checked] = Hash.new
     	   @all_ratings.each {|x| session[:checked][x] = 1}
     elsif params[:ratings]  # save current session for user for non-first time visit
       	 session[:checked] = params[:ratings]     
     end
     @checked = session[:checked]
    
     if params[:alphabetical_order]
       session[:alphabetical_order] = params[:alphabetical_order]
     end
     
     @sorted = params[:alphabetical_order]     
     sort_rate = { 'alphabetical_order': session[:alphabetical_order], 'ratings': session[:checked]}
     # retrieve only required movies 
     @movies = Movie.where({rating:  session[:checked].keys })
     # sort movies
     if session[:alphabetical_order]
       @movies = @movies.order(session[:alphabetical_order])
     end
     
     if ( session[:checked] != params[:ratings] || session[:alphabetical_order] != params[:alphabetical_order] )
       redirect_to(sort_rate)
     end
=end
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

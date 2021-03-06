class MoviesController < ApplicationController
  before_action :require_movie, only: [:show]

  def index
    if params[:query]
      data = MovieWrapper.search(params[:query])
    else
      data = Movie.all
    end

    render status: :ok, json: data
  end

  def show
    render(
      status: :ok,
      json: @movie.as_json(
        only: [:title, :overview, :release_date, :inventory],
        methods: [:available_inventory]
        )
      )
  end

  def create
    movie = Movie.new(
      title: params['title'],
      overview: params['overview'],
      release_date: params['release_date'],
      pic_url: params['pic_url'],
      external_id: params['external_id']
    )


    puts movie.image_url

    if movie.save
      render status: :ok, json: {
        id: movie.id,
        title: movie.title,
        overview: movie.overview,
        release_date: movie.release_date,
        pic_url: movie.pic_url,
        external_id: movie.external_id
      }
    else
      render status: :bad_request, json: { errors: rental.errors.messages }
    end
  end

  private

  def require_movie
    @movie = Movie.find_by(title: params[:title])
    unless @movie
      render status: :not_found, json: { errors: { title: ["No movie with title #{params["title"]}"] } }
    end
  end
end

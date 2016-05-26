class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :show, :like]
  before_action :require_user, except: [:show, :index, :like]
  before_action :require_user_like, only: [:like]
  before_action :require_same_user, only: [:edit, :update]

  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 4)
    #@recipes = Recipe.all.sort_by{|likes| likes.thumbs_up_total - likes.thumbs_down_total}.reverse
  end
  
  def show
    
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = current_user
    
    if @recipe.save
      flash[:success] = "Dobrota byla zapsána!"
      redirect_to recipes_path
      
    else
      render :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @recipe.update(recipe_params)
      flash[:success] = "Dobrota úspěšně upravena."
      redirect_to recipe_path(@recipe)
    else
      render :edit
    end
  end
  
  def like
    like = Like.create(like: params[:like], chef: current_user, recipe: @recipe)
    if like.valid?
      flash[:success] = "Názor byl zaznamenán"
      redirect_to :back
    else
      flash[:danger] = "Vyjádřit názor na recept lze jen jednou"
      redirect_to :back
    end
  end
  
  private
  
    def recipe_params
      params.require(:recipe).permit(:name, :summary, :description, :picture, style_ids:[], ingredient_ids:[])
    end
    
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end
    
    def require_same_user
      if current_user != @recipe.chef
        flash[:danger] = "Můžeš upravovat pouze vlastní dobroty."
        redirect_to recipes_path
      end
    end
    
  def require_user_like
    if !logged_in?
      flash[:danger] = "Na to musíš být přihlášený."
      redirect_to :back
    end
  end

end
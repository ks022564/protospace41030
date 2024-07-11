class PrototypesController < ApplicationController
  before_action :move_to_index, only: [:edit]

  def index 
    @prototypes = Prototype.all
    # @prototype = Prototype.find(params[:id])
  end

  def new
    @prototype = Prototype.new 
  end

  def create
    @prototype = Prototype.new(message_params)
    if @prototype.save
      redirect_to root_path, notice: 'プロトタイプが保存されました'
    else
      render :new, status: :unprocessable_entity
    end
  end  

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
    @prototype = Prototype.find(params[:id])
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(message_params)
      redirect_to prototype_path(@prototype), notice: 'プロトタイプが更新されました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path, notice: 'プロトタイプが削除されました'
  end

  private

  def message_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless current_user.id == Prototype.find(params[:id]).user_id
      redirect_to action: :index
    end
  end
end

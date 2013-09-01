class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]

  # GET /answers
  # GET /answers.json
  def index
    @answers = Answer.all
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
  end

  def sign_up
    @locations = Location.all
    @categories = Category.admin_created
    @asks = Ask.not_answered.with_filters(params[:location], params[:category],
                                         params[:day], params[:time])
    if params[:location] || params[:category] || params[:day] || params[:time]
      render '_asks_table', layout: false
    end
  end

  # GET /answers/new
  def new
    @ask = Ask.find(params[:ask_id])
  end

  # GET /answers/1/edit
  def edit
  end

  # POST /answers
  # POST /answers.json
  def create
    @ask = Ask.find(answer_params[:ask_id])
    @answer = @ask.build_answer(answer_params)

    if valid_recaptcha? && @answer.save
      redirect_to thank_you_mentor_path
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /answers/1
  # PATCH/PUT /answers/1.json
  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer, notice: 'Answer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to answers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_answer
      @answer = Answer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:name, :email, :ask_id)
    end
    
    def valid_recaptcha?
      verify_recaptcha(model: @answer,
                       message: "Captcha verification failed, please try again")
    end

end

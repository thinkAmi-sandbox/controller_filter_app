class HomeController < ApplicationController
  before_action :set_form, only: :create
  before_action :validate_form, only: :create
  before_action :validate_api, only: :create

  def new
    @create_form = CreateForm.new
  end

  def create
    code = @create_form.code

    begin
      create_by_api!(code)
      flash[:messages] = ['登録できました']
      redirect_to home_new_path
    rescue StandardError
      flash[:messages] = ['登録に失敗しました']
      redirect_to home_new_path
    end
  end

  private

  def create_params
    params.require(:create_form).permit(:code)
  end

  def valid_by_api?(code)
    # 外部APIを使った確認：常にTrueを返す
    true
  end

  def create_by_api!(code)
    # 外部APIを使った登録：常にTrueを返す
    true
  end

  def set_form
    @create_form = CreateForm.new(create_params)
  end

  def validate_form
    return if @create_form.valid?

    flash[:messages] = @create_form.errors.map(&:full_message)
    redirect_to home_new_path
  end

  def validate_api
    return if valid_by_api?(@create_form.code)

    flash[:messages] = ['バリデーションエラーとなりました']
    redirect_to home_new_path
  end
end

class HomeController < ApplicationController
  def new
    @create_form = CreateForm.new
  end

  def create
    @create_form = CreateForm.new(create_params)
    if @create_form.invalid?
      flash[:messages] = @create_form.errors.map(&:full_message)
      return redirect_to home_new_path
    end

    code = @create_form.code

    unless valid_by_api?(code)
      flash[:messages] = ['バリデーションエラーとなりました']
      return redirect_to home_new_path
    end

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
end

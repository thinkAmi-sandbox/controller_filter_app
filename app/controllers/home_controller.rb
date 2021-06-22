class HomeController < ApplicationController
  def new
  end

  def create
    code = create_params[:code]

    unless code =~ /[0-9]{2}/
      flash[:messages] = ['フォーマットが異なります']
      return redirect_to home_new_path
    end

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
    params.permit(:code)
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

require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /new' do
    before { get home_new_path }

    it 'テンプレートが表示されること' do
      expect(response).to have_http_status '200'
      expect(response.body).to include('登録フォーム')
    end
  end

  describe 'POST /create' do
    let(:valid_code) { '12' }

    context '正常系' do
      before do
        params = { create_form: { code: valid_code }}
        post home_create_path(format: :json), params: params
      end

      it '入力画面にリダイレクトすること' do
        expect(response).to have_http_status '302'
      end

      it 'リダイレクト先でエラーが表示されていること' do
        follow_redirect!
        expect(response.body).to include '登録できました'
      end
    end

    context '異常系' do
      context 'code のフォーマットが不正な場合' do
        before do
          params = { create_form: { code: 'abc' }}
          post home_create_path(format: :json), params: params
        end

        it '入力画面にリダイレクトすること' do
          expect(response).to have_http_status '302'
        end

        it 'リダイレクト先でエラーが表示されていること' do
          follow_redirect!
          expect(response.body).to include 'フォーマットが異なります'
        end
      end

      context '外部APIのバリデーションでエラーになる場合' do
        before do
          expect_any_instance_of(HomeController).to receive(:valid_by_api?).once.with(valid_code).and_return(false)

          params = { create_form: { code: valid_code }}
          post home_create_path(format: :json), params: params
        end

        it '入力画面にリダイレクトすること' do
          expect(response).to have_http_status '302'
        end

        it 'リダイレクト先でエラーが表示されていること' do
          follow_redirect!
          expect(response.body).to include 'バリデーションエラーとなりました'
        end
      end

      context '外部APIの登録でエラーになる場合' do
        before do
          expect_any_instance_of(HomeController).to receive(:create_by_api!).once.with(valid_code).and_raise(StandardError)

          params = { create_form: { code: valid_code }}
          post home_create_path(format: :json), params: params
        end

        it '入力画面にリダイレクトすること' do
          expect(response).to have_http_status '302'
        end

        it 'リダイレクト先でエラーが表示されていること' do
          follow_redirect!
          expect(response.body).to include '登録に失敗しました'
        end
      end
    end
  end
end

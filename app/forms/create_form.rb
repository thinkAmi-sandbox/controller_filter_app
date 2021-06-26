class CreateForm
  include ActiveModel::Model

  attr_accessor :code

  validates :code, format: { with: /[0-9]{2}/, message: 'フォーマットが異なります' }
end

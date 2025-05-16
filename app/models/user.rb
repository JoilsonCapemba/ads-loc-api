class User < ApplicationRecord
  has_and_belongs_to_many :perfils
  has_one_attached :avatar

  # callback para definir o saldo inicial do usuario assim que criamos o user
  before_create :set_saldo_padrao

  private

  def set_saldo_padrao
    self.saldo ||= 10.0
  end
end

class Perfil < ApplicationRecord
  has_and_belongs_to_many :users
  
  # Validações
  validates :descricao, presence: true, uniqueness: true
  
  # Callbacks
  before_save :capitalize_descricao
  
  private
  
  def capitalize_descricao
    self.descricao = descricao.capitalize if descricao.present?
  end
end

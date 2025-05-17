namespace :dev do
  desc "TODO"
  task setup: :environment do
    puts "Cadastrando os users"
    10.times do |i|
      User.create!(
        email: Faker::Internet.unique.email,
        password: "1234",
        username: Faker::Internet.unique.username,
        full_name: Faker::Name.name,
        saldo: 10
      )
    end

    puts "cadastrando od Perfiss"

    5.times do |i|
      Perfil.create!(
        descricao: Faker::Team.name
      )
    end

    puts "Vinculando perfis a usuarios"


    # User.all.each do |user|
    #  Random.rand(5).times do |i|
    #    user.perfils << Perfil.find(Random.rand(5))
    #  end
    # end
  end
end

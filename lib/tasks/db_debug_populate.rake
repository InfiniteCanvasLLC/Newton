namespace :admin do
    desc "Adds users to the database, each with their own party."
    task :debug_populate_users => :environment do
        require 'faker'

        num_users = 50

        # Create users, each with their own party
        num_users.times do |i|
            user = User.create!(
                :name => Faker::Name.name,
                :email => Faker::Internet.email,
                :secondary_email => Faker::Internet.email,
                :gender => rand(2),
                :birthday => Faker::Date.between(60.year.ago, 10.year.ago),
                :zip_code => Faker::Address.zip_code,
                :description => Faker::Lorem.paragraph
            )

            party = Party.create!(
                :name => Party.random_name,
                :description => Faker::Hipster.paragraph,
                :owner_user_id => user.id
            )

            party.users << user
        end
    end

    desc "Ensures that all parties have at least 2 users."
    task :debug_populate_parties => :environment do
        min_users_per_party = 2
        max_users_per_party = min_users_per_party + 5

        users = User.all
        parties = Party.all

        # Add random users to parties
        parties.each do |party|
            users = users.sort_by { rand }
            num_members = rand(max_users_per_party - min_users_per_party) + min_users_per_party

            i = 0
            count = party.users.length
            while count < num_members && i < users.length do
                while i < users.length && party.users.include?(users[i]) do
                    i += 1
                end

                if i < users.length
                    party.users << users[i]
                    i += 1
                    count += 1
                end
            end
        end
    end

    desc "Fills in the database with dummy information."
    task :debug_populate => [:debug_populate_users, :debug_populate_parties] do
    end
end
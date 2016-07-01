namespace :fix_db do

    def print_parties
        printf("%-40s %-10s\n", "Party Name", "Owner Id")

        for i in 1..40 do printf "-" end
        printf "|"
        for i in 1..10 do printf "-" end
        printf "\n"

        Party.all.each do |cur_party|
            owner_id = cur_party.owner_user_id
            printf("%-40s %-10s\n", cur_party.name, owner_id ? owner_id.to_s : "nil")
        end
    end

    task :assign_party_owners => :environment do

        ARGV.each { |a| task a.to_sym do ; end }

        new_owner = ARGV[1]

        if (new_owner.nil?)
            puts "You must provide an Owner ID to be set for parties with no owner"
            next
        end

        printf("\nExisting Parties & Owners\n\n")

        print_parties()

        puts "\nFixing IDs...\n"

        Party.all.each do |cur_party|
            owner_id = cur_party.owner_user_id

            if (!owner_id) || (User.find_by(id: owner_id).nil?)
                cur_party.owner_user_id = new_owner
                cur_party.save
            end
        end

        puts "\nNew Parties & Owners\n\n"
        print_parties()

    end

    task :set_nonadmin => :environment do
        ARGV.each { |a| task a.to_sym do ; end }

        admin_id = ARGV[1]
        admin = User.find(admin_id)

        admin.permissions = User::PERMISSION_USER
        admin.save
    end

    task :set_admin => :environment do

        ARGV.each { |a| task a.to_sym do ; end }

        admin_id = ARGV[1]
        admin = User.find(admin_id)

        admin.permissions = User::PERMISSION_ADMINISTRATOR
        admin.save

    end

    task :clean_user_actions => :environment do

        num_records_deleted = 0

        UserAction.all.each do |cur_action|
            if (cur_action.user == nil)
                cur_action.destroy
                num_records_deleted += 1
            end
        end

        puts "Deleted " + num_records_deleted.to_s + " records"

    end

end

task :notify_party_administrators => :environment do

    User.where(permissions: 1).each do |cur_admin|

        stale_parties = []

        Party.where(administrator: cur_admin.id).each do |cur_party|

            party_recent_action_time = 0
            actions = nil

            # Collect all actions for the party
            cur_party.users.each do |cur_user|
                if (actions.nil?)
                    actions = cur_user.user_actions
                else
                    actions += cur_user.user_actions
                end
            end
            
            # Sort in descending order by creation time
            actions.sort! {|left, right| right.updated_at <=> left.updated_at}

            recent_action_time = 0

            # Find the most recent actions that aren't things like spotify actions or invites.  We're interested in new questions, or standard link_tos
            actions.each do |cur_action|

                if (cur_action.action_type == UserAction.linkto_type)
                    test_link_to = LinkTo.find(cur_action.action_id)

                    if (test_link_to.is_standard_linkto)
                        party_recent_action_time = cur_action.created_at
                        break
                    else
                        next
                    end

                else
                    party_recent_action_time = cur_action.created_at
                    break
                end
            end

            delta = Time.now - party_recent_action_time.time

            if (true)
 #           if (delta > (5 * 24 * 60 * 60))
                stale_parties << { party: cur_party, updated_at: party_recent_action_time.time }
            end
        end

        if (stale_parties.length > 0)
            Outreach.notify_stale_parties(cur_admin, stale_parties).deliver_now
        end

    end

end
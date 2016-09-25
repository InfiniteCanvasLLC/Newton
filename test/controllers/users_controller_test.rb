require 'test_helper'

class UsersControllerTest < ActionController::TestCase

    test "get all users" do
        session[:user_id] = users(:steve_jobs).id

        get :index
        assert_response :success
        assert_select '#user_table', 1

        users = User.all.sort_by {|u| u.last_seen}.reverse
        index = 0

        assert_select '#user_table > tbody > tr' do |rows|

            index = 0

            rows.each do |cur_row|

                cur_user = users[index]

                cur_cells = cur_row > 'td'

                assert cur_cells[0].content == cur_user.name
                assert cur_cells[1].content == cur_user.email

                index += 1
            end

        end
    end

    test "get all users non_admin" do
        session[:user_id] = users(:steve_wozniak).id

        get :index
        assert_response(500)
    end

    test "get specific user admin" do
        session[:user_id] = users(:steve_jobs).id

        test_user = users(:steve_wozniak)

        get :show, {'id' => test_user.id}

        assert_response :success
    end

    test "get specific user non admin" do
        session[:user_id] = users(:steve_wozniak).id

        test_user = users(:steve_jobs)

        get :show, {'id' => test_user.id}

        assert_response(500)
    end

    test "get self user admin" do
        session[:user_id] = users(:steve_jobs).id

        test_user = users(:steve_jobs)

        get :show, {'id' => test_user.id}

        assert_response :success
    end

    test "get self user non admin" do
        session[:user_id] = users(:steve_wozniak).id

        test_user = users(:steve_wozniak)

        get :show, {'id' => test_user.id}

        assert_response :success
    end

    test "edit specific user" do
        session[:user_id] = users(:steve_jobs).id

        test_user = User.all.first

        get :edit, {'id' => test_user.id}
        assert_response :success
    end

    test "edit specific user non_admin" do
        session[:user_id] = users(:steve_wozniak).id

        test_user = User.all.first

        get :edit, {'id' => test_user.id}
        assert_response(500)
    end

end

require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "get all users" do
    get :index
    assert_response :success
    assert_select '#user_table', 1

    users = User.all
    index = 0

    assert_select '#user_table > tbody > tr' do |rows|

        index = 0

        rows.each do |cur_row|

            cur_user = users[index]

            cur_cells = cur_row > 'td'
            assert cur_cells[0].children[0].content == cur_user.name
            assert cur_cells[1].children[0].content == cur_user.email

            index += 1
        end

    end

  end

  test "get specific user" do
    test_user = User.all.first

    get :show, {'id' => test_user.id}
    assert_response :success
  end

end

require 'test_helper'

class TestRackDeviseCookieAuth < Test::Unit::TestCase

  context 'no cookie secret passed' do
    should 'raise an argument error' do
      assert_raise ArgumentError do
        mock_app
      end
    end
  end

  context 'no cookie' do
    setup {
      mock_app secret: 'abcd1234'
    }

    should 'redirect to root' do
      get 'https://www.example.org/admin'
      assert_equal 302, last_response.status
      assert_equal 'https://www.example.org?user_return_to=https://www.example.org/admin', last_response.location
    end
  end

  context 'valid cookie secret passed' do
    context 'no options' do
      setup {
        mock_app secret: 'abcd1234'
        set_cookie!('remember_user_token', verifier.generate([[1], 'remember_key']))
      }

      should 'succeeds' do
        get 'https://www.example.org/admin'
        assert_equal 200, last_response.status
      end

      should 'sets current_user_id env' do
        get 'https://www.example.org/admin'
        assert_equal 1, last_request.env['current_user_id']
      end
    end

    context ':resource option' do
      setup {
        mock_app secret: 'abcd1234', resource: 'admin'
        set_cookie!('remember_admin_token', verifier.generate([[1], 'remember_key']))
      }

      should 'succeeds' do
        get 'https://www.example.org/admin'
        assert_equal 200, last_response.status
      end

      should 'sets current_user_id env' do
        get 'https://www.example.org/admin'
        assert_equal 1, last_request.env['current_admin_id']
      end
    end
  end

  context 'invalid cookie' do
    context 'no options' do
      setup {
        mock_app secret: 'abcd1234'
        set_cookie!('remember_user_token', verifier('1234abcd').generate([[1], 'remember_key']))
      }

      should 'redirect to root' do
        get 'https://www.example.org/admin'
        assert_equal 302, last_response.status
        assert_equal 'https://www.example.org?user_return_to=https://www.example.org/admin', last_response.location
      end
    end

    context ':resource option' do
      setup {
      mock_app secret: 'abcd1234', resource: 'admin'
        set_cookie!('remember_admin_token', verifier('1234abcd').generate([[1], 'remember_key']))
      }

      should 'redirect to root' do
        get 'https://www.example.org/admin'
        assert_equal 302, last_response.status
        assert_equal 'https://www.example.org?admin_return_to=https://www.example.org/admin', last_response.location
      end
    end

    context ':redirect_to option' do
      context 'full URL' do
        setup {
          mock_app secret: 'abcd1234', redirect_to: 'https://www.example.net/login'
          set_cookie!('remember_user_token', verifier('1234abcd').generate([[1], 'remember_key']))
        }

        should 'redirect to given :redirect_to' do
          get 'https://www.example.org/admin'
          assert_equal 302, last_response.status
          assert_equal 'https://www.example.net/login?user_return_to=https://www.example.org/admin', last_response.location
        end
      end

      context 'path without initial /' do
        setup {
          mock_app secret: 'abcd1234', redirect_to: 'login'
          set_cookie!('remember_user_token', verifier('1234abcd').generate([[1], 'remember_key']))
        }

        should 'redirect to given :redirect_to' do
          get 'https://www.example.org/admin'
          assert_equal 302, last_response.status
          assert_equal 'https://www.example.org/login?user_return_to=https://www.example.org/admin', last_response.location
        end
      end

      context 'path with initial /' do
        setup {
          mock_app secret: 'abcd1234', redirect_to: '/login'
          set_cookie!('remember_user_token', verifier('1234abcd').generate([[1], 'remember_key']))
        }

        should 'redirect to given :redirect_to' do
          get 'https://www.example.org/admin'
          assert_equal 302, last_response.status
          assert_equal 'https://www.example.org/login?user_return_to=https://www.example.org/admin', last_response.location
        end
      end
    end
  end
end

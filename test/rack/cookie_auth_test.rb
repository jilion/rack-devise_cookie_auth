require 'test_helper'

class TestRackCookieAuth < Test::Unit::TestCase

  context 'no cookie secret passed' do
    should 'raise an argument error' do
      assert_raise ArgumentError do
        mock_app
      end
    end
  end

  context 'no cookie' do
    setup {
      mock_app cookie_secret: 'abcd1234'
      expires_at = Time.now + 3600
    }

    should 'redirect to root' do
      get 'https://www.example.org/admin'
      assert_equal 302, last_response.status
      assert_equal 'https://www.example.org', last_response.location
    end
  end

  context 'valid cookie secret passed' do
    setup {
      @expires_at = Time.now + 3600
    }

    context 'no options' do
      setup {
        mock_app cookie_secret: 'abcd1234'
        set_cookie!('remember_user_token', verifier.generate([1, @expires_at]), @expires_at)
      }

      should 'succeeds' do
        get 'https://www.example.org/admin'
        assert_equal 200, last_response.status
      end
    end

    context ':cookie_name option' do
      setup {
        mock_app cookie_secret: 'abcd1234', cookie_name: 'admin_remember_token'
        set_cookie!('admin_remember_token', verifier.generate([1, @expires_at]), @expires_at)
      }

      should 'succeeds' do
        get 'https://www.example.org/admin'
        assert_equal 200, last_response.status
      end
    end

    context 'invalid cookie' do
      context 'no options' do
        setup {
          mock_app cookie_secret: 'abcd1234'
          set_cookie!('remember_user_token', verifier('1234abcd').generate([1, @expires_at]), @expires_at)
        }

        should 'redirect to root' do
          get 'https://www.example.org/admin'
          assert_equal 302, last_response.status
          assert_equal 'https://www.example.org', last_response.location
        end
      end

      context ':cookie_name option' do
        setup {
          mock_app cookie_secret: 'abcd1234', cookie_name: 'admin_remember_token'
          set_cookie!('admin_remember_token', verifier('1234abcd').generate([1, @expires_at]), @expires_at)
        }

        should 'redirect to given :redirect_to' do
          get 'https://www.example.org/admin'
          assert_equal 302, last_response.status
          assert_equal 'https://www.example.org', last_response.location
        end
      end

      context ':redirect_to option' do
        context 'full URL' do
          setup {
            mock_app cookie_secret: 'abcd1234', redirect_to: 'https://www.example.org/login'
            set_cookie!('admin_remember_token', verifier('1234abcd').generate([1, @expires_at]), @expires_at)
          }

          should 'redirect to given :redirect_to' do
            get 'https://www.example.org/admin'
            assert_equal 302, last_response.status
            assert_equal 'https://www.example.org/login', last_response.location
          end
        end

        context 'path without initial /' do
          setup {
            mock_app cookie_secret: 'abcd1234', redirect_to: 'login'
            set_cookie!('admin_remember_token', verifier('1234abcd').generate([1, @expires_at]), @expires_at)
          }

          should 'redirect to given :redirect_to' do
            get 'https://www.example.org/admin'
            assert_equal 302, last_response.status
            assert_equal 'https://www.example.org/login', last_response.location
          end
        end

        context 'path with initial /' do
          setup {
            mock_app cookie_secret: 'abcd1234', redirect_to: '/login'
            set_cookie!('admin_remember_token', verifier('1234abcd').generate([1, @expires_at]), @expires_at)
          }

          should 'redirect to given :redirect_to' do
            get 'https://www.example.org/admin'
            assert_equal 302, last_response.status
            assert_equal 'https://www.example.org/login', last_response.location
          end
        end
      end
    end

    context 'expired cookie' do
      setup {
        @expires_at = Time.now - 3600
      }

      context 'no options' do
        setup {
          mock_app cookie_secret: 'abcd1234'
          set_cookie!('remember_user_token', verifier.generate([1, @expires_at]), @expires_at)
        }

        should 'redirect to root' do
          get 'https://www.example.org/admin'
          assert_equal 302, last_response.status
          assert_equal 'https://www.example.org', last_response.location
        end
      end

      context ':cookie_name option' do
        setup {
          mock_app cookie_secret: 'abcd1234', cookie_name: 'admin_remember_token'
          set_cookie!('admin_remember_token', verifier.generate([1, @expires_at]), @expires_at)
        }

        should 'redirect to given :redirect_to' do
          get 'https://www.example.org/admin'
          assert_equal 302, last_response.status
          assert_equal 'https://www.example.org', last_response.location
        end
      end

      context ':redirect_to option' do
        setup {
          mock_app cookie_secret: 'abcd1234', redirect_to: 'https://www.example.org/login'
          set_cookie!('admin_remember_token', verifier.generate([1, @expires_at]), @expires_at)
        }

        should 'redirect to given :redirect_to' do
          get 'https://www.example.org/admin'
          assert_equal 302, last_response.status
          assert_equal 'https://www.example.org/login', last_response.location
        end
      end
    end

  end
end

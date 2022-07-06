module DigifactServices
  module Helper
    def api_url
      if test_mode?
        return 'https://felgttestaws.digifact.com.gt/gt.com.fel.api.v3/api'
      else
        return 'https://felgtaws.digifact.com.gt/gt.com.fel.api.v3/api'
      end
    end

    def api_download_url
      'https://felgtaws.digifact.com.gt/gt.com.fel.api.v3/api/FelRequest'
    end

    def test_mode?
      @current_user.account.id === 1 || Rails.env == 'development'
    end
  end
end

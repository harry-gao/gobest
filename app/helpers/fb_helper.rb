require 'open-uri'
require 'json'
module FbHelper
  def get_user_name(userId)
    file = open("https://graph.facebook.com/#{userId}")
    content = file.read
    data = ActiveSupport::JSON.decode(content)
    data["name"]
  end

  def get_user_first_name(userId)
    file = open("https://graph.facebook.com/#{userId}")
    content = file.read
    data = ActiveSupport::JSON.decode(content)
    data["first_name"]
  end

  def setup_user(signed_request)
    app_id = "215315865221632";
    #canvas_page = "http://my.local:3000/home/mypage/";
    canvas_page = "http://apps.facebook.com/215315865221632/"
    @auth_url = "http://www.facebook.com/dialog/oauth?client_id=#{app_id}&redirect_uri=#{CGI::escape(canvas_page)}&scope=email,read_stream";

    fb_params = signed_request.split(".")

    decoded = base64_url_decode(fb_params[1])

    data = ActiveSupport::JSON.decode(decoded)

    if(data.has_key?("user_id"))
      session["fb_user_id"] = data['user_id'];
      session["fb_token"] = data['oauth_token']
      session["fb_user_name"] = get_user_name(data['user_id'])
      true
    else
      render :authorize
      false
    end
end

  def base64_url_decode(str)
    str += '=' * (4 - str.length.modulo(4))
    Base64.decode64(str.tr('-_','+/'))
  end
end

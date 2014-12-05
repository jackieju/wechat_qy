require "prpcrypt.rb"
require "qyapp.rb"
require "pkcs7_encoder.rb"
# require 'multi_xml'

class QyController < ApplicationController
    
    def index
        p "===>index"
        @qy_app = QyApp.new
        if not valid_msg_signature(params)
          Rails.logger.debug("#{__FILE__}:#{__LINE__} Failure because signature is invalid")
          render :text=>"", :status=>401
          return
        end
        if params[:echostr] # check to enable callback mode
            content, status = Prpcrypt.decrypt(aes_key, params[:echostr], corp_id)
            render :text=>content
        else
            # setup_wechat_message
            content, status = Prpcrypt.decrypt(aes_key, params[:xml][:Encrypt], corp_id)
            p "content=#{content}"
            render :text=>content
        end
    end
    
    # 验证URL有效性
    # TODO: refactor
    def verify_url
      if not valid_msg_signature(params)
        Rails.logger.debug("#{__FILE__}:#{__LINE__} Failure because signature is invalid")
        render :text=>"", :status=> 401
        return
      end
      content, status = Prpcrypt.decrypt(aes_key, params[:echostr], corp_id)
      # render :text=> content, :status=> status
    end


private

        def setup_wechat_message
            p "setup_wechat_message"
          param_xml       = request.body.read
          hash            = MultiXml.parse(param_xml)['xml']
          p "hash=>#{hash.inspect}"
          @body_xml       = OpenStruct.new(hash)
          p "@body_xml =>#{@body_xml.inspect}"
          
          content         = Prpcrypt.decrypt(aes_key, @body_xml.Encrypt, corp_id)[0]
          hash            = MultiXml.parse(content)["xml"]
          @weixin_message = Message.factory(hash)
          @keyword        = @weixin_message.Content
          
          p "@weixin_message =>#{@weixin_message.inspect}"
          p "@keyword =>#{@keyword.inspect}"
          
        end

        def encoding_aes_key
          key = @qy_app.encoding_aes_key
          raise "长度固定为43个字符" if key.length != 43
          key
        end

        def qy_token
          @qy_app.qy_token

        end

        def aes_key
          Base64.decode64(@qy_app.encoding_aes_key + "=")
        end

        def corp_id
          @qy_app.corp_id
        end

        def valid_msg_signature(params)
          timestamp         = params[:timestamp]
          nonce             = params[:nonce]
          echo_str          = params[:echostr]
          msg_signature     = params[:msg_signature]
          xml = params[:xml][:Encrypt] if params[:xml]
          p params.inspect
          p "==>#{[qy_token, timestamp, nonce, echo_str].inspect}"
          if echo_str
              sort_params = [qy_token, timestamp, nonce, echo_str] 
          elsif xml
              sort_params = [qy_token, timestamp, nonce, xml] 
          end
          sort_params       = sort_params.sort.join
          current_signature = Digest::SHA1.hexdigest(sort_params)
          Rails.logger.info("current_signature: #{current_signature} ")
          current_signature == msg_signature
        end

        # def setup_qy_app
        #   qy_secret_key = params.delete(:qy_secret_key)
        #   @qy_app ||= QyWechat.qy_model.find_by_qy_secret_key!(qy_secret_key: qy_secret_key)
        # end
    
end


module Facebook
  class Request
		def cat( args )
			args.keys.sort_by{|s| s.to_s}.map{|k| "#{k}=#{args[k]}"}.join
		end

		def signature( args, secret )
			Digest::MD5.hexdigest( cat(args) + secret )
		end

		def prepare( args, secret, call_at = nil )
      call_at ||= microtime
			without_sig = args.merge({ :call_at => call_at })
			without_sig.merge(:sig => signature(without_sig, secret))
		end
    
    private
		def microtime
			Time.now.to_f
		end
  end
end

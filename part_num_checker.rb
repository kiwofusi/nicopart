# ニコニコ動画のpart数ごとの動画件数を調べる
require 'kconv'
require 'net/https'
require 'uri'
require 'rubygems'
require 'json'

mail = ARGV[0]
pass = ARGV[1]
numbering_word = ARGV[2] || "part".tosjis # "その" "第" など
search_from = (ARGV[3] || 1).to_i
max_search_num = (ARGV[4] || 10).to_i # 2013-05-23時点の"part"最大数: 約560
numbering_word_suffix = ARGV[5] || "".tosjis # "話" "回" など
output_file_name = "#{numbering_word}#{search_from}-" # 処理完了後にも追記
sleep_sec = 3 # 1秒間隔だとすぐ弾かれる

def login_nicovideo(mail, pass) # http://hai3.net/blog/2011/07/21/ruby-niconico/
	host = 'secure.nicovideo.jp'
	path = '/secure/login?site=niconico'
	body = "mail=#{mail}&password=#{pass}"
	https = Net::HTTP.new(host, 443)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_NONE
	response = https.start do |https|
		https.post(path, body)
	end
	
	# deletedになっていないクッキーを抽出する
	response['set-cookie'].split('; ').each do |st|
		idx = st.index('user_session_')
		return "user_session=#{st[idx..-1]}" if idx
	end
end

def search_num(cookie, word)
	# http://www.trinity-site.net/blog/?p=201
	host = "ext.nicovideo.jp"
	path = "/api/search/search/#{URI.escape(word.toutf8)}?mode=watch&order=d&page=1&sort=n"
	response = Net::HTTP.new(host).start do |http|
		request = Net::HTTP::Get.new(path)
		request['cookie'] = cookie
		http.request(request)
	end
	result = JSON.parse(response.body)
	puts result["message"].to_s if $DEBUG && (result["status"] == "fail")
	return result["count"]
end

last_search_num = 0
File.open(output_file_name, "w") do |file|
	# 見出しを書き出す
	if numbering_word_suffix.size > 0
		file.puts "#{numbering_word + "*" + numbering_word_suffix}, result"
	else
		file.puts "#{numbering_word}, result" 
	end
	cookie = login_nicovideo(mail, pass)
	(max_search_num - (search_from-1)).times do |i| 
		part_num = i + search_from
		search_word = numbering_word + part_num.to_s + numbering_word_suffix
		search_result_num = search_num(cookie, search_word)
		break unless search_result_num # 取得失敗
		last_search_num = part_num
		file.puts "#{part_num}, #{search_result_num}"
		sleep sleep_sec
	end
end
File.rename(output_file_name , output_file_name + "#{last_search_num}#{numbering_word_suffix}.csv")




# ニコニコ動画のpart数ごとの動画件数を調べる
require 'net/https'
require 'rubygems'
require 'json'

numbering_word = "part"

search_from = 1
output_file_name = "#{numbering_word} from #{search_from}.csv"
output_file = File.open(output_file_name, "w")
output_file.puts "part, result" # 見出し

# ニコニコ動画にログインする
mail = "kiwofusi@yahoo.co.jp"
pass = "jsesguds"
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
cookie = login_nicovideo(mail, pass)

def search_num(cookie, word)
	# http://www.trinity-site.net/blog/?p=201
	host = "ext.nicovideo.jp"
	path = "/api/search/search/#{word}?mode=watch&order=d&page=1&sort=n"
	response = Net::HTTP.new(host).start do |http|
		request = Net::HTTP::Get.new(path)
		request['cookie'] = cookie
		http.request(request)
	end
	return JSON.parse(response.body)["count"]
end

search_to = search_from # 最後に検索したpart数
max_search_num = 2#561 # 2013-05-23時点の"part"最大数
(max_search_num - (search_from-1)).times do |i| 
	search_to = part_num = i + search_from
	search_result_num = search_num(cookie, numbering_word + part_num.to_s)
	output_file.puts "#{part_num}, #{search_result_num}"
end
output_file.close
File.rename(output_file_name, output_file_name[0..-5] + " to #{search_to}.csv")





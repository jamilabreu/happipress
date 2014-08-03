require 'open-uri'

1.upto(30).each do |number|
	page = Nokogiri::HTML(open("http://en.forums.wordpress.com/forum/support/page/#{number}"))

	page.css("table.widefat tr").each do |row|
		array = []
		url = row.css("td/a/@href").to_s
		if url.present?
			Nokogiri::HTML(open(url)).css("#content").each do |content|
				content.css('.col-10 li').each_with_index do |table, index|
					id = table.css('/@id').to_s
					entry_id = id.split("-")[1]
					summary = table.css('.post').to_s
					username = table.css('.threadauthor/p/strong/a').text.to_s
					user = User.find_or_create_by(username: username) do |f|
						f.image = table.css('.threadauthor/p/img/@src').to_s
						f.blog_url = table.css('.threadauthor/p/strong/a/@href').to_s
						f.profile_url= table.css('.threadauthor/p/small/span/a/@href').to_s
					end
					if index == 0
						title = content.css(".topictitle h2").text.to_s
						parent = Post.create(title: title, url: url, entry_id: entry_id, summary: summary, user_id: user.id)
						array << parent
					else
						Post.create(url: url + "?replies##{id}", entry_id: entry_id, summary: summary, parent: array.first, user_id: user.id)
					end
				end
			end
		end
	end
end
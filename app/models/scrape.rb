class Scrape
	attr_accessor :title, :hotness, :image_url, :rating, :director, :genre, :release_date, :runtime, :synopsis, :failure

	def scrape_new_movie(url)
		begin
			doc = Nokogiri::HTML(open(url))
			doc.css('script').remove
			self.title = doc.at("//h1[@itemprop = 'name']").text
			self.hotness = doc.at("//span[@itemprop = 'ratingValue']").text.to_i
			self.image_url = doc.at_css("#movie-image-section img")['src']
			self.rating = doc.at("//td[@itemprop = 'contentRating']").text
			self.director = doc.at("//span[@itemprop = 'name']").text
			self.genre = doc.at("//span[@itemprop = 'genre']").text
			self.release_date = doc.at("//meta[@itemprop = 'datePublished']")[:content].to_date
			self.runtime = doc.at("//time[@itemprop = 'duration']").text
			self.synopsis = doc.css("#movieSynopsis").text.tidy_bytes

			return true
		rescue Exception => e
			raise e
			self.failure = "Something went wrong with the scrape"
		end
	end
end
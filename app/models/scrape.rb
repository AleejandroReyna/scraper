class Scrape
	attr_accessor :title, :hotness, :image_url, :rating, :director, :genre, :release_date, :runtime, :synopsis, :failure

	def scrape_new_movie
		begin
			doc = Nokogiri::HTML(open("http://www.rottentomatoes.com/m/the_martian/"))
			doc.css('script').remove
			self.title = doc.at("//h1[@itemprop = 'name']").text
			self.hotness = doc.at("//span[@itemprop = 'ratingValue']").text.to_i
			self.image_url = doc.at_css("#movie-image-section img")['src']
			self.rating = doc.at("//td[@itemprop = 'contentRating']").text
			self.director = doc.at("//span[@itemprop = 'name']").text
			self.genre = doc.at("//span[@itemprop = 'genre']").text
			self.release_date = doc.at("//meta[@itemprop = 'datePublished']")[:content].to_date
			self.runtime = doc.at("//time[@itemprop = 'duration']").text
			s = doc.css("#movieSynopsis").text
			if ! s.valid_encoding?
				s = s.encode("UTF-16be", :invalid => :replace, :replace => "?").encode("UTF-8")
			end
			return true
		rescue Exception => e
			raise e
			self.failure = "Something went wrong with the scrape"
		end
	end

	def save_movie
		movie = Movie.new(
			title: self.title,
			hotness: self.hotness,
			image_url: self.image_url,
			synopsis: self.synopsis,
			rating: self.rating,
			genre: self.genre,
			director: self.director,
			release_date: self.release_date,
			runtime: self.runtime,
		)
		movie.save
	end
end
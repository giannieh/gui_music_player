require 'rubygems'
require 'gosu'

TOP_COLOR = Gosu::Color.new(0xff_808080)
BOTTOM_COLOR = Gosu::Color.new(0xff_00ffff)
SCREEN_W = 500
SCREEN_H = 600
X_LOCATION = 250

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Artwork
	attr_accessor :bmp
	def initialize(file)
		@bmp = Gosu::Image.new(file)
	end
end

class Album
	attr_accessor :title, :artist, :artwork, :tracks
	def initialize (title, artist, artwork, tracks)
		@title = title
		@artist = artist
		@artwork = artwork
		@tracks = tracks
	end
end

class Track
	attr_accessor :name, :location, :dim
	def initialize(name, location, dim)
		@name = name
		@location = location
		@dim = dim
	end
end

class Dimension
	attr_accessor :leftX, :topY, :rightX, :bottomY
	def initialize(leftX, topY, rightX, bottomY)
		@leftX = leftX
		@topY = topY
		@rightX = rightX
		@bottomY = bottomY
	end
end

class MusicPlayerMain < Gosu::Window

	def initialize
	    super SCREEN_H, SCREEN_W
	    self.caption = "music player"
	    @track_font = Gosu::Font.new(21)
	    @album = read_album()
		@current_track = 0
		playTrack(@current_track, @album)
	end

  	# Procedure to read one song
	def read_track(music_file, i)
		track_name = music_file.gets.chomp
		track_location = music_file.gets.chomp
		leftX = X_LOCATION
		topY = (40 * i + 80)
		rightX = leftX + @track_font.text_width(track_name)
		bottomY = topY + @track_font.height()
		dim = Dimension.new(leftX, topY, rightX, bottomY)

		# the track object
		track = Track.new(track_name, track_location, dim)
		return track
	end

	# Reads all of the songs in a single album
	def read_tracks(music_file)
		count = music_file.gets.chomp.to_i
		tracks = Array.new
		i = 0
		while i < count
			track = read_track(music_file, i)
			tracks << track
			i += 1
		end
		return tracks
	end

	# Reads a single album
	def read_album()
		music_file = File.new("input.txt", "r")

		title = music_file.gets.chomp
		artist = music_file.gets.chomp
		artwork = Artwork.new(music_file.gets.chomp)
		tracks = read_tracks(music_file)

        # the album object
		album = Album.new(title, artist, artwork.bmp, tracks)

		music_file.close()
		return album
	end

    # Draws a single album
	def draw_album()
		@album.artwork.draw(60,75,z = ZOrder::PLAYER, 0.8, 0.8)
		@album.tracks.each do |track|
			display_track(track)
		end
	end
    # Draws a track
	def draw_track_current(index)
		draw_rect(@album.tracks[index].dim.leftX - 20, @album.tracks[index].dim.topY, 10, @track_font.height(), Gosu::Color::WHITE, z = ZOrder::PLAYER)
	end

	# Detects if a mouse area has been clicked on.
	def area_clicked(leftX, topY, rightX, bottomY)
		if mouse_x > leftX && mouse_x < rightX && mouse_y > topY && mouse_y < bottomY
			return true
		end
		if ((mouse_x>40 && mouse_x<165) && (mouse_y>300 && mouse_y<425))
			@song.play
		end
		if ((mouse_x>175 && mouse_x<300) && (mouse_y>300 && mouse_y<425))
			@song.pause
		end
		return false
	end

	def display_track(track)
		@track_font.draw(track.name, X_LOCATION, track.dim.topY, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
	end

	def playTrack(track, album)
		@song = Gosu::Song.new(album.tracks[track].location)
		@song.play(false)
	end

	def draw_background()
		# draw_rect()
		draw_quad(0,0, TOP_COLOR, 0, 720, TOP_COLOR, 780, 0, BOTTOM_COLOR, 400,800, BOTTOM_COLOR, z=ZOrder::BACKGROUND)
		# draw_quad(0,0, TOP_COLOR, 0, SCREEN_H, TOP_COLOR, SCREEN_W, 0, BOTTOM_COLOR, SCREEN_W, SCREEN_H, BOTTOM_COLOR, z = ZOrder::BACKGROUND)
	end

 	def needs_cursor?; true; end

	def draw
		draw_background()
		draw_album()
		draw_button()
		draw_track_current(@current_track)
	end

	def draw_button
		@bmp=Gosu::Image.new('image/play.png')
		@bmp.draw(40,300,z=ZOrder::UI)
		# @bmp=Gosu::Image.new('images/next-button-transparent.png')
		# @bmp.draw(90,500,z=ZOrder::UI)
		@bmp=Gosu::Image.new('image/pause.png')
		@bmp.draw(175,300,z=ZOrder::UI)
		# @bmp=Gosu::Image.new('images/stop-button-transparent.png')
		# @bmp.draw(190,500,z=ZOrder::UI)

	end

    # Checks which track the user selected.
	def button_down(id)
		case id
	    when Gosu::MsLeft 
	    	for i in 0..@album.tracks.length() - 1
		    	if area_clicked(@album.tracks[i].dim.leftX, @album.tracks[i].dim.topY, @album.tracks[i].dim.rightX, @album.tracks[i].dim.bottomY)
		    		playTrack(i, @album)
		    		@current_track = i
		    		break
		    	end
		    end
	    end
	end
	
end

# Show is a method that loops through update and draw
MusicPlayerMain.new.show if __FILE__ == $0

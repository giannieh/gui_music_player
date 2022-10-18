require 'rubygems'
require 'gosu'
require './input_functions'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp

	def initialize(file)
		@bmp = Gosu::Image.new(file)
	end
end

class Art
		attr_accessor :bmp
		def initialize(jpg)
			@bmp=Gosu::Image.new(jpg)
		end
end

class Track
		attr_accessor :track, :name, :location
		def initialize(track, name, location)
			@track = track
			@name = name
			@location = location
		end
end

class Album
		attr_accessor :track_id, :title, :artist, :art, :genre, :tracks
		def initialize(track_id, title, artist, art, genre, tracks)
			@track_id = track_id
			@title = title
			@artist = artist
			@art = art
			@genre = genre
		end
end

class Songs
		attr_accessor :songs
		def initialize(jpg)
			@songs = Gosu::Songs.new(jpg)
		end
end
# Put your record definitions here

class MusicPlayerMain < Gosu::Window

	def initialize
	    super 600, 800
	    self.caption = "Music Player"
		@location = [60,60]
		@font = Gosu::Font.new(30)
		@d = 0
		@f = 0
		# Reads in an array of albums from a file and then prints all the albums in the
		# array to the terminal
	end
	
	def road_album #road = load and read 
		def read_track(music_file, index)
			track_id = index
			track_name = music_file.gets
			track_location = music_file.gets.chomp
			track=Track.new(track_id, track_name, track_location)
			track
		end

		def read_tracks(music_file)
			count = music_file.gets.to_i
			tracks=Array.new
			index=0
			while index<count
				track =read_track(music_file, (index+1))
				tracks<<track
				index+=1
			end
			tracks
		end
		
		def read_album(music_file, index)
			album_id=index
			album_title = music_file.gets.chomp
			album_artist = music_file.gets
			album_art = music_file.gets.chomp
			album_genre = music_file.gets.to_i
			album_tracks = read_tracks(music_file)
			album = Album.new(album_id, album_title, album_artist, album_art, album_genre, album_tracks)
			return album
		end

		def read_albums(music_file)
			c = music_file.gets.to_i
			albums = Array.new
			i=0
			while i<c
				album = read_album(music_file, (i+1))
				albums << album
				i+=1
			end
			albums
		end

		music_file = File.new(file.txt, "r")
		albums = read_albums(music_file)
		albums
	end

  # Put in your code here to load albums and tracks

  # Draws the artwork on the screen for all the albums

	def draw_albums(albums)
    # complete this code
		@bmp=Gosu::Image.new(albums[0].art)
		@bmp.draw(50,50,z=ZOrder::PLAYER)
		@bmp=Gosu::Image.new(albums[1].art)
		@bmp.draw(50,100,z=ZOrder::PLAYER)
		@bmp=Gosu::Image.new(albums[2].art)
		@bmp.draw(100,50,z=ZOrder::PLAYER)
		@bmp=Gosu::Image.new(albums[3].art)
		@bmp.draw(100,100,z=ZOrder::PLAYER)
	end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false
	def area_clicked(mouse_x,mouse_y)
    # complete this code
	# 4 albums in total!!
		if ((mouse_x>50 && mouse_x<200) && (mouse_y>50 && mouse_y<200))
			@d = 1
			@f = 1
			playTrack(@d, @f)
		end
		if ((mouse_x>50 && mouse_x<210) && (mouse_y>310 && mouse_y<470))
			@d = 2
			@f = 1
			playTrack(@d, @f)
		end
		if ((mouse_x>310 && mouse_x<470) && (mouse_y>50 && mouse_y<210))
			@d = 3
			@f = 1
			playTrack(@d, @f)
		end
		if ((mouse_x>310 && mouse_x<470) && (mouse_y>310 && mouse_y<470))
			@d = 4
			@f = 1
			playTrack(@d, @f)
		end
		# player functions
		if ((mouse_x>250 && mouse_x<175) && (mouse_y>500 && mouse_y<625))
			@song.play
		end
		if ((mouse_x>50 && mouse_x<275) && (mouse_y>500 && mouse_y<625))
			@song.stop
		end
		if ((mouse_x>150 && mouse_x<375) && (mouse_y>500 && mouse_y<625))
			@song.pause
		end
		# going next
		if ((mouse_x>250 && mouse_x<475) && (mouse_y>500 && mouse_y<625))
			if @f==nil
				@f=1
			end 
			@f+=1
			playTrack(@d, @f)
		end
	end


  # Takes a String title and an Integer ypos
  # You may want to use the following:
	def display_track(title, ypos)
		@track_font.draw(title, TrackLeftX, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
	end


  # Takes a track index and an Album and plays the Track from the Album

	def playTrack(d, f)
		albums=road_album
		i=0
		while i<albums.length
			if albums[i].id==d
				tracks=albums[i].tracks
				l=0
				while l<tracks.length
					if tracks[l].track==d
						@song=Gosu::Song.new(tracks[l].location)
						@song.play(false)
					end
					l+=1
				end
			end
			i+=1
		end
  	 # complete the missing code
	end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
		draw_quad(0,0, TOP_COLOR, 0, 720, TOP_COLOR, 780, 0, BOTTOM_COLOR, 400,800, BOTTOM_COLOR, z=ZOrder::BACKGROUND)
	end

	def draw_text(d)
		albums=road_album
	end

# Not used? Everything depends on mouse actions.

	def update
		if(@song)
			if(!@song.playing?)
				@f=+1
			end
		end
	end

 # Draws the album images and the track list for the selected album

	def draw
		albums=road_album
		i=0
		x=480
		y=0
		# Complete the missing code
		draw_albums(albums)
		draw_background
		if !@song
			while i<albums.length
				@font.draw("#{albums[i].title}", x, y+=99, ZOrder::UI, 1.0,1.0, Gosu::Color::GREEN)
				i+=1
			end
		else
			while i<albums[@d-1].tracks.length
				@font.draw("#{albums[d-1].tracks[i].name}", x, y+=99, ZOrder::UI, 1.0, 1.0, Gosu::Color::GREEN)
				if (albums[@d-1].tracks[i].track_id == @f)
					@font.draw("test",x-20, y, ZOrder::UI, 1.0, 1.0, Gosu::Color::GREEN)
				end
			i+=1
			end
		end
	end

	def draw_button
		@bmp=Gosu::Image.new('images/Play-Button-Transparent.png')
		@bmp.draw(40,500,z=ZOrder::UI)
		@bmp=Gosu::Image.new('images/next-button-transparent.png')
		@bmp.draw(90,500,z=ZOrder::UI)
		@bmp=Gosu::Image.new('images/pause-button-transparent.png')
		@bmp.draw(140,500,z=ZOrder::UI)
		@bmp=Gosu::Image.new('images/stop-button-transparent.png')
		@bmp.draw(190,500,z=ZOrder::UI)

	end

 	def needs_cursor?; true; end

	def button_down(id)
		case id
	    	when Gosu::MsLeft
				@location = [mouse_x, mouse_y]
				area_clicked(mouse_x, mouse_y)
	    end
	end
end

# Show is a method that loops through update and draw

MusicPlayerMain.new.show if __FILE__ == $0

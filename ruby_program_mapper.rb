require 'graphviz'
#Graphviz is a gem that draws a diagram for you.
#Documentation: https://github.com/glejeune/Ruby-Graphviz/
#How to install: 
# -- $gem install ruby-graphviz
# -- You also need to download graphviz: http://www.graphviz.org/Download..php

class RubyProgramMapper

	def initialize

		@lines_in_the_file = []
		@methods_identified_so_far = []

		@diagram = GraphViz.new( :G, :type => :digraph )

		get_filename
		open_file(@file_to_be_read)
		get_out_the_words_to_use_in_the_flowchart
		identify_all_the_connections
		@diagram.output( :png => "program_map.png" )
		`open program_map.png`

	end

	def get_filename
		puts "What is the file name?"
		@file_to_be_read = gets.chomp
	end

	def open_file(filename)
		@file_to_be_read = File.new(filename, "r")
		read_file(filename)
		@file_to_be_read.close
	end

	def read_file(filename)
		while (line = @file_to_be_read.gets)
		  @lines_in_the_file << line
		end
	end

	def get_out_the_words_to_use_in_the_flowchart
		@lines_in_the_file.each do |command|
			identify_all_the_methods(command)
		end
	end

	def identify_all_the_methods(line)
		if line.strip.start_with?("def")
			this_method = line.strip.split(/,|\(|\s/)[1]
			@methods_identified_so_far << this_method
			draw_this_method_in_diagram(this_method)
		end
	end

	def draw_this_method_in_diagram(method)
		new_node = @diagram.add_nodes(method)
	end

	def set_current_method(line)
		if line.strip.start_with?("def")
			@current_method = line.strip.split(/,|\(|\s/)[1]
		end
	end

	def identify_all_the_connections
		@lines_in_the_file.each do |command|
			set_current_method(command)
			are_we_inside_the_method?(command)
		end
	end

	def are_we_inside_the_method?(line)
		if !(line.strip.start_with?("def"))
				check_for_methods_inside_methods(line)
		end
	end

	def check_for_methods_inside_methods(line)
		line.strip.split(/,|\(|\s/).each do |word|
			if @methods_identified_so_far.include?(word)
				draw_connections(word)
			end
		end
	end

	def draw_connections(method_name)
		@diagram.add_edges(@current_method, method_name)
	end

end

r = RubyProgramMapper.new

require 'graphviz'
#Graphviz is a gem that draws a diagram for you.
#Full documentation: https://github.com/glejeune/Ruby-Graphviz/
#How to install: 
# -- $sudo gem install graphviz
# -- You also need to dowload graphviz: http://www.graphviz.org/Download..php

@file_to_be_read
@lines_in_the_file = Array.new
@methods_identified_so_far = Array.new
@current_method

@diagram = GraphViz.new( :G, :type => :digraph )

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
	if line.start_with?("def")
		this_method = line.strip.split(/,|\(|\s/).map(&:strip).reject(&:empty?)[1]

#The internet gave me the above line of code to delimit the lines by " " and "," and "(",
#but there has GOT to be a way to do this that isn't this...ugly. And hard to read. 

		@methods_identified_so_far << this_method
		draw_this_method_in_diagram(this_method)
	end
end

def draw_this_method_in_diagram(method)
	new_node = @diagram.add_nodes(method)
end

def set_current_method(line)
	if line.start_with?("def")
		@current_method = line.strip.split(/,|\(|\s/).map(&:strip).reject(&:empty?)[1]

#It's not any LESS ugly right here. 

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
	line.strip.split(/,|\(|\s/).map(&:strip).reject(&:empty?).each do |word|

#still ugly

		if @methods_identified_so_far.include?(word)
			draw_connections(word)
		end
	end
end

def draw_connections(method_name)
	@diagram.add_edges( @current_method, method_name )
end

def main
	get_filename
	open_file(@file_to_be_read)
	get_out_the_words_to_use_in_the_flowchart
	identify_all_the_connections
	#@file_to_be_read.to_s + 
	@diagram.output( :png => "program_map.png" )
end

main

#The picture of your diagram does not open automatically.
#Instead, it was saved to the same folder that this program is in.
#You can go find it in there and open it like any other picture file. 
#Yes, this is annoying. I'm trying to figure out how to make the image open automatically
#after the program runs. 


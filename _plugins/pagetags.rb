module Jekyll
  class Page
	def tags
	  (self.data['tags']).map {|t| Tag.new(t)}
	end
  end
  
  TAG_NAME_MAP = {
	"#"  => "sharp",
	"/"  => "slash",
	"\\" => "backslash",
	"."  => "dot",
	"+"  => "plus",
	" "  => "-" }

  # Holds tag information 
  class Tag

	attr_accessor :dir, :name

	def initialize(name)
	  @name = name.downcase.strip
	  @dir = name_to_dir(@name)
	end

	def to_s
	  @name
	end

	def eql?(tag)
	  self.class.equal?(tag.class) && (name == tag.name)
	end

	def hash
	  name.hash
	end

	def <=>(o)
	  self.class == o.class ? (self.name <=> o.name) : nil
	end

	def inspect
	  self.class.name + "[" + @name + ", " + @dir + "]"
	end

	def to_liquid
	  # Liquid wants a hash, not an object.

	  { "name" => @name, "dir" => @dir }
	end

	# Sort a list of tags by name.
	def self.sort(tags)
	  tags.sort { |t1, t2| t1 <=> t2 }
	end

	private

	# Map a tag to its directory name. Certain characters are escaped,
	# using the TAG_NAME_MAP constant, above.
	def name_to_dir(name)
	  s = ""
	  name.each_char do |c|
		if (c =~ /[-A-Za-z0-9_]/) != nil
		  s += c
		else
		  c2 = TAG_NAME_MAP[c]
		  if not c2
			msg = "Bad character '#{c}' in tag '#{name}'"
			puts("*** #{msg}")
			raise FatalException.new(msg)
		  end
		  s += c2
		end
	  end
	  s
	end
  end
end
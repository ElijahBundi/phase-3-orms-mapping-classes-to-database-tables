class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

# def initialize(attributes)
#   attributes.each do |key, value|
#     self.class.attr_accessor[key]
#     self.send("#{key}=", value)
#   end
# end

# table is created directly from the class
  def self.create_table
    sql = <<-SQL 
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

# instantiating, saving a song to the class_table
  def save
    sql = <<-SQL
      INSERT INTO 
        songs (name, album)
      VALUES 
        (?, ?)   
    SQL

# formula for inserting the song
    DB[:conn].execute(sql, self.name, self.album)

# getting the song id from the DB and saving it to the ruby instance
    self.id = DB[:conn].execute('SELECT last_insert_rowid() FROM songs')[0][0]

# returning the ruby instance
    self
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end

end


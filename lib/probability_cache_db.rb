require 'sqlite3'

module Dice_Stats
	class DB_cache_connection
		@@Version = [0, 0, 3]
		@@Path = '/srv/Dice_Stats/'
		@@DB_name = 'probability_cache.db'

		def initialize
			checkSchema
		end

		def checkSchema
			begin
				db = SQLite3::Database.open(@@Path + @@DB_name)
				db.execute "CREATE TABLE IF NOT EXISTS DiceConfig(Key TEXT PRIMARY KEY, Val TEXT);"
				statement = db.prepare "SELECT Val FROM DiceConfig WHERE Key = 'Version';"
				row = statement.execute.next

				if !row
					db.execute "INSERT INTO DiceConfig (Key, Val) VALUES ('Version', '#{@@Version.join('.')}');"
					createSchema(db, true)
				else
					version = row[0]
					version = version.split('.')
					version.map! { |i| i.to_i }
					if (@@Version[0] != version[0] || @@Version[1] != version[1] || @@Version[2] != version[2])
						# Version of database is different, drop and recreate!
						createSchema(db, true)
						db.execute "UPDATE DiceConfig SET Version = '#{@@Version.join('.')}' WHERE Key = 'Version'"
					end

				end
			rescue SQLite3::Exception => e 
				puts e
			ensure
				statement.close if statement
				db.close if db
			end

		end

		def createSchema(db, drop=false)
			db.execute "DROP TABLE IF EXISTS DiceSet;" if drop
			db.execute "CREATE TABLE IF NOT EXISTS DiceSet (Id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT UNIQUE)"

			db.execute "DROP TABLE IF EXISTS RollProbability;" if drop
			db.execute "CREATE TABLE IF NOT EXISTS RollProbability (Id INTEGER PRIMARY KEY AUTOINCREMENT, DiceSetId INT, Value INTEGER, Probability DECIMAL)"
		end

		def purge
			begin
				db = SQLite3::Database.open(@@Path + @@DB_name)
				puts "Purging cache..."
				createSchema(db, true)
			rescue SQLite3::Exception => e 
				puts e
			ensure
				db.close if db
			end
		end

		def checkDice(dice_pattern)
			begin
				db = SQLite3::Database.open(@@Path + @@DB_name)
				
				statement = db.prepare "SELECT Id FROM DiceSet WHERE Name = '#{dice_pattern}'"

				return statement.execute.count >= 1

			rescue SQLite3::Exception => e 
				puts e
			ensure
				statement.close if statement
				db.close if db
			end
		end

		def addDice(dice_pattern, probability_distribution)
			begin
				db = SQLite3::Database.open(@@Path + @@DB_name)				
				db.execute "INSERT INTO DiceSet (Name) VALUES ('#{dice_pattern}')"
				diceset_id = db.last_insert_row_id
				
				values = []
				probability_distribution.each { |k,v|  
					values << "(#{diceset_id}, #{k}, #{v})"
				}		
				insert = "INSERT INO RollProbability (DiceSetId, Value, Probability) VALUES " + values.join(", ")

				db.execute insert		

			rescue SQLite3::Exception => e 
				puts e
			ensure
				db.close if db
			end
		end

		def getDice(dice_pattern)
			begin
				db = SQLite3::Database.open(@@Path + @@DB_name)
				
				statement = db.prepare "SELECT Id FROM DiceSet WHERE Name = '#{dice_pattern}'"
				diceset_id = statement.execute.first[0]

				statement2 = db.prepare "SELECT Value, Probability FROM RollProbability WHERE DiceSetId = #{diceset_id}"

				rs = statement2.execute
				result = {}
				rs.each { |row|
					result[row[0]] = row[1]
				}

				return result

			rescue SQLite3::Exception => e 
				puts e
			ensure
				statement.close if statement
				db.close if db
			end
		end

	end

	Cache = DB_cache_connection.new
end
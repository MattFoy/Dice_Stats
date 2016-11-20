require 'sqlite3'
require 'bigdecimal'

module Dice_Stats

end

module Dice_Stats::Internal_Utilities

	##
	# This class represents the cache. The cache is used for storing previously calculated results.
	# Some dice sets can take quite a while to calculate. 
	# Storing them drastically increases performance when a cache hit is found.
	class DB_cache_connection
		##
		# The version of the gem. If this is updated, the DB_cache_connection#initialize method will drop and recreate the tables
		@@Version = [0, 1, 0]

		##
		# The path of the sqlite3 db file.
		@@Path = '/srv/Dice_Stats/'

		##
		# The name of the sqlite3 db file.
		@@DB_name = 'probability_cache.db'

		##
		# For internal use only. Checks the database version and schema on startup.
		def initialize
			checkSchema
		end

		##
		# Checks the database version and schema and creates the table structures.
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

		##
		# Creates the tables if they don't already exist.
		# If +drop+ is set to true, the tables will be dropped first.
		def createSchema(db, drop=false)
			db.execute "DROP TABLE IF EXISTS DiceSet;" if drop
			db.execute "CREATE TABLE IF NOT EXISTS DiceSet (Id INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT UNIQUE, TimeElapsed DECIMAL)"

			db.execute "DROP TABLE IF EXISTS RollProbability;" if drop
			db.execute "CREATE TABLE IF NOT EXISTS RollProbability (Id INTEGER PRIMARY KEY AUTOINCREMENT, DiceSetId INT, Value INTEGER, Probability DECIMAL)"
		end

		##
		# Drops and recreates the schema for the purpose of clearing the cache.
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

		##
		# Checks the cache to see if the pattern has been previously calculated.
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

		##
		# Caches a dice pattern for future retrieval.
		def addDice(dice_pattern, probability_distribution, timeElapsed=0.0)
			begin
				db = SQLite3::Database.open(@@Path + @@DB_name)				
				db.execute "INSERT INTO DiceSet (Name) VALUES ('#{dice_pattern}')"
				diceset_id = db.last_insert_row_id
				
				values = []
				probability_distribution.each { |k,v|  
					values << "(#{diceset_id}, #{k}, #{v})"
				}
				#puts "Values:"
				#puts values

				insert = "INSERT INTO RollProbability (DiceSetId, Value, Probability) VALUES " + values.join(", ")

				db.execute insert
			rescue SQLite3::Exception => e 
				puts e
			ensure
				db.close if db
			end
		end

		##
		# Retrieves the probability distribution for a dice pattern from the cache.
		def getDice(dice_pattern)
			begin
				db = SQLite3::Database.open(@@Path + @@DB_name)
				
				statement1 = db.prepare "SELECT Id FROM DiceSet WHERE Name = '#{dice_pattern}'"
				diceset_id = statement1.execute.first[0]

				statement2 = db.prepare "SELECT Value, Probability FROM RollProbability WHERE DiceSetId = #{diceset_id}"

				rs = statement2.execute
				result = {}
				rs.each { |row|
					result[row[0]] = BigDecimal.new(row[1], 15)
				}

				return result

			rescue SQLite3::Exception => e 
				puts e
			ensure
				statement1.close if statement1
				statement2.close if statement2
				db.close if db
			end
		end

		##
		# Retrieves how long a cached result originally took to calculate.
		def getElapsed(dice_pattern)
			begin
				db = SQLite3::Database.open(@@Path + @@DB_name)
				statement = db.prepare "SELECT TimeElapsed FROM DiceSet WHERE Name = '#{dice_pattern}'"

				rs = statement.execute				
				result = nil
				rs.each { |row| 
					result = row[0]
				}

				if (result == nil)
					return 0.0
				else 
					return result
				end

			rescue SQLite3::Exception => e 
				puts e
			ensure
				statement.close if statement
				db.close if db
			end
		end
	end	
end
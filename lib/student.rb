

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  class Student
  attr_accessor :name, :grade #     the name attribute can be accessed /     the grade attribute can be accessed
  attr_reader :id # responds to a getter for :id  /  does not provide a setter for :id (not access to write/change)

  def initialize(name, grade, id=nil)  #  initialized with a name and a grade
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table #   creates the students table in the database
    sql =  <<-SQL   #creates the students table in the database / all the text between <<-SQL .... SQL is all written in SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
        )
    SQL
    DB[:conn].execute(sql) # DB[:conn] will then connect us to the database and .execute(sql) will execute the text above set to = sql
  end

  def self.drop_table # drops the students table from the database
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save # saves an instance of the Student class to the database
    sql = <<-SQL # setting the sql code
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade) # enter the database and execute the sql code
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0] # set id / and self.name and self.grade are put into their corresponding index 0
  end

  def self.create(name:, grade:) # uses metaprogramming via setting the arguements as ids (keywordss) / takes in a hash of attributes and uses metaprogramming to create a new student object.
    student = Student.new(name, grade)
    student.save # Then it uses the #save method to save that student to the database
    student #  returns the new object that it instantiated
  end
end

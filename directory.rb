require 'csv'
@students = []

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list from students.csv"
  puts "9. Exit"
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def process(selection)
  input_students if selection == "1"
  show_students if selection == "2"
  exit if selection == "9"
  option_three if selection == "3"
  option_four if selection == "4"
  try_again if !["1", "2", "3", "4", "9"].include?(selection)
end

def option_three
  puts "Type file name:"
  filename = STDIN.gets.chomp
  save_students(filename)
end

def option_four
  puts "Type file name:"
  filename = STDIN.gets.chomp
  load_students(filename)
end

def try_again
    puts "I don't know what you meant, try again"
end

def input_students
  #puts "To finish, just hit return twice"
  puts "Name: "
  name = STDIN.gets.chomp
  while !name.empty? do
    puts "Nationality: "
    nationality = STDIN.gets.chomp
    puts "Cohort: "
    cohort = STDIN.gets.chomp
    adding_students(name, nationality, cohort)
    puts "Now we have #{@students.count} students"
    puts "To finish, just hit return"
    puts "Name: "
    name = STDIN.gets.chomp
  end
end

def adding_students(name, nationality, cohort)
  @students << {name: name, nationality: nationality, cohort: cohort.to_sym}
end

def show_students
  print_header
  print_student_list
  print_footer
end

def print_header
  puts "The students of Villains Academy".center(70, "-")
  puts "--------------------------------".center(70, " ")
end

def print_student_list
  @students.each do |student|
    puts "#{student[:name]} --- #{student[:nationality]} (#{student[:cohort]} cohort)"
  end
end

def print_footer
  puts "Overall, we have #{@students.count} great student" if @students.count == 1
  puts "Overall, we have #{@students.count} great students" if @students.count > 1
end

def save_students(filename)
  CSV.open(filename, "w") do |file|
    @students.each do |student|
      file << [student[:name], student[:nationality], student[:cohort]]
    end
  end
  puts "Saved!"
end

def load_students(filename)
  CSV.foreach(filename, "r") do |row|
    adding_students(row[0], row[1], row[2])
  end
  puts "Loaded!"
end

def try_load_students
  filename = ARGV.first # first argument from the command line
  return if filename.nil? # get out of the method if it isn't given
  if File.exists?(filename) # if it exists
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}"
  else # if it doesn't exist
    puts "Sorry, #{filename} doesn't exist."
    exit # quit the program
  end
end

try_load_students
interactive_menu

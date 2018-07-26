require_relative 'lib/question.rb'

puts "Добро пожаловать в Веселую Викторину!\n\n"
sleep 1

questions = Question.load_from_xml("data/quiz.xml")

result = 0

questions.each do |question|
  question.ask_question
  result += question.check_answer
end

puts "Тест завершен.
Ваш результат: #{result} правильных ответов!"

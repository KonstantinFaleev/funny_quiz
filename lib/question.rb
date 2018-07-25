require 'rexml/document'
require 'date'

class Question
  attr_accessor :id, :question, :answers

  def self.load_from_xml(file_path)
    questions = []

    file = File.new(file_path)
    doc = REXML::Document.new(file)
    file.close

    num = 0

    doc.root.each_element do |question|
      text = question.elements['text'].text
      answers = []
      right_answer = false

      question.elements.each("variants") do |variant|
        answers << variant.text
        right_answer = variant.text if variant.attributes["right"]
      end

      questions << Question.new(num, text, answers, right_answer)
      num += 1
    end

    questions
  end

  def initialize(id, text, answers, right_answer)
    @id = id
    @question = text
    @answers = answers
    @right_answer = right_answer
    @time = 5
    @start_time = nil
    @status = :unanswered
    @user_answer = nil
  end

  def ask_question
   puts @question
   puts "Варианты ответов\n"

   @answers.each_with_index do |answer, index|
     puts "#{index + 1}. #{answer}"
   end

   @start_time = Time.now

   get_user_input
  end

  def get_user_input
    user_answer = -1

    until %w(0 1 2 3).include?(user_answer.to_s) do
      return 0 if timeout?
      puts "Выбирите ответ из предложенных:"
      user_answer = STDIN.gets.to_i
    end
    @user_answer = @answers[user_answer - 1]
    @status = :answered
  end

  def timeout?
    Time.now == (@start_time + 5*60)
  end

  def check_answer
    if @status == :answered && !timeout? && answer_correct?
      puts "Верно!"
      1
    else
      puts "Правильный ответ: #{@right_answer}"
      0
    end
  end

  def answer_correct?
    @user_answer == @right_answer
  end
end

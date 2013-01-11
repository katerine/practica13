#encoding: UTF-8
require 'ull:etsii:alu4321::quiz'
include Ull::Etsii::Alu4321::Quiz

quiz = Quiz.new("preguntas al asar") {
    question "en que aC1o cristobal colon descubrio america?",
        e.right => "1492",
        e.wrong => "1942",
        e.wrong => "1808",
        e.wrong => "1914"

     a=rand(10)
     b=rand(10)
    question "#{a}+B7{b}=?",
        e.wrong => "44",
        e.wrong => "#{a+b+2}",
        e.right => "#{a+b}",
        e.wrong => "#{a+b-2}"
}

quiz.run

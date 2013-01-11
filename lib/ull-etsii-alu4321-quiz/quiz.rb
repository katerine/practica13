#encoding: UTF-8
require "ULL-ETSII-Alu4321-Quiz/version"
require 'colorize'
require 'erb'

module ULL
  module ETSII
    module Alu4321
      module Quiz

        WRONG = false
        RIGHT = true

        # Clase que permite la construcciC3n de cuestionarios tipo test mediante un DSL
        class Quiz
            attr_accessor :name, :questions

            # Recibe el nombre del test y un bloque con las preguntas y sus respuestas
            #
            # Ejemplo de uso:
            # quiz = Quiz.new("Test 1"){
            # question "Pregunta 1",
            # wrong => "Respuesta incorrecta 1",
            # wrong => "Respuesta incorrecta 2",
            # wrong => "Respuesta incorrecta 3",
            # right => "Respuesta correcta"
            # }
            def initialize(name, &block)
                @counter = 0
                @aciertos = 0
                @name = name
                @questions = []

                instance_eval &block
            end

            # Pregunta incorrecta
            #
            # Avoid collisions
            def wrong
                @counter += 1
                [@counter, WRONG]
            end

            # Pregunta correcta
            def right
                :right
            end

            # MC)todo que recibe el tC-tulo <em>title</em> de la pregunta y una serie de
            # parC!metros como respuestas
            def question(title, anss)
                answers = []

                anss.each do |ans|
                    a = Answer.new(ans)
                    answers << a
                end

                q = Question.new(title, answers)
                questions << q
            end

            # Ejecuta el test por consola. Presenta cada pregunta y las posibles respuestas.
            # Al final muestra los resultados.
            def run
                aciertos = 0
                puts name
                questions.each do |q|
                    puts q
                    print "Su respuesta: "
                    resp = gets.chomp.to_i
                    raise IndexError, "Answer must be between 1 and #{q.answers.size}." unless resp <= q.answers.size and resp > 0
                    if q.answers[resp-1].state
                        puts "Correcto!".colorize(:light_green)
                        @aciertos += 1
                    else
                        correcta = q.answers.select { |ans| ans.state }.first
                        puts "Fallo, la respuesta correcta era #{correcta}".colorize(:red)
                    end
                    puts
                end
                puts "Has acertado el #{(@aciertos/questions.size.to_f)*100}% de las preguntas [#{@aciertos} de #{questions.size}]."
            end

            # RepresentaciC3n visual de un Test en forma de String.
            def to_s
                out = name + "\n"
                questions.each do |q|
                    out << "#{q}\n"
                end
                out
            end

            # Genera el test en formato html.
            # Dicho test es totalmente funcional, permitiendo la selecciC3n de respuestas y
            # la correcciC3n de las mismas
            def to_html
                # SetUp del fichero de salida
                if not Dir.exist? "html"
                    # Copiamos el directorio html con los ficheros bC!sicos
                    require 'fileutils'
                    FileUtils.cp_r File.expand_path(File.dirname(__FILE__)) + '/html', 'html'
                end
                # Generamos HTML
                htmlFile = File.new("html/#{name.gsub(/[\ \\\/:]/, '_')}.html", "w")
                raise IOError, 'Can\'t access to html output file' unless htmlFile
                # Generamos JavaScript
                jsFile = File.new("html/js/quiz.js", "w")
                raise IOError, 'Can\'t access to javascript output file' unless jsFile
                
                # Construimos los ERB y los escribimos en los ficheros
                require 'templates'
                rhtml = ERB.new(HTML_TEMPLATE)
                htmlFile.syswrite(rhtml.result(binding))
                htmlFile.close
                
                rjs = ERB.new(JAVASCRIPT_TEMPLATE)
                jsFile.syswrite(rjs.result(binding))
                jsFile.close
                
                
            end

        end

        # Clase que representa una de pregunta a un test.
        class Question
            attr_accessor :answers, :title
            # Recibe un tC-tulo <em>title</em> de la pregunta y el resto de parC!metros son las
            # posibles respuestas.
            def initialize(title, anss)
                raise ArgumentError, "Title has to be a String, got #{title.class}" unless title.is_a? String
                @title = title
                @answers = anss
            end

            # RepresentaciC3n visual de una pregunta en forma de String.
            def to_s
                out = "# #{@title}".colorize(:light_blue) + "\n"
                i = 1
                answers.each do |a|
                    out << " [#{i}] #{a}\n"
                    i += 1
                end
                out
            end
        end

        # Clase que representa las respuestas a preguntas de un test.
        class Answer
            attr_reader :state, :value

            # Recibe como parC!metro una lista de dos elementos que contiene
            # el <em>state</em> o estado de la respuesta (si es verdadera o falsa)
            # y el <em>value</em> con el texto que la representa.
            def initialize(ans)
                raise ArgumentError, "Array spected, got #{ans.class}" unless ans.is_a? Array
                raise IndexError, 'Must have two (2) elements; state and value' unless ans.size == 2
                state = ans[0]
                value = ans[1]
                state == :right ? @state = RIGHT : @state = WRONG
                @value = value
            end

            # Devuelve <em>value</em>, es decir, el texto que describe a la respuesta
            def to_s
                "#{@value}"
            end
        end
        
      end
    end
  end


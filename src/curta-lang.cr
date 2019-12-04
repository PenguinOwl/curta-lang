require "./parser"

module CurtaLang
  VERSION = "0.1.0"

  parser = Parser.new

  if file = ARGV[0]?
    parser.file(File.read(file))
  else
    parser.repl
  end

end

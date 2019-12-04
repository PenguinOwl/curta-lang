require "./lang"
require "colorize"

macro handle(&block)
  begin
    {{block.body}}
  rescue ex
    if message = ex.message
      puts "Error: ".colorize.red.bold.to_s + message.colorize.default.to_s
    end
  end
end

def line_eval(runtime, line)
  temp = line.dup
  while /\([^\(\)]+\)/.match temp
    temp = temp.gsub(/\(([^\(\)]+)\)/) { |e| runtime.eval(e[1..-2]) }
  end
  return runtime.eval temp
end

def repl
  runtime = Runtime.new
  print "curta-repl> ".colorize.green
  while item = STDIN.gets
    if item == "q"
      break
    end
    handle do
      puts "  => " + line_eval(runtime, item)
    end
    print "curta-repl> ".colorize.green
  end
end

repl

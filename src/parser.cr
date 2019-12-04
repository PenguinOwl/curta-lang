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

class Parser
  def handle_with_line(line)
    begin
      yield
    rescue ex
      if message = ex.message
        puts "Error on line #{line}: ".colorize.red.bold.to_s + message.colorize.default.to_s
      end
      exit 1
    end
  end

  def line_eval(runtime, line)
    temp = line.dup.strip
    begin
      while /\([^\(\)]+\)/.match temp
        temp = temp.gsub(/\(([^\(\)]+)\)/) { |e| runtime.eval(e[1..-2]) }
      end
      return runtime.eval temp
    rescue ex
      puts ("Exception caught from evaluating \"" + temp + "\":").colorize.yellow
      raise ex
    end
    return ""
  end

  def file(content)
    text(content.split("\n"))
  end

  def text(lines : Array(String))
    runtime = Runtime.new
    pointer = 0
    while item = lines[pointer]?
      item = item.strip
      if item == "q"
        break
      end
      pointer += 1
      if item == "" || item[0] == '#'
        next
      end
      handle_with_line(pointer) do
        result = line_eval(runtime, item)
        if result[0]? == '$'
          case result.split(" ")[0][1..-1]?
          when "goto"
            pointer = result.split(" ")[1].to_i - 1
          when "skip"
            pointer += 1
          end
        end
      end
    end
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
end

require "./lang"

runtime = Runtime.new

while item = STDIN.gets
  if item == "q"
    break
  end
  puts "  => " + runtime.eval(item)
end

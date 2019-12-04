require "./vm"

OFFSET = -1

macro syntax_error(error)
  raise Exception.new("Improper syntax: " + {{error.id.stringify}})
end

class Runtime
  property vm : Curta
  property store : Hash(String, Int32)

  def initialize
    @vm = Curta.new
    @store = {} of String => Int32
  end

  def eval(content)
    command = content.to_s.split(" ")
    case command[0]?
    when "set"
      case command[1]?
      when "reg"
        if command[2]? == "to"
          @vm.register.values = command[3].rjust(@vm.register.length, '0').reverse.split("").map { |e| e.to_i }
        elsif command[3]? == "to"
          @vm.register[command[2].to_i + OFFSET] = command[4].to_i
        else
          syntax_error "missing \"to\" directive"
        end
      when "lever"
        if command[2]? == "to"
          case command[3]
          when "forword"
            @vm.polarity = true
          when "reverse"
            @vm.polarity = false
          else
            syntax_error "not a valid polarity"
          end
        else
          syntax_error "missing \"to\" directive"
        end
      when "crank"
        if command[2]? == "to"
          case command[3]
          when "up"
            @vm.crank_up = true
          when "down"
            @vm.crank_up = false
          else
            syntax_error "invalid position"
          end
        else
          syntax_error "missing \"to\" directive"
        end
      when "dial"
        if command[2]? == "to"
          @vm.register.offset = command[3].to_i + OFFSET
        else
          syntax_error "missing \"to\" directive"
        end
      else
        if command[2]? == "to"
          @store[command[1]] = command[3].to_i
        else
          syntax_error "not a valid memory location"
        end
      end
    when "get"
      case command[1]?
      when "reg"
        return @vm.register[command[2].to_i + OFFSET].to_s
      when "res"
        return @vm.result_wheel[command[2].to_i + OFFSET].to_s
      when "rev"
        return @vm.revolution_wheel[command[2].to_i + OFFSET].to_s
      when "dial"
        return @vm.register.offset.-(OFFSET).to_s
      else
        if index = command[1]?
          if result = @store[index]?
            return result.to_s
          else
            syntax_error "not a valid memory location"
          end
        else
          syntax_error "not a valid memory location"
        end
      end
    when "read"
      case command[1]?
      when "reg"
        return @vm.register.to_s
      when "res"
        return @vm.result_wheel.to_s
      when "rev"
        return @vm.revolution_wheel.to_s
      else
        syntax_error "not a valid memory structure"
      end
    when "clear"
      case command[1]?
      when "reg"
        @vm.register.clear
      when "res"
        @vm.result_wheel.clear
      when "rev"
        @vm.revolution_wheel.clear
      when "all"
        @vm.register.clear
        @vm.result_wheel.clear
        @vm.revolution_wheel.clear
      else
        syntax_error "not a valid storage"
      end
    when "turn"
      if command[1]?
        @vm.turn(command[1].to_i)
      else
        @vm.turn
      end
    when "skip"
      unless command[1].to_i == 0
        return "$skip"
      end
    when "goto"
      return "$goto #{command[1]}"
    when "in"
      if input = gets
        return input.strip
      end
    when "out"
      puts command[1..-1].join(" ")
    else
      syntax_error "no such directive"
    end
    return ""
  end
end

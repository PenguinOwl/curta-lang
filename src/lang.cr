require "./vm"

OFFSET = -1

macro syntax_error
  raise Exception.new("Improper syntax")
end

class Runtime
  
  property vm : Curta

  def initialize
    @vm = Curta.new
  end

  def eval(content)
    command = content.split(" ")
    case command[0]?
    when "set"
      case command[1]?
      when "reg"
        if command[3]? == "to"
          @vm.register[command[2].to_i+OFFSET] = command[4].to_i
        else
          syntax_error
        end
      when "lever"
        if command[2]? == "to"
          case command[3]
          when "forword"
            @vm.polarity = true
          when "reverse"
            @vm.polarity = false
          else
            syntax_error
          end
        else
          syntax_error
        end
      when "crank"
        if command[2]? == "to"
          case command[3]
          when "up"
            @vm.crank_up = true
          when "down"
            @vm.crank_up = false
          else
            syntax_error
          end
        else
          syntax_error
        end
      else
        syntax_error
      end
    when "get"
      case command[1]?
      when "reg"
        return @vm.register[command[2].to_i+OFFSET].to_s
      when "res"
        return @vm.result_wheel[command[2].to_i+OFFSET].to_s
      when "rev"
        return @vm.revolution_wheel[command[2].to_i+OFFSET].to_s
      else
        syntax_error
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
        syntax_error
      end
    when "clear"
      case command[1]?
      when "reg"
        @vm.register.clear
      when "res"
        @vm.result_wheel.clear
      when "rev"
        @vm.revolution_wheel.clear
      else
        syntax_error
      end
    when "turn"
      @vm.turn
    when "skip"
      unless command[1] == 0
        return "$skip"
      end
    when "goto"
      return "$goto #{command[1]}"
    else
      syntax_error
    end
    return ""
  end

end

class Curta

  class Readout

    getter writeable : Bool 
    getter length : Int32   
    getter value : Int128  

    def initialize(length, writeable = true)
      @writeable = writeable
      @length = length
      @value = 0
    end

    def [](index)
      @value.to_s.rjust(@length, '0').reverse[index].to_i
    end

    def value=(target)
      if writeable
        @value = target
      else
        raise Exception.new("Readout not writeable")
      end
      resolve
    end

    def clear
      @value = 0
    end

    def to_i
      return @value
    end

    def to_s
      return @value.to_s
    end

    def +(arg)
      temp = self.dup
      temp.value += arg
      temp.resolve
      return temp
    end

    def -(arg)
      return +(-1 * arg)
    end

    def resolve
      max = Int128.new(10) &** length
      while @value < 0
        @value += max 
      end
      @value %= max
      return @value
    end

  end

  class Register

    property offset : Int32 
    getter length : Int32   
    getter values : Array(Int32) 

    def initialize(length)
      @length = length
      @offset = 0
      @values = Array(Int32).new(length, 0)
    end

    def value
      return to_i
    end

    def [](index : Int32)
      return @values[index]
    end

    def []=(index : Int32, target : Int32)
      if values[index]?
        if (0..9).includes? target
          @values[index] = target
        end
      else
        raise Exception.new("Register key out of bounds")
      end
    end

    def clear
      @values = Array(Int32).new(length, 0)
    end

    def to_i
      return to_s.to_i
    end

    def to_s
      return @values.reverse.join("") + "0" * offset
    end

  end

  getter result_wheel : Readout
  getter revolution_wheel : Readout
  getter register : Register
  property crank_up
  property polarity

  def initialize
    @result_wheel = Readout.new(11)
    @revolution_wheel = Readout.new(6)
    @register = Register.new(8)
    @crank_up = false
    @polarity = true
  end

  def turn
    @result_wheel.value += @register.to_i * (@crank_up ? -1 : 1)
    @revolution_wheel.value += (@crank_up ? -1 : 1) * (@polarity ? 1 : -1)
  end

end

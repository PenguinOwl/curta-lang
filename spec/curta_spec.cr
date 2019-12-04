require "./spec_helper"

describe Curta::Readout do
  readout : Curta::Readout = Curta::Readout.new(4)
  describe "#value" do
    it "can be read" do
      readout.value.should eq 0
    end
    it "can be set" do
      readout.value = 3
      readout.value.should eq 3
    end
  end
  describe "#[]" do
    it "can read an index" do
      readout[0].should eq 3
    end
  end
  describe "#resolve" do
    it "can handle overflow" do
      readout.value = 10001
      readout.resolve.should eq 1
    end
    it "can handle underflow" do
      readout.value = -1
      readout.resolve.should eq 9999
    end
    it "can correct itself using resolve" do
      readout.value = -1
      readout.resolve
      readout.value.should eq 9999
    end
    it "can handle overflow during assignment" do
      readout.value = 10001
      readout.value.should eq 1
    end
    it "can handle underflow during assignment" do
      readout.value = -1
      readout.value.should eq 9999
    end
  end
  describe "#+" do
    it "can be added to" do
      readout.value = 0
      readout.value += 2
      readout.value.should eq 2
    end
    it "can be subtracted from" do
      readout.value = 0
      (readout + 3).value.should eq 3
    end
  end
end

describe Curta::Register do
  register : Curta::Register = Curta::Register.new(4)
  describe "#set" do
    it "can set the values in a register" do
      register = Curta::Register.new(4)
      register[1] = 3
      register[1].should eq 3
    end
    it "can clear values" do
      register = Curta::Register.new(4)
      register[1] = 1
      register.clear
      register[1].should eq 0
    end
    it "can resolve to a number with an offset" do
      register = Curta::Register.new(4)
      register[0] = 1
      register.offset = 1
      register.to_i.should eq 10
      register.offset = 0
    end
  end
end

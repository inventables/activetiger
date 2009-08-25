require File.join(File.dirname(__FILE__),'..','lib','activetiger')

def with_constants(constants, &block)
  constants.each do |constant, val|
    Object.const_set(constant, val)
  end

  block.call

  constants.each do |constant, val|
    Object.send(:remove_const, constant)
  end
end


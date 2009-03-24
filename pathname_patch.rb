require 'rubygems'
require 'pathname'

module Kernel
  def Pathname(args)
    Pathname.new(args)
  end
end
module Idrop
  module Transcoders
    ##
    # Base class for a movie transcoder that has external dependencies
    class Base
      attr_accessor :log
      def initialize
        if @deps
          missing = []
          @deps.each do |program|
            if `hash #{program} 2>&1`.include?("not found")
              missing << "#{program}"
            end
          end
          if missing.size > 0
            puts "The following dependencies were unmet transcoder #{self.class.to_s}:\n"
            missing.each do |program|
              puts " * #{program}"
            end
            exit -1
          end
        end
      end
    end
  end
end
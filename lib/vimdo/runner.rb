require "thor/runner"

module VimDo
  module Thor
    class Runner < ::Thor::Runner

      # Note: because of the way task.run works, there has to be a local
      # definition. Also, we want tasks to work WITH our base namespace
      # if it is included, so that we can use our binary with the same
      # signature we would use thor
      def method_missing(meth, *args)
        meth = meth.to_s
        meth.sub!(/^vimdo:/, '')
        super meth, *args
      end

      private
      def thorfiles(*args)
        Dir[
          File.join(File.dirname(__FILE__), 'cli.rb'), 
          File.join(File.dirname(__FILE__), 'tasks/**/*.rb')
        ]
      end
  
    end
  end
end

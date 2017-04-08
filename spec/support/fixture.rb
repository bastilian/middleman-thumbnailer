module Middleman
  module Fixture
    class << self
      def app(&block)
        if Middleman::Application.respond_to?(:server)
          app = Middleman::Application.server.inst do
            instance_eval(&block) if block
          end
        else
          app = Middleman::Application.new do
            instance_eval(&block) if block
          end
        end
        app
      end
    end
  end
end

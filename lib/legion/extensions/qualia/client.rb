# frozen_string_literal: true

module Legion
  module Extensions
    module Qualia
      class Client
        include Runners::Qualia

        def initialize
          @default_engine = Helpers::QualiaEngine.new
        end
      end
    end
  end
end

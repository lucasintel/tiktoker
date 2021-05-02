class TikToker::CLI
  module CommandHelpers
    HUMAN_PREFIXES = {Tuple.new, {nil, 'K', 'M', 'B', 'T'}}

    private def humanize(number)
      if number < 1000
        number.to_s
      else
        number.humanize(prefixes: HUMAN_PREFIXES)
      end
    end

    private def print_exception(ex : Exception)
      STDERR.puts("ERROR: #{ex.message}".colorize(:red).bold)
      exit(1)
    end
  end

  abstract struct Command
    include CommandHelpers

    abstract def call
  end
end

require "./command/*"

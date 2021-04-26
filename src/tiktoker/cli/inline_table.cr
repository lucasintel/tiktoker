class Tiktoker::CLI
  class InlineTable
    def self.with(&block)
      builder = new
      with builder yield
      builder
    end

    def initialize
      @hash = {} of String => String
      @max = 0
    end

    def add(key : String, value) : Nil
      @hash[key] = value.to_s

      size = key.size
      @max = size if size > @max
    end

    def render
      String.build do |str|
        str << '\n'
        @hash.each do |key, value|
          str << key.ljust(@max, ' ').colorize.bold
          str << ' '
          str << ':'.colorize.bold
          str << ' '
          str << value
          str << '\n'
        end
        str << '\n'
      end
    end
  end
end

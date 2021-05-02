require "option_parser"

# EXT. Allow subcommands to have arguments.
class OptionParser
  private def parse_flag_definition(flag : String)
    case flag
    when /--(\S+)\s+\[\S+\]/
      {"--#{$1}", FlagValue::Optional}
    when /--(\S+)(\s+|\=)(\S+)?/
      {"--#{$1}", FlagValue::Required}
    when /--\S+/
      # This can't be merged with `else` otherwise /-(.)/ matches
      {flag, FlagValue::None}
    when /-(.)\s*\[\S+\]/
      {flag[0..1], FlagValue::Optional}
    when /-(.)\s+\S+/, /-(.)\s+/, /-(.)\S+/
      {flag[0..1], FlagValue::Required}
    when /(\S+)(\s+|\=)(\S+)?/
      {$1, FlagValue::Optional}
    else
      # This happens for -f without argument
      {flag, FlagValue::None}
    end
  end
end

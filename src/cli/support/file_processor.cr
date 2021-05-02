class TikToker::CLI
  class FileProcessor
    COMMENT_IDENTIFIER    = '#'
    INLINE_COMMENTS_REGEX = /#{COMMENT_IDENTIFIER}.*$/

    def self.call(file : String) : Array(SecUID)?
      return unless File.exists?(file)

      sec_uids = [] of SecUID

      File.each_line(file) do |line|
        next if line.empty?
        next if line.starts_with?(/\s/) || line.starts_with?(COMMENT_IDENTIFIER)

        sec_uids << line.gsub(INLINE_COMMENTS_REGEX, "").strip
      end

      sec_uids
    end
  end
end

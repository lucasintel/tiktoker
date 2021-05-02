module TikToker
  def self.setup_logger
    Log.setup do |log|
      backend = Log::IOBackend.new(formatter: TikTokerLogger)
      level = if TikToker.config.quiet
                Log::Severity::Error
              else
                Log::Severity::Info
              end

      log.bind "*", level, backend
    end
  end

  Log.define_formatter TikTokerLogger, "#{message} #{data(before: " -- ")}#{context(before: " -- ")}#{exception}"
  setup_logger
end

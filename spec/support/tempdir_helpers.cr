module TempDirHelpers
  def read_from_tempdir(filename : String) : String
    path = File.expand_path(filename, tempdir.path)
    File.read(path)
  end

  def tempdir : Dir
    Dir.mkdir_p(TEMPDIR_PATH) unless Dir.exists?(TEMPDIR_PATH)
    Dir.open(TEMPDIR_PATH)
  end
end

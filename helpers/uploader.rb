module Uploader
  FILE_PATH = 'accounts.yml'

  def load_data
    return [] unless File.exists?(FILE_PATH)

    YAML.load_file(FILE_PATH)
  end

  def save_data(data)
    File.open(FILE_PATH, 'w') { |f| f.write data.to_yaml }
  end
end
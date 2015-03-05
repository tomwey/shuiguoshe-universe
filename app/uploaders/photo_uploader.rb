# encoding: utf-8

class PhotoUploader < BaseUploader

  process :store_dimensions
  
  version :small do
    process resize_to_limit: [82, nil]
  end
  
  version :normal do
    process resize_to_limit: [920, nil]
  end
  
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end
  
  protected
    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end

  def extension_white_list
    %w(jpg jpeg png)
  end
  
  private
  def store_dimensions
    if file && model
      model.width, model.height = ::MiniMagick::Image.open(file.file)[:dimensions]
    end
  end
  
end

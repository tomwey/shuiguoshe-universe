# encoding: utf-8

class ImageUploader < BaseUploader

  version :small do
    process resize_to_fill: [60, 50]
  end
  
  version :thumb do
    process resize_to_fill: [240, 200]
  end

  version :large do
    process resize_to_fill: [390, 300]
  end

  def filename
    if super.present?
      "avatar/#{Time.now.to_i}.#{file.extension.downcase}"
    end
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

end

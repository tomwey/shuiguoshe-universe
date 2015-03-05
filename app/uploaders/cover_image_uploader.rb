# encoding: utf-8

class CoverImageUploader < BaseUploader

  version :small do
    process resize_to_fill: [138, 50]
  end
  
  version :thumb do
    process resize_to_fill: [336, 122]
  end

  version :large do
    process resize_to_fill: [690, 250]
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

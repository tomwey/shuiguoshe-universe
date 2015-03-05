# encoding: utf-8

class PictureUploader < BaseUploader

  version :small do
    process resize_to_fill: [82, 62]
  end
  
  version :normal do
    process resize_to_fill: [164, 124]
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

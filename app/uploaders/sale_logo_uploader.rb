# encoding: utf-8

class SaleLogoUploader < BaseUploader

  version :logo_small do
    process resize_to_fill: [50, 35]
  end
  
  version :logo_normal do
    process resize_to_fill: [100, 70]
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

# encoding: utf-8

class SaleAdImageUploader < BaseUploader

  version :ad_small do
    process resize_to_limit: [nil, 60]
  end
  
  version :ad_normal do
    process resize_to_limit: [nil, 360]
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

module MetaTagsHelper
  def meta_title
    content_for?(:meta_title) ? content_for(:meta_title) : "Bellboy | Your own personal hotel congierge in your pocket"
  end

  def meta_description
    content_for?(:meta_description) ? content_for(:meta_description) : "meta_description"
  end

  def meta_image
    meta_image = (content_for?(:meta_image) ? content_for(:meta_image) : "Bellboy-main.jpg"  )
    # little twist to make it work equally with an asset or a url
    meta_image.starts_with?("http") ? meta_image : image_url(meta_image)
  end
end

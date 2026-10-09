module EditorJsHelper
  INLINE_TAGS  = %w[b i a br u mark code strong em].freeze
  INLINE_ATTRS = %w[href target rel].freeze
  EMBED_HOSTS  = %w[www.youtube.com youtube.com www.youtube-nocookie.com player.vimeo.com].freeze

  def editorjs_inline(text)
    sanitize(text.to_s, tags: INLINE_TAGS, attributes: INLINE_ATTRS)
  end

  def render_editorjs(content)
    return "".html_safe unless content.is_a?(Hash) && content['blocks'].is_a?(Array)

    safe_join(content['blocks'].map { |block| render_editorjs_block(block) })
  end

  private

  def render_editorjs_block(block)
    data = block["data"] || {}

    case block["type"]
    when "paragraph"
      content_tag(:p, editorjs_inline(data["text"]))
    when "header"
      level = data["level"].to_i.clamp(2, 4)
      content_tag("h#{level}", editorjs_inline(data["text"]))
    when "list"
      tag = data["style"] == "ordered" ? :ol : :ul
      content_tag(tag) do
        safe_join(Array(data["items"]).map { |item| content_tag(:li, editorjs_inline(item.is_a?(Hash) ? item['content'] : item)) })
      end
    when "quote"
      content_tag(:blockquote) do
        concat content_tag(:p, editorjs_inline(data["text"]))
        concat content_tag(:cite, data["caption"]) if data["caption"].present?
      end
    when "image"
      url = data.dig("file", "url")
      return "".html_safe if url.blank?
      content_tag(:figure) do
        concat image_tag(url, alt: data["caption"].to_s, loading: "lazy")
        concat content_tag(:figcaption, sanitize(data["caption"])) if data["caption"].present?
      end
    when "delimiter"
      tag.hr
    when "embed"
      uri = (URI.parse(data["embed"].to_s) rescue nil)
      return "".html_safe unless uri&.host && EMBED_HOSTS.include?(uri.host)
      tag.iframe(src: data["embed"], loading: "lazy", allowfullscreen: true, class: "w-full aspect-video")
    else
      "".html_safe
    end
  end
end
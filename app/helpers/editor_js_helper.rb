module EditorJsHelper
  def render_editorjs(content)
    return "".html_safe unless content.is_a?(Hash) && content['blocks'].is_a?(Array)

    safe_join(content['blocks'].map { |block| render_editorjs_block(block) })
  end

  private

  def render_editorjs_block(block)
    data = block["data"] || {}

    case block["type"]
    when "paragraph"
      content_tag(:p, sanitize(data["text"], tags: %w[b i a br u mark code], attributes: %w[href]))
    when "header"
      level = data["level"].to_i.clamp(2, 4)
      content_tag("h#{level}", sanitize(data["text"], tags: %w[b i a br]))
    when "list"
      tag = data["style"] == "ordered" ? :ol : :ul
      content_tag(tag) do
        safe_join(Array(data["items"]).map { |item| content_tag(:li, sanitize(item.is_a?(Hash) ? item["content"] : item)) })
      end
    when "quote"
      content_tag(:blockquote) do
        concat content_tag(:p, sanitize(data["text"]))
        concat content_tag(:cite, data["caption"]) if data["caption"].present?
      end
    when "image"
      content_tag(:figure) do
        concat image_tag(data.dig("file", "url"), alt: data["caption"], loading: "lazy", class: "rounded-lg")
        concat content_tag(:figcaption, data["caption"]) if data["caption"].present?
      end
    when "delimiter"
      tag.hr
    when "embed"
      tag.iframe(src: data["embed"], width: data["width"], height: data["height"],
                 loading: "lazy", allowfullscreen: true, class: "w-full aspect-video")
    else
      "".html_safe
    end
  end
end
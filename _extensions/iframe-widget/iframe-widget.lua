function iframe_widget(args)
    -- 1. Check for the required 'src' argument
    if not args.src then
        error("The 'src' attribute is required for the iframe-widget shortcode.")
    end

    -- 2. Set default values for style properties
    local style_defaults = {
        position = "absolute",
        right = "36px",
        top = "72px",
        width = "612px",
        height = "540px",
        borderRadius = "16px",
        border = "1px solid black",
        boxShadow = "0 2px 8px rgba(0, 0, 0, 0.15)"
    }

    -- 3. Build the style string, using user-provided args or defaults
    -- Note: CSS property names with hyphens become camelCase in Lua (e.g., border-radius -> borderRadius)
    local style_parts = {}
    table.insert(style_parts, "position: " .. (args.position or style_defaults.position) .. ";")
    table.insert(style_parts, "right: " .. (args.right or style_defaults.right) .. ";")
    table.insert(style_parts, "top: " .. (args.top or style_defaults.top) .. ";")
    table.insert(style_parts, "width: " .. (args.width or style_defaults.width) .. ";")
    table.insert(style_parts, "height: " .. (args.height or style_defaults.height) .. ";")
    table.insert(style_parts, "border-radius: " .. (args.borderRadius or style_defaults.borderRadius) .. ";")
    table.insert(style_parts, "border: " .. (args.border or style_defaults.border) .. ";")
    table.insert(style_parts, "box-shadow: " .. (args.boxShadow or style_defaults.boxShadow) .. ";")

    local style_string = table.concat(style_parts, " ")

    -- 4. Create the final HTML using string.format
    local html_template = [[
<div class="iframe-widget" style="%s">
  <svg
      style="position: absolute; inset:0; width: 100%; height: 100%; z-index: 49;"
      xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
  </svg>

  <div class="iframe-wrapper">
    <iframe class="z-target" style="z-index: 50;" src="%s">
    </iframe>
  </div>

  <div class="z-controls">
    <button class="z-btn active" data-z="50">✓</button>
    <button class="z-btn" data-z="48">✗</button>
  </div>
</div>
  ]]

    local final_html = string.format(html_template, style_string, args.src)

    -- 5. Return the HTML as a raw block so Quarto doesn't process it further
    return quarto.RawBlock('html', final_html)
end

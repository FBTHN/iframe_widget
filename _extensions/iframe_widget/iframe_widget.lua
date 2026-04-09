-- Tells Quarto to automatically load your CSS and JS files
quarto.doc.add_html_dependency({
  name = "iframe_widget",
  version = "1.0.0",
  scripts = { "iframe_widget.js" },
  stylesheets = { "iframe_widget.css" }
})

return {
  ["iframe_widget"] = function(args, kwargs)
    -- HELPER: Forcefully convert Pandoc AST objects into plain text strings.
    -- This prevents the "bad argument #2 to 'concat'" error.
    local function to_str(val)
      if val == nil then return nil end

      local str = ""
      if type(val) == "string" then
        str = val
      else
        str = pandoc.utils.stringify(val)
      end
      if str == "" then return nil end

      return str
    end

    -- 1. Extract and stringify 'src' (Check kwargs.src first, then fallback to args[1])
    local src = to_str(kwargs.src) or to_str(args[1])
    if not src then
      error("The 'src' attribute is required for the iframe-widget shortcode.")
    end


    -- 2. Set default values for style properties
    local defaults     = {
      position = "absolute",
      right = "36px",
      top = "72px",
      width = "612px",
      height = "540px",
      borderRadius = "16px",
      border = "1px solid black",
      boxShadow = "0 2px 8px rgba(0, 0, 0, 0.15)"
    }

    -- 3. Safely extract all style variables as TRUE PLAIN STRINGS
    local position     = to_str(kwargs.position) or defaults.position
    local right        = to_str(kwargs.right) or defaults.right
    local top          = to_str(kwargs.top) or defaults.top
    local width        = to_str(kwargs.width) or defaults.width
    local height       = to_str(kwargs.height) or defaults.height
    local borderRadius = to_str(kwargs.borderRadius) or defaults.borderRadius
    local border       = to_str(kwargs.border) or defaults.border
    local boxShadow    = to_str(kwargs.boxShadow) or defaults.boxShadow

    -- 4. Build the style string (100% safe to concatenate now)
    local style_parts  = {}
    table.insert(style_parts, "position: " .. position .. ";")
    table.insert(style_parts, "right: " .. right .. ";")
    table.insert(style_parts, "top: " .. top .. ";")
    table.insert(style_parts, "width: " .. width .. ";")
    table.insert(style_parts, "height: " .. height .. ";")
    table.insert(style_parts, "border-radius: " .. borderRadius .. ";")
    table.insert(style_parts, "border: " .. border .. ";")
    table.insert(style_parts, "box-shadow: " .. boxShadow .. ";")

    local style_string = table.concat(style_parts, " ")

    -- 5. Create the final HTML
    local html_template = [[
<div class="iframe_widget" style="]] .. style_string .. [[">
  <svg
      style="position: absolute; inset:0; width: 100%%; height: 100%%; z-index: 49;"
      xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
  </svg>

  <svg class="print-link-svg"
    style="position: absolute; inset:0; width: 100%%; height: 100%%; z-index: 52;"
    xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
    <a style="position: absolute; inset:0; width: 100%%; height: 100%%;" href="]] ..
        src .. [[" target="_blank" rel="noopener"><rect
      x="0" y="0" width="100%%" height="100%%" fill="transparent" pointer-events="all" /></a>
  </svg>

  <div class="iframe-wrapper">
    <iframe class="z-target" style="z-index: 50;" src="]] .. src .. [[">
    </iframe>
  </div>

  <div class="z-controls">
    <button class="z-btn active" data-z="50">✓</button>
    <button class="z-btn" data-z="48">✗</button>
  </div>
</div>
    ]]

    local final_html = string.format(html_template)

    -- 6. Return the HTML as a raw block
    return pandoc.RawBlock('html', final_html)
  end
}

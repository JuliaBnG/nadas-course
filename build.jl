#!/usr/bin/env julia

using Markdown

# Configuration
const TEMPLATE_FILE = "annotation_template.html"
const MAIN_MD = "index.md"
const OUTPUT_FILE = "index.html"

function slugify(text)
    # Simple slugify: lowercase and replace non-alphanumeric with hyphen
    s = lowercase(text)
    s = replace(s, r"[^a-z0-9\s-]" => "")
    s = replace(s, r"\s+" => "-")
    return s
end

function regex_escape(s)
    return replace(s, r"([.*+?^${}()|\[\]\/\\])" => s"\\\1")
end

function make_external_links_blank(html)
    # Target links starting with http or https
    return replace(html, 
        r"""<a\s+href="(https?://[^"]+)">""" => s"""<a href="\1" target="_blank" rel="noopener noreferrer">"""
    )
end

function unescape_math(html)
    # Julia Markdown escapes $ as &#36;. We need it back for MathJax.
    return replace(html, "&#36;" => "\$")
end

function build()
    if !isfile(TEMPLATE_FILE)
        println("Error: $TEMPLATE_FILE not found.")
        return
    end

    # 1. Read the template
    template = read(TEMPLATE_FILE, String)

    # 2. Process Main Content
    if !isfile(MAIN_MD)
        println("Error: $MAIN_MD not found.")
        return
    end

    main_content_md = read(MAIN_MD, String)

    # Extract ToC items (h2 and h3)
    toc_items = []
    # Match headers: ## Header or ### Header
    for m in eachmatch(r"^(#{2,3})\s+(.+)$"m, main_content_md)
        level = length(m.captures[1])
        title = m.captures[2]
        id = slugify(title)
        push!(toc_items, (level=level, title=title, id=id))
    end

    # Identify targets for annotations
    # Pattern: [Text](annotation:id)
    targets = [m.captures[2] for m in eachmatch(r"\[([^\]]+)\]\(annotation:([^)]+)\)", main_content_md)]
    
    # Convert MD to HTML using stdlib
    main_html = sprint(Markdown.html, Markdown.parse(main_content_md))
    
    # Add IDs to headers in main_html for ToC linking
    for item in toc_items
        tag = "h$(item.level)"
        # Replace <h2>Title</h2> with <h2 id="slug">Title</h2>
        pattern = Regex("<$(tag)>$(regex_escape(item.title))</$(tag)>")
        replacement = "<$(tag) id=\"$(item.id)\">$(item.title)</$(tag)>"
        main_html = replace(main_html, pattern => replacement)
    end

    # Replace <a href="annotation:id">Text</a> with the span version
    main_html = replace(main_html, 
        r"""<a href="annotation:([^"/]+)">([^<]+)</a>""" => s"""<span class="annotation-link" data-target="\1">\2</span>"""
    )

    # Handle feedback links: [Text](feedback:Topic)
    main_html = replace(main_html,
        r"""<a href="feedback:([^"/]+)">([^<]+)</a>""" => s"""<span class="annotation-link feedback-link" data-target="\1">\2</span>"""
    )

    # Make external links open in new tab
    main_html = make_external_links_blank(main_html)
    
    # Unescape math for MathJax
    main_html = unescape_math(main_html)

    # 3. Process Annotations
    annotations_html = ""
    for target in unique(targets)
        anno_file = "$target.md"
        if isfile(anno_file)
            content = read(anno_file, String)
            html = sprint(Markdown.html, Markdown.parse(content))
            # Also handle external links and math in annotations
            html = make_external_links_blank(html)
            html = unescape_math(html)
            block = """<div id="$target" class="annotation-content">$html</div>\n"""
            annotations_html *= block
        else
            println("Warning: Annotation file $anno_file not found.")
        end
    end

    # 4. Generate ToC HTML
    toc_html = ""
    for item in toc_items
        toc_html *= """<li class="toc-item level-$(item.level)"><a href="#$(item.id)">$(item.title)</a></li>\n"""
    end

    # 5. Inject into Template
    final_html = template

    # Update Title from H1
    title_match = match(r"^#\s+(.+)$"m, main_content_md)
    page_title = title_match !== nothing ? title_match.captures[1] : "Interactive Instructions"
    final_html = replace(final_html, r"<title>.*?</title>" => "<title>$page_title</title>")

    # Helper function for safe injection
    function inject(html, pattern, content)
        m = match(pattern, html)
        if m !== nothing
            # Join parts manually to avoid SubstitutionString escape issues
            return html[1:prevind(html, m.offsets[1] + length(m.captures[1]))] * 
                   "\n" * content * 
                   html[m.offsets[2]:end]
        end
        return html
    end

    # Injecting ToC
    final_html = inject(final_html, r"(<!-- TOC_START -->).*?(<!-- TOC_END -->)"s, toc_html)

    # Injecting Main Flow
    final_html = inject(final_html, r"(<!-- MAIN_START -->).*?(<!-- MAIN_END -->)"s, main_html)
    
    # Injecting Annotations
    new_anno_content = """
        <!-- Default State -->
        <div id="default-msg" class="placeholder-text">
            Select a highlighted term to view annotations.
        </div>
""" * annotations_html

    final_html = inject(final_html, r"(<!-- ANNO_START -->).*?(<!-- ANNO_END -->)"s, new_anno_content)

    # 6. Save Output
    write(OUTPUT_FILE, final_html)
    
    println("Success! $OUTPUT_FILE has been generated.")
end

build()

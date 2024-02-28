module Jekyll
    class CustomPosts < Generator
        safe true
        priority :high
    
        def generate(site)
            Dir.glob(File.join(site.source, "_posts", "**/*.md")).each do |post_file|
                process_post(site, post_file)
            end            
        end

        def process_post(site, post_file)
            post = Document.new(post_file, {
                site: site,
                collection: site.collections['posts']
            })

            post.read
            post.content = post.content.gsub(/\(images\//, '({{ page.url | relative_url }}images/')

            post.data["slug"] = post.data["title"]
            site.collections['posts'].docs << post
          end         
    end
end

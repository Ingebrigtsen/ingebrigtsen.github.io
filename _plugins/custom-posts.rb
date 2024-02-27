module Jekyll
    class CustomPosts < Generator
        safe true
        priority :high
    
        def generate(site)
            custom_files_path = "_posts"
            Dir.glob(File.join(site.source, custom_files_path, "**/*.md")).each do |post_file|
                process_post(site, post_file)
            end            
        end

        def process_post(site, custom_file)
            post = Document.new(custom_file, {
                site: site,
                collection: site.collections['posts']
            })

            post.read

            post.data["slug"] = post.data["title"]
            site.collections['posts'].docs << post
          end         
    end
end

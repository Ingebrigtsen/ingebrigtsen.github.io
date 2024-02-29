Jekyll::Hooks.register :site, :post_write do |site|
    site.posts.each do |post|
        anchor_regex = /a href="(.*?)"/
        file_regex = /files\/(.*?)"/
        file_urls = post.content.scan(anchor_regex).flatten

        source_directory = File.dirname(post.path)
        destination_directory = File.dirname(post.destination('/'))

        file_urls.each do |file_url|
            file_url = File.join("files", File.basename(file_url))
            file_path = File.join(source_directory, file_url)

            if File.exist?(file_path)
                file_dest = File.join(destination_directory, file_url)
                FileUtils.mkdir_p(File.dirname(file_dest))
                FileUtils.cp(file_path, file_dest)
            end
        end
    end
end

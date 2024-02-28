Jekyll::Hooks.register :site, :post_write do |site|
    site.posts.each do |post|
        image_regex = /img src="(.*?)"/
        file_regex = /images\/(.*?)"/
        image_urls = post.content.scan(image_regex).flatten

        source_directory = File.dirname(post.path)
        destination_directory = File.dirname(post.destination('/'))

        image_urls.each do |image_url|
            image_url = File.join("images", File.basename(image_url))
            image_path = File.join(source_directory, image_url)

            if File.exist?(image_path)
                image_dest = File.join(destination_directory, image_url)
                FileUtils.mkdir_p(File.dirname(image_dest))
                FileUtils.cp(image_path, image_dest)
            end
        end
    end
end

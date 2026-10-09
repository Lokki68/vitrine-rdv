# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@editorjs/delimiter", to: "@editorjs--delimiter.js" # @1.4.2
pin "@editorjs/editorjs", to: "@editorjs--editorjs.js" # @2.1.0
pin "@editorjs/embed", to: "@editorjs--embed.js" # @2.8.0
pin "@editorjs/header", to: "@editorjs--header.js" # @2.8.9
pin "@editorjs/image", to: "@editorjs--image.js" # @2.10.3
pin "@editorjs/list", to: "@editorjs--list.js" # @2.0.9
pin "@editorjs/paragraph", to: "@editorjs--paragraph.js" # @2.11.7
pin "@editorjs/quote", to: "@editorjs--quote.js" # @2.7.6

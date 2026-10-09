# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "@editorjs/editorjs",  to: "https://esm.sh/@editorjs/editorjs@2.30.8"
pin "@editorjs/header",    to: "https://esm.sh/@editorjs/header@2.8.8"
pin "@editorjs/list",      to: "https://esm.sh/@editorjs/list@1.10.0"
pin "@editorjs/delimiter", to: "https://esm.sh/@editorjs/delimiter@1.4.2"
pin "@editorjs/quote",     to: "https://esm.sh/@editorjs/quote@2.7.2"
pin "@editorjs/embed",     to: "https://esm.sh/@editorjs/embed@2.7.6"
pin "@editorjs/image",     to: "https://esm.sh/@editorjs/image@2.10.1"

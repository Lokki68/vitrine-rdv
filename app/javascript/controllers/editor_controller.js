import {Controller} from "@hotwired/stimulus";
import EditorJS from "@editorjs/editorjs";
import Header from "@editorjs/header";
import List from "@editorjs/list"
import Delimiter from "@editorjs/delimiter";
import Quote from "@editorjs/quote";
import Embed from "@editorjs/embed";
import ImageTool from "@editorjs/image";

export default class extends Controller {
    static targets = ['holder', 'input']
    static values = { uploadUrl: String }

    connect() {
        const initial = this.inputTarget.value
        this.editor = new EditorJS({
            holder: this.holderTarget,
            placeholder: "Ecrivez votre article ...",
            data: initial ? JSON.parse(initial) : { blocks: [] },
            tools: {
                header: { class: Header, config: { levels: [2,3,4], defaultLevel: 2 }},
                list: List,
                quote: Quote,
                delimiter: Delimiter,
                embed: Embed,
                image: {
                    class: ImageTool,
                    config: {
                        endpoints: { byFile: this.uploadUrlValue },
                        additionalRequestHeaders: {
                            "X-CSRF-Token": document.querySelector("meta[name=csrf-token]").content
                        }
                    },

                }
            },
            onChange: () => this.save()
        })
    }

    async save() {
        const data = await this.editor.save()
        this.inputTarget.value = JSON.stringify(data)
    }

    async beforeSubmit(event) {
        event.preventDefault()
        await this.save()
        event.target.closest('form').requestSubmit()
    }

    disconnect() {
        this.editor?.destroy?.()
    }
}

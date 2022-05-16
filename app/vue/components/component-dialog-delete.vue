<script>
export default {
    props: {
        object: {
            required: true,
            type: Object
        },
        callback: {
            required: true,
            type: Function
        },
        app_module: {
            required: true,
            type: String
        },
        controller: {
            required: true,
            type: String
        },
        title: {
            required: true,
            type: String
        },
        text: {
            required: true,
            type: String
        },
        successText: {
            type: String,
            default: 'Confirmar'
        },
        confirmBtnText: {
            type: String,
            default: 'Confirmar'
        },
        cancelBtnText: {
            type: String,
            default: 'Cancelar'
        },
        showLoading: {
            type: Boolean,
            default: false
        }
    },
    methods: {
        onClick(resp) {
            if (resp) {
                const form = {
                    sale: {
                        status: false
                    }
                }

                if (this.showLoading) this.$loading(true)

                const url = this.url[this.app_module](`${this.controller}:id`, {id: this.object.id})
                this.http.put(url, form).then(result => {
                    if (this.showLoading) this.$loading(false)

                    if (result.successful) {
                        this.$toast.success(this.successText)
                        this.callback(true)

                    } else {
                        this.$toast.error(result.error.message)
                        this.callback(false)
                    }
                }).catch(error => {
                    console.log(error)

                    this.callback(false)
                })
            } else {
                this.callback(false)
            }
        }
    }
}
</script>

<template>
    <div>
        <b-card
            ref="delete-modal"
            :title="title"
            style="border: 0"
        >
            <p class="card-text">
                {{ text }}
            </p>
            <div class="text-right">
                <b-button variant="outline-dark" @click="onClick(false)">Cancelar</b-button>
                <b-button variant="outline-danger" @click="onClick(true)">Confirmar</b-button>
            </div>
        </b-card>
    </div>
</template>
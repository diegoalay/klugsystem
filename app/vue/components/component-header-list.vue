<script>
export default {
    props: {
        title: {
            default: null
        },
        subtitle: {
            default: null
        },
        buttons: {
            default: true
        },
        titleButtonCreate: {
            default: "Create"
        }
    },
    data() {
        return {
            loading: false
        }
    },
    mounted(){

    },
    methods: {
        clickButtonReload() {
            alert(2)
            this.loading = true
            setTimeout(() => { this.loading = false }, 1000);
            this.$emit("clickButtonReload");
        }
    }
}
</script>
<template>
    <nav class="navbar">
        <div class="navbar-menu">
            <div class="navbar-start">
                <div class="navbar-item">
                    <h3 v-if="title" class="is-size-3">
                        {{ title }}
                    </h3>
                    <h4 v-if="subtitle" class="is-size-4">
                        {{ subtitle }}
                    </h4>
                </div>
            </div>
            <div class="navbar-end">
                <div class="navbar-item">
                    <slot></slot>
                    <div class="buttons" v-if="buttons">
                        <b-button variant="primary" class="mb-2">
                            Recargar <b-icon icon="download"></b-icon>
                        </b-button>
                        <b-button v-if="this.$route.path=='/'" variant="dark" class="mb-2" to="/new">
                            {{ titleButtonCreate }} <b-icon icon="plus"></b-icon>
                        </b-button>
                    </div>
                </div>
            </div>
        </div>
    </nav>
</template>
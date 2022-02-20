<script>
export default {
    props: {
        title: {
            default: null
        },
        subtitle: {
            default: null
        },
        showButtons: {
            default: true
        }
    },
    data(){
        return {
            main_path: null
        }
    },
    mounted(){
        let path = this.$route.path
        path = path.replace(/[0-9]/g, '')
        path = path.replace('/new', '')

        if (path.endsWith('/')) {
            path = path.slice(0, -1);
        }

        this.main_path = path
    },
    methods: {
        listPath(){
            return this.main_path
        },
        newPath(){
            return this.main_path + '/new'
        },

        isNewForm(){
            const path = this.$route.path

            if (path.includes('/new')) {
                return true
            } else {
                return false
            }
        }
    }
}
</script>
<template>
    <nav class="navbar component-header-form">
        <div class="float-left">
            <div class="navbar-item">
                <h3 class="is-size-3"> {{ title }} </h3>
            </div>
        </div>
        <div class="float-right" v-if="showButtons">
            <template name="buttons">
                <slot>
                    <b-button variant="outline-dark" class="mb-2" :to="listPath()">
                        Listado <font-awesome-icon icon="list" />
                    </b-button>
                    <b-button v-if="!isNewForm()" variant="outline-dark" class="mb-2" :to="newPath()">
                        Agregar nuevo <font-awesome-icon icon="plus" />
                    </b-button>
                </slot>
            </template>
        </div>
    </nav>
</template>
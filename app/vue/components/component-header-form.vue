<script>
export default {
    props: {
        title: {
            default: null
        },
        subtitle: {
            default: null
        },
    },
    data(){
        return {
            main_path: null
        }
    },
    mounted(){
        this.main_path = this.$route.path
        this.main_path = this.main_path.replace(/[0-9]/g, '')
        this.main_path = this.main_path.replace('new', '')
        this.main_path = this.main_path.replace('/', '')
    },
    methods: {}
}
</script>
<template>
    <nav class="navbar component-header-form">
        <div class="float-left">
            <div class="navbar-item">
                <h3 class="is-size-3"> {{ title }} </h3>
            </div>
        </div>
        <div class="float-right">
            <template name="buttons">
                <slot>
                    <b-button variant="outline-dark" class="mb-2" :to="`/${main_path}`">
                        Listado <font-awesome-icon icon="list" />
                    </b-button>
                </slot>
            </template>
        </div>
    </nav>
</template>
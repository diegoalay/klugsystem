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
    mounted(){

    },
    methods: {

    }
}
</script>
<template>
    <nav class="navbar component-header">
        <div class="navbar-menu">
            <div class="navbar-start">
                <div class="navbar-item">
                    <h4 class="is-size-3"> {{ title }} </h4>
                </div>
            </div>
            <div class="navbar-end">
                <div class="navbar-item">
                    <div class="buttons">
                        <b-button variant="dark" class="mb-2" to="/">
                            Listado <b-icon icon="list"></b-icon>
                        </b-button>
                    </div>
                </div>
            </div>
        </div>
    </nav>
</template>
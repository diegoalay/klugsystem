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
    <nav class="navbar component-header-form">
        <div class="float-left">
            <div class="navbar-item">
                <h4 class="is-size-3"> {{ title }} </h4>
            </div>
        </div>
        <div class="float-right">
            <div class="buttons">
                <b-button variant="dark" class="mb-2" to="/">
                    Listado <font-awesome-icon icon="list" />
                </b-button>
            </div>
        </div>
    </nav>
</template>
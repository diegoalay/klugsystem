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
                <h3 class="is-size-3"> {{ title }} </h3>
            </div>
        </div>
        <div class="float-right">
            <template name="buttons">
                <slot>
                    <b-button variant="outline-dark" class="mb-2" to="/">
                        Listado <font-awesome-icon icon="list" />
                    </b-button>
                </slot>
            </template>
        </div>
    </nav>
</template>
<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                catalog_client_type: {}
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear tipo de cliente">
        </component-header-form>
        <component-form :catalog_client_type="catalog_client_type"></component-form>
    </section>
</template>
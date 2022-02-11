<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                catalog_expediture_type: {}
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear tipo de gasto">
        </component-header-form>
        <component-form :catalog_expediture_type="catalog_expediture_type"></component-form>
    </section>
</template>
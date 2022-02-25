<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                catalog_product_transaction_type: {}
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear tipo de transacción de producto">
        </component-header-form>
        <component-form :catalog_product_transaction_type="catalog_product_transaction_type"></component-form>
    </section>
</template>
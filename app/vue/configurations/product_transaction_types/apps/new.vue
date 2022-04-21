<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                product_transaction_type: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear tipo de transacción de producto">
        </component-header-form>
        <component-form :product_transaction_type="product_transaction_type"></component-form>
    </section>
</template>
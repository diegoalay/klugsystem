<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                payment_method: {},
                main_path: '/payment_methods'
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear método de pago">
        </component-header-form>
        <component-form :main_path="main_path" :payment_method="payment_method"></component-form>
    </section>
</template>
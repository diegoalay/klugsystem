<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                bill_template: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear plantilla de facturación">
        </component-header-form>
        <component-form :bill_template="bill_template"></component-form>
    </section>
</template>
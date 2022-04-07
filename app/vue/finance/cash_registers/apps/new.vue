<script type="text/javascript">
    import componentForm from '../components/form_new.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                cash_register: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Apertura de caja">
        </component-header-form>
        <component-form :cash_register="cash_register"></component-form>
    </section>
</template>
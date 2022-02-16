<script type="text/javascript">
    import componentForm from '../components/form.vue'
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
    <section class="application-component">
        <component-header-form
            title="Crear marca">
        </component-header-form>
        <component-form :cash_register="cash_register"></component-form>
    </section>
</template>
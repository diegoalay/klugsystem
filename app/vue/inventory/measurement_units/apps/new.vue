<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                measurement_unit: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear marca">
        </component-header-form>
        <component-form :measurement_unit="measurement_unit"></component-form>
    </section>
</template>
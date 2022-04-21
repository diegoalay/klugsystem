<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                expediture_type: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear tipo de gasto">
        </component-header-form>
        <component-form :expediture_type="expediture_type"></component-form>
    </section>
</template>
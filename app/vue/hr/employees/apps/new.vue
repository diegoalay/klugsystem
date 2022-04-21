<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                employee: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear empleado">
        </component-header-form>
        <component-form :employee="employee"></component-form>
    </section>
</template>
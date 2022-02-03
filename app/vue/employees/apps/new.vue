<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                employee: {},
                main_path: '/employees'
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear empleado">
        </component-header-form>
        <component-form :main_path="main_path" :employee="employee"></component-form>
    </section>
</template>
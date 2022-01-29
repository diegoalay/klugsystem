<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                department: {},
                main_path: '/departments'
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear departamento">
        </component-header-form>
        <component-form :main_path="main_path" :department="department"></component-form>
    </section>
</template>
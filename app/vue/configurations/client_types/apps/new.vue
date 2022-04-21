<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                client_type: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear tipo de cliente">
        </component-header-form>
        <component-form :client_type="client_type"></component-form>
    </section>
</template>
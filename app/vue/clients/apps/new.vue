<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        props: {},
        data() {
            return {
                client: {},
                main_path: '/clients'
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear cliente">
        </component-header-form>
        <component-form :client="client"></component-form>
    </section>
</template>
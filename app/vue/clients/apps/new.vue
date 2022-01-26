<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        props: {
            view_type: {
                default: 'new',
            }
        },
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
        <component-form :main_path="main_path" :view_type="view_type" :client="client"></component-form>
    </section>
</template>
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
                branch_office: {},
                main_path: '/branch_offices'
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear sucursal">
        </component-header-form>
        <component-form :main_path="main_path" :view_type="view_type" :branch_office="branch_office"></component-form>
    </section>
</template>
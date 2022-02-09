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
                branch_office: {}
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear sucursal">
        </component-header-form>
        <component-form :view_type="view_type" :branch_office="branch_office"></component-form>
    </section>
</template>
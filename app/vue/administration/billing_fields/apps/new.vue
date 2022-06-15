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
                billing_field: {
                    color: '#000000'
                }
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear campo de facturación">
        </component-header-form>
        <component-form :view_type="view_type" :billing_field="billing_field"></component-form>
    </section>
</template>
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
                unit: {},
                main_path: '/units'
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Destinos">
        </component-header-form>
        <component-form :main_path="main_path" :view_type="view_type" :unit="unit"></component-form>
    </section>
</template>
<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        mounted(){
        },
        props: {},
        data() {
            return {
                role: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear rol">
        </component-header-form>
        <component-form :role="role"></component-form>
    </section>
</template>
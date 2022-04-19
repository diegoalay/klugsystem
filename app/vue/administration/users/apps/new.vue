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
                user: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear usuario">
        </component-header-form>
        <component-form :user="user"></component-form>
    </section>
</template>
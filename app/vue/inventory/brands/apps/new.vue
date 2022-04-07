<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                brand: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear marca">
        </component-header-form>
        <component-form :brand="brand"></component-form>
    </section>
</template>
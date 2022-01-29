<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                brand: {},
                main_path: '/brands'
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear marca">
        </component-header-form>
        <component-form :main_path="main_path" :brand="brand"></component-form>
    </section>
</template>
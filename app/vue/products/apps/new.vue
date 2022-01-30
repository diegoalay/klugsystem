<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                product: {},
                main_path: '/products'
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear producto">
        </component-header-form>
        <component-form :main_path="main_path" :product="product"></component-form>
    </section>
</template>
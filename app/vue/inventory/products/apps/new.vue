<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                product: {
                    product_type: 'good'
                }
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear producto">
        </component-header-form>
        <component-form :product="product"></component-form>
    </section>
</template>
<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                expediture: {
                    expediture_date: new Date()
                }
            }
        },
        mounted(){}
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Crear gasto">
        </component-header-form>
        <component-form :expediture="expediture"></component-form>
    </section>
</template>
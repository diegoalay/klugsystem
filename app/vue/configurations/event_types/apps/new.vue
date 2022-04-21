<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                event_type: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear tipo de evento">
        </component-header-form>
        <component-form :event_type="event_type"></component-form>
    </section>
</template>
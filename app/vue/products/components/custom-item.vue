<script>

export default {
    props: {
        open: {
            type: Boolean,
            required: true
        }
    },

    data() {
        return {

        }
    },

    methods:{
        closeModal(){
            this.$bvModal.hide('add-to-cart')
        }
    },

    watch: {
        open(value){
            if (value) {
                this.$bvModal.show('add-to-cart')
            }
        }
    }
}
</script>
<template>
    <div>
        <b-modal id="add-to-cart" hide-footer>
            <template #modal-title>
                Agregar artículo
            </template>
            <div class="d-block text-center">
                <h3>Hello From This Modal!</h3>
            </div>
            <b-button class="mt-3" block @click="closeModal()">Cerrar</b-button>
        </b-modal>
    </div>
</template>
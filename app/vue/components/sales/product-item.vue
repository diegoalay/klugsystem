<script>
export default {
    props: {
        product: {
            type: Object,
            required: false
        },
        options: {
            type: Object,
            required: true
        }
    },

    data(){
        return {
            products: [],
            imgProps: { center: true, blankColor: '#777', width: 125, height: 125, class: 'm1' }
        }
    },

    methods: {
        addProduct(product){
            this.$emit('product', product)
        }
    }
}

</script>
<template>
    <b-col sm="6" md="4">
        <b-card @click="addProduct(product)" class="overflow-hidden h-100 mt-1 p-1 pb-1 mb-1">
            <template #header>
                <p class="mb-0 text-center"><b> {{ product.name }} </b></p>
            </template>
            <b-row no-gutters>
                <b-img v-bind="imgProps" fluid class="text-center img-thumbnail" :src="tools.getProductImage(product)" alt="Image" bottom></b-img>

                <b-card-body>
                    <p> <b>Precio: </b> {{ 'Q ' + product.retail_price }} </p>
                    <template v-if="product.product_type === 'good'">
                        <p v-if="options.inventory_count"> <b>Existencias:</b> {{ product.quantity }} </p>
                        <p v-if="product.brand_name"> <b>Marca:</b> {{ product.brand_name }} </p>
                        <p v-if="product.department_name"> <b>Marca:</b> {{ product.department_name }} </p>
                        <p class="text-info"> <b> (Bien) </b></p>
                    </template>
                    <template v-else>
                        <p class="text-dark"> <b> (Servicio) </b></p>
                    </template>
                </b-card-body>
            </b-row>
        </b-card>
    </b-col>
</template>

<style scoped>
.card-body {
    flex: 1 1 auto;
    padding: 0.2rem;
}

.card {
    margin-top: 1rem;
    padding: 2px;
    cursor: pointer;
}

.card-header {
  padding: 0.2rem;
}

.card-title {
    margin-bottom: 0.25rem;
}

p {
    margin-top: 0;
    margin-bottom: 0.2rem;
    color: #000;
}

.col-xl, .col-xl-auto, .col-xl-12, .col-xl-11, .col-xl-10, .col-xl-9, .col-xl-8, .col-xl-7, .col-xl-6, .col-xl-5, .col-xl-4, .col-xl-3, .col-xl-2, .col-xl-1, .col-lg, .col-lg-auto, .col-lg-12, .col-lg-11, .col-lg-10, .col-lg-9, .col-lg-8, .col-lg-7, .col-lg-6, .col-lg-5, .col-lg-4, .col-lg-3, .col-lg-2, .col-lg-1, .col-md, .col-md-auto, .col-md-12, .col-md-11, .col-md-10, .col-md-9, .col-md-8, .col-md-7, .col-md-6, .col-md-5, .col-md-4, .col-md-3, .col-md-2, .col-md-1, .col-sm, .col-sm-auto, .col-sm-12, .col-sm-11, .col-sm-10, .col-sm-9, .col-sm-8, .col-sm-7, .col-sm-6, .col-sm-5, .col-sm-4, .col-sm-3, .col-sm-2, .col-sm-1, .col, .col-auto, .col-12, .col-11, .col-10, .col-9, .col-8, .col-7, .col-6, .col-5, .col-4, .col-3, .col-2, .col-1 {
    width: 100%;
    padding-right: 10px;
    padding-left: 10px;
    padding-top: 20px;
}
</style>
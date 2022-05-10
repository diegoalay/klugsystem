<script>
export default {
    props: {
        product: {
            required: true,
            type: Object
        }
    },
    components: {

    },
    data() {
        return {
            options: {
                branch_offices: [],
                departments: [],
                brands: [],
                measurement_units: [],
                product_types: []
            }
        }
    },
    mounted() {
        this.getOptions()
    },
    methods: {
        onSubmit(){
            if (this.product.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.inventory('products')
            let form = {
                product: this.product
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Producto creado exitosamente.')
                    this.$router.push(this.url.inventory('products/:id', { id: result.data.id }).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.inventory('products/:id', {id: this.product.id})
            let form = {
                product: this.product
            }

            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Producto actualizado exitosamente.')
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        getOptions(){
            const url = this.url.inventory('products/options')
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>

<template>
    <b-form @submit.prevent="onSubmit">
        <b-card>
            <b-card-body>
                <b-row>
                    <b-col md="6" sm="12">
                        <b-form-group>
                            <label> Nombre <sup class="text-danger">*</sup> </label>

                            <b-form-input
                                v-model="product.name"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                    <b-col md="6" sm="12">
                        <b-form-group>
                            <label> Sku <sup class="text-danger">*</sup> </label>

                            <b-form-input
                                v-model="product.sku"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                    <b-col md="8" sm="12">
                        <b-form-group>
                            <label> Cantidad <sup class="text-danger">*</sup> </label>

                            <b-form-input
                                :disabled="product.id ? true : false"
                                v-model="product.quantity"
                                type="number"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                    <b-col md="4" sm="12">
                        <b-form-group>
                            <template #label>
                                Tipo de producto <sup class="text-danger">*</sup>
                            </template>
                            <b-form-radio-group
                                required
                                id="radio-group-1"
                                v-model="product.product_type"
                                :options="options.product_types"
                                name="radio-options"
                            ></b-form-radio-group>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-row>
                    <b-col md="6" sm="12">
                        <b-form-group>
                            <label> Unidad de medida <sup class="text-danger">*</sup> </label>
                            <b-form-select required v-model="product.measurement_unit_id" :options="options.measurement_units">
                            </b-form-select>
                        </b-form-group>
                    </b-col>

                    <b-col md="6" sm="12">
                        <b-form-group>
                            <label> Sucursal <sup class="text-danger">*</sup> </label>
                            <b-form-select required v-model="product.branch_office_id" :options="options.branch_offices">
                            </b-form-select>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-row>
                    <b-col md="4" sm="12">
                        <b-form-group>
                            <label> Precio <sup class="text-danger">*</sup> </label>

                            <b-form-input
                                v-model="product.retail_price"
                                type="number"
                                placeholder=""
                                required
                                step="any"
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                    <b-col md="4" sm="12">
                        <b-form-group>
                            <label> Precio mayoreo </label>

                            <b-form-input
                                v-model="product.wholesale_price"
                                type="number"
                                placeholder=""
                                step="any"
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                    <b-col md="4" sm="12">
                        <b-form-group>
                            <label> Precio compra </label>

                            <b-form-input
                                v-model="product.purchase_price"
                                type="number"
                                placeholder=""
                                step="any"
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-form-group>
                    <label> Marca </label>
                    <b-form-select v-model="product.brand_id" :options="options.brands">
                    </b-form-select>
                </b-form-group>

                <b-form-group>
                    <label> Departamento </label>
                    <b-form-select v-model="product.department_id" :options="options.departments">
                    </b-form-select>
                </b-form-group>

                <b-button type="submit" variant="primary">Guardar</b-button>
            </b-card-body>
        </b-card>
    </b-form>
</template>
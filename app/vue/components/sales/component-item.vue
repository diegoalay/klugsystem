<script>

export default {
    props: {
        item: {
            required: true,
            type: Object
        },
        options: {
            required: true,
            type: Object
        },
        payment_method_discount: {
            required: false,
            default: () => {
                return {}
            }
        },
        payment_method_interest: {
            required: false,
            default: () => {
                return {}
            }
        },
        setProductQuantity: {
            type: Function,
            required: true
        },
        setProductPriceManual: {
            type: Function,
            required: true
        },
        setProductDiscountValue: {
            type: Function,
            required: true
        },
        setProductDiscountPercentage: {
            type: Function,
            required: true
        }
    },
    mounted(){
        setTimeout(() => {
            this.$nextTick(()=>{
                const key = `item-description-${this.item.id}`
                if (this.$refs[key]) {
                    this.$refs[key].focus()
                }
            })
        })
    },
    methods: {
        hideModal(){
            this.$emit('hide')
        }
    }
}
</script>

<template>
    <b-form @submit.prevent="hideModal">
        <b-card>
            <b-card-body>
                <b-row>
                    <b-col md="6" sm="12">
                        <b-form-group>
                            <template #label> Unidad <sup class="text-danger">*</sup></template>
                            <b-form-select
                                :ref="`item-${item.id}`"
                                v-model="item.measurement_unit"
                                :options="options.measurement_units"
                            >
                            </b-form-select>
                        </b-form-group>
                    </b-col>
                    <b-col md="6" sm="12">
                        <b-form-group>
                            <template #label> Bien / Servicio <sup class="text-danger">*</sup></template>
                            <b-form-select
                                v-model="item.product_type"
                                :options="options.product_types"
                            >
                            </b-form-select>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-form-group>
                    <template #label> Descripción <sup class="text-danger">*</sup> </template>


                    <b-form-textarea
                        :ref="`item-description-${item.id}`"
                        v-if="options.product_name_editable"
                        v-model="item.name"
                        placeholder="Ingrese descripción"
                        autocomplete="off"
                        rows="3"
                    >
                    </b-form-textarea>
                    <b-form-textarea
                        v-else
                        readonly
                        :value="item.name"
                        placeholder="Ingrese descripción"
                        autocomplete="off"
                        rows="3"
                    >
                    </b-form-textarea>
                </b-form-group>

                <b-row>
                    <b-col md="3" sm="12">
                        <b-form-group>
                            <template #label>
                                Precio <sup class="text-danger"> *</sup>
                            </template>
                            <b-form-input
                                v-if="options.product_price_editable"
                                @change="setProductPriceManual(item)"
                                size="sm"
                                type="number"
                                v-model="item.price"
                                min="0"
                                step="any"
                                autocomplete="off"
                            >
                            </b-form-input>
                            <b-form-input
                                v-else
                                :value="item.price"
                                size="sm"
                                type="number"
                                v-model="item.price"
                                min="0"
                                step="any"
                                autocomplete="off"
                                readonly
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                    <b-col md="3" sm="12">
                        <b-form-group>
                            <template #label>
                                Cantidad <sup class="text-danger"> *</sup>
                            </template>
                            <b-form-input
                                @change="setProductQuantity(item)"
                                size="sm"
                                type="number"
                                v-model="item.saleQuantity"
                                min="1"
                                step="any"
                                autocomplete="off"
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                    <b-col md="3" sm="12">
                        <b-form-group>
                            <template #label>
                                Interés
                            </template>
                            <b-form-input
                                size="sm"
                                type="number"
                                :value="item.interest_value"
                                min="1"
                                autocomplete="off"
                                disabled
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                    <b-col md="3" sm="12">
                        <b-form-group>
                            <template #label>
                                Subtotal
                            </template>
                            <b-form-input
                                size="sm"
                                type="number"
                                :value="item.final_subtotal"
                                min="1"
                                autocomplete="off"
                                disabled
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-form-group>
                    <template #label>
                        Descuento
                    </template>
                    <b-row v-if="!payment_method_discount.value">
                        <b-col md="6" sm="6">
                            <b-input-group>
                                <b-form-input
                                    @change="setProductDiscountPercentage(item)"
                                    size="sm"
                                    type="number"
                                    v-model="item.discount_percentage"
                                    min="0"
                                    step="any"
                                    autocomplete="off"
                                >
                                </b-form-input>
                                <template #prepend>
                                    <b-input-group-text >%</b-input-group-text>
                                </template>
                            </b-input-group>
                        </b-col>

                        <b-col md="6" sm="6">
                            <b-input-group>
                                <b-form-input
                                    @change="setProductDiscountValue(item)"
                                    size="sm"
                                    type="number"
                                    v-model="item.discount_value"
                                    min="0"
                                    step="any"
                                    autocomplete="off"
                                >
                                </b-form-input>
                                <template #prepend>
                                    <b-input-group-text >Q.</b-input-group-text>
                                </template>
                            </b-input-group>
                        </b-col>
                    </b-row>
                </b-form-group>

                <b-form-group>
                    <template #label>
                        Total
                    </template>
                    <b-form-input
                        size="sm"
                        type="number"
                        :value="item.total"
                        min="1"
                        autocomplete="off"
                        disabled
                    >
                    </b-form-input>
                </b-form-group>
                <hr>
                <div class="text-right">
                    <b-button type="submit" variant="primary">Confirmar</b-button>
                </div>
            </b-card-body>
        </b-card>
    </b-form>
</template>
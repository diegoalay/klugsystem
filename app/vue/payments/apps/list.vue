<script type="text/javascript">
    export default {
        components: {

        },
        data() {
            return {
                
            }
        }
    }
</script>

<template>
    <div>
        <b-card bg-variant="light">
            <b-form-group
            label-cols-lg="2"
            label="Destion"
            label-size="lg"
            label-class="font-weight-bold pt-0"
            class="mb-0"
            ></b-form-group>
            
            <b-form-group
                label="ID"
                label-for="id"
                label-cols-sm="3"
                label-align-sm="right"
            >
                <b-form-input id="nested-street"></b-form-input>
            </b-form-group>

            <b-form-group
                label="Destino:"
                label-for="destination"
                label-cols-sm="3"
                label-align-sm="right"
            >
                <b-form-input id="nested-city"></b-form-input>
            </b-form-group>

            <b-form-group
                label="Precio:"
                label-for="price"
                label-cols-sm="3"
                label-align-sm="right"
            >
                <b-form-input id="nested-state"></b-form-input>
            </b-form-group>

            <b-form-group
                label="Galonaje:"
                label-for="galonaje"
                label-cols-sm="3"
                label-align-sm="right"
            >
                <b-form-input id="nested-country"></b-form-input>
            </b-form-group>
            
            <b-form-group
                label="TOTAL:"
                label-for="total"
                label-cols-sm="3"
                label-align-sm="right"
            >
                <b-form-input id="nested-country"></b-form-input>
            </b-form-group>
        </b-card>
    </div>
</template>
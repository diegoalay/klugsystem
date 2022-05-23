<script>
export default {
    props: {
        inputText: {
            type: String,
            default: 'Contraseña'
        },
        inputRequired: {
            type: Boolean,
            default: true
        }
    },
    data() {
        return {
            showPassword: false,
            password: ''
        }
    },

    watch: {
        'password'(){
            this.$emit('input', this.password)
        }
    }
}
</script>


<template>
    <b-form-group>
        <template #label>
            {{ inputText }}
            <template v-if="inputRequired">
                <sup class="text-danger">*</sup>
            </template>
        </template>

        <b-input-group>
            <b-form-input
                name="password-input"
                autocomplete="off"
                :type="showPassword ? 'text' : 'password'"
                placeholder=""
                v-model="password"
            >
            </b-form-input>
            <b-input-group-prepend>
                <b-button variant="default" @click="showPassword = !showPassword">
                    <font-awesome-icon :icon="showPassword ? 'eye-slash' : 'eye'" />
                </b-button>
            </b-input-group-prepend>
        </b-input-group>
    </b-form-group>
</template>
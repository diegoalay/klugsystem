<script>
export default {
    props: {
        title: {
            default: null,
            type: String
        },
        subtitle: {
            default: null,
            type: String
        },
        buttons: {
            default: true,
            type: Boolean
        },
        titleButtonCreate: {
            default: "Crear",
            type: String
        },
        loading: {
            default: false,
            type: Boolean
        }
    },
    methods: {
        reloadList() {
            this.$emit("reloadList");
        }
    }
}
</script>
<template>
    <div class="navbar component-header-list">
        <div class="float-left">
            <h3 v-if="title" class="is-size-3">
                {{ title }}
            </h3>
            <h4 v-if="subtitle" class="is-size-4">
                {{ subtitle }}
            </h4>
        </div>
        <div class="float-right">
            <template name="buttons">
                <slot>
                    <b-button variant="outline-dark" class="mb-2" to="/new">
                        {{ titleButtonCreate }} <font-awesome-icon icon="list" />
                    </b-button>
                </slot>
            </template>
        </div>
    </div>
</template>
import appMeasurementUnitsList  from 'vueApp/inventory/measurement_units/apps/list.vue'
import appMeasurementUnitsNew   from 'vueApp/inventory/measurement_units/apps/new.vue'
import appMeasurementUnitsShow from 'vueApp/inventory/measurement_units/apps/show.vue'

const routes =  [
    {
        path: "/inventory/measurement_units",
        component: appMeasurementUnitsList
    },
    {
        path: "/inventory/measurement_units/new",
        component: appMeasurementUnitsNew
    },
    {
        path: "/inventory/measurement_units/:id",
        component: appMeasurementUnitsShow
    }
]

export default routes;

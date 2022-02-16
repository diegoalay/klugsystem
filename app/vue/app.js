import app from './core/app'

import dashboardRoutes from './dashboard/routes.js';

import cashRegisterRoutes from './cash_registers/routes.js';

import clientsRoutes from './clients/routes.js';

import expedituresRoutes from './expeditures/routes.js';

import salesRoutes from './sales/routes.js';

import productsRoutes from './products/routes.js';
import brandsRoutes from './brands/routes.js';
import employeeRoutes from './employees/routes.js';

import departmentsRoutes from './departments/routes.js';
import catalogClientTypes from './catalog_client_types/routes.js';
import catalogExpeditureTypes from './catalog_expediture_types/routes.js';
import catalogEventTypes from './catalog_event_types/routes.js';

import paymentMethods from './payment_methods/routes.js';
import branchOffices from './branch_offices/routes.js';

app("",
    dashboardRoutes
    .concat(salesRoutes)
    .concat(clientsRoutes)
    .concat(cashRegisterRoutes)
    .concat(expedituresRoutes)
    .concat(productsRoutes)
    .concat(brandsRoutes)
    .concat(departmentsRoutes)
    .concat(employeeRoutes)
    .concat(catalogClientTypes)
    .concat(catalogExpeditureTypes)
    .concat(catalogEventTypes)
    .concat(paymentMethods)
    .concat(branchOffices)
)
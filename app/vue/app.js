import app from './core/app'

import dashboardRoutes from './dashboard/routes.js';

import cashRegisterRoutes from './cash_registers/routes.js';

import clientsRoutes from './crm/clients/routes.js';
import contactsRoutes from './crm/contacts/routes.js';
import crmEventsRoutes from './crm/events/routes.js';

import expedituresRoutes from './expeditures/routes.js';

import salesRoutes from './sales/routes.js';

import productsRoutes from './products/routes.js';
import brandsRoutes from './brands/routes.js';
import employeeRoutes from './employees/routes.js';

import departmentsRoutes from './departments/routes.js';
import catalogEventTypesRoutes from './catalog_event_types/routes.js';
import catalogClientTypesRoutes from './catalog_client_types/routes.js';
import catalogExpeditureTypesRoutes from './catalog_expediture_types/routes.js';
import catalogProductTransactionTypesRoutes from './catalog_product_transaction_types/routes.js';

import paymentMethodsRoutes from './payment_methods/routes.js';
import branchOfficesRoutes from './branch_offices/routes.js';

import booksRoutes from './books/routes.js'

import profileRoutes from './profile/routes.js'

app("",
    dashboardRoutes
    .concat(salesRoutes)
    .concat(clientsRoutes)
    .concat(contactsRoutes)
    .concat(crmEventsRoutes)
    .concat(cashRegisterRoutes)
    .concat(expedituresRoutes)
    .concat(productsRoutes)
    .concat(brandsRoutes)
    .concat(departmentsRoutes)
    .concat(employeeRoutes)
    .concat(catalogClientTypesRoutes)
    .concat(catalogExpeditureTypesRoutes)
    .concat(catalogProductTransactionTypesRoutes)
    .concat(catalogEventTypesRoutes)
    .concat(paymentMethodsRoutes)
    .concat(branchOfficesRoutes)
    .concat(booksRoutes)
    .concat(profileRoutes)
)
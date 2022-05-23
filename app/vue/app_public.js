import app from './core/app_public'

import userSessions from 'vuePublicApp/users_sessions/routes.js';
import userPasswords from 'vuePublicApp/users_passwords/routes.js';

app("",
    userSessions
    .concat(userPasswords)
)